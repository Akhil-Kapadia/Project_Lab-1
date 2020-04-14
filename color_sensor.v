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
     if (diode_change)
       begin
	   calc_reset <= 1;
	   calc_EN <= 0;
          case (S)
            0: begin	//Red color	%
					color_raw <= frequency;
					calc_EN <= 1;
					calc_reset <= 0;
					wait(calc_done)
					begin
					    red <= color;
					end
					//red <= (color != 0) ? color : red;
				    $display("Red Color is %d", red);
					S <= 2'b01;
				end
            1: begin	// Green color %
					color_raw <= frequency;
					calc_EN <= 1;
					calc_reset <= 0;
					wait(calc_done)
					begin 
						green <= color;
					end
					S <= 2'b11;
				end
            2: begin    //Always get clear first before other colors.
					clear <= frequency;
					S <= 2'b00;
				end
            3: begin    //Blue Color %
					color_raw <= frequency;
					calc_EN <= 1;
					calc_reset <= 0;
					wait(calc_done)
					begin
						blue <= color;
					end
					S <= 2'b10;
				end
          endcase
       end  
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