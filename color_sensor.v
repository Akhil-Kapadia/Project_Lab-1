module color_sensor(
	input clk,
	input [18:0] frequency,
	input [7:0] color,
	input calc_done,
	input diode_change,
	output [1:0] CS,
	output reg calc_EN,
	output reg calc_reset,
	output reg [18:0] clear,
	output reg [18:0] color_raw,
	output reg [2:0] color_detected
);      
//Internal regs
reg [1:0] S;
reg [7:0] red;
reg [7:0] green;
reg [7:0] blue;
initial begin
    S = 2;
	clear = 1;
	color_raw = 1;
	red <= 0;
	green <= 0;
	blue <= 0;
	color_detected <= 0;
end
assign CS = S;
//Change the color coming in via CS.
// RED		00	0
// GREEN	01	1
// BLUE		11	3
// CLEAR	10	2

always @ (posedge clk)
  begin  
  //Sets the individual color frequencies to whatever its supposed to be.
    if(diode_change)
		  case (S)
            0: begin	//Red color	%
					color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
					calc_EN <= 1;				//Start calculations
					calc_reset <= 0; 
					S <= 2'b01;
				end
            1: begin	// Green color %
					color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
					calc_EN <= 1;				//Start calculations
					calc_reset <= 0;
					S <= 2'b11;
			   end
            2: begin    //Always get clear first before other colors.
					clear <= frequency; 
					S <= 2'b00;
			   end
            3: begin    //Blue Color %
					color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
					calc_EN <= 1;				//Start calculations
					calc_reset <= 0;
					S <= 2'b10;
				end
          endcase
		
		if(calc_done)
		begin
		//Store percentage color/clear in local regs for comparison.
		//Since the diode (S) changes before the calculation, we keep this in mind when assigning color.
			case(S)
			0:begin end
			1:red <= color;
			2:blue <= color;
			3:green <= color;
			endcase
		//Reset calculations
			calc_EN <=0;
			calc_reset <= 1;
		end
		
       
       //Compare Colors to see which is more prominent.  
	   //First make sure none are zero.
       if((red !=0) || (blue != 0) || (green !=0))
		//Which ever is largest (smallest) is the most prominent.
		begin
			if((red > blue ) && (red > green))	//Red
				color_detected <= 3'b100;
			if((green > blue) && (green > red))	//Green
				color_detected <= 3'b010;
			if((blue > green) && (blue > red))	//Blue
				color_detected <= 3'b001;	
		end
	   
  end		
  
endmodule	