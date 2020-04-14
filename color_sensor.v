module color_sensor(
	input clk,
	input [15:0] frequency,
	input color,
	input calc_done,
	input diode_change,
	output [1:0] CS,
	output reg calc_EN,
	output reg calc_reset,
	output reg [15:0] clear,
	output reg [15:0] color_raw,
	output reg [2:0] color_detected
);      
//Internal regs
reg [1:0] S;
reg [15:0] red;
reg [15:0] green;
reg [15:0] blue;
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
  
  //Resets the perc calc to ensure clean calculation.

  //Sets the individual color frequencies to whatever its supposed to be.
          case (S)
            0: begin	//Red color	%
					if(diode_change)
					begin
						color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
						calc_EN <= 1;				//Start calculations
						calc_reset <= 0;
					end
					if(calc_done)
					begin
					    red <= color;					//store value in local reg
						calc_EN <= 0;					// Disable calculation
						calc_reset <= 1;				//Reset calculations.
						S <= (diode_change) ? 2'b01 : S;	//Change the diode if its time to.
					end
				end
            1: begin	// Green color %
					if(diode_change)
					begin
						color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
						calc_EN <= 1;				//Start calculations
						calc_reset <= 0;
					end
					if(calc_done)
					begin
					    green <= color;					//store value in local reg
						calc_EN <= 0;					// Disable calculation
						calc_reset <= 1;				//Reset calculations.
						S <= (diode_change) ? 2'b011 : S;	//Change the diode if its time to.
					end
				end
            2: begin    //Always get clear first before other colors.
					if(diode_change)
					begin
						clear <= frequency;
						S <= 2'b00;
					end
				end
            3: begin    //Blue Color %
					if(diode_change)
					begin
						color_raw <= frequency;		//set reg to be outputed to normalizer to input from freq_counter
						calc_EN <= 1;				//Start calculations
						calc_reset <= 0;
					end
					if(calc_done)
					begin
					    red <= color;					//store value in local reg
						calc_EN <= 0;					// Disable calculation
						calc_reset <= 1;				//Reset calculations.
						S <= (diode_change) ? 2'b010 : S;	//Change the diode if its time to.
					end
				end
          endcase
       
       //Compare Colors to see which is more prominent.  
       if((red !=0) || (blue != 0) || (green !=0))
            color_detected <= 1;
//       begin
//			if((red > blue ) && (red > green))
//				color_detected <= 3'b100;
//			if((green > blue) && (green > red))
//				color_detected <= 3'b010;
//			if((blue > green) && (blue > red))
//				color_detected <= 3'b001;	
//       end
	   
  end		
  
endmodule	