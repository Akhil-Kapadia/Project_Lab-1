module color_sensor(
	input clk,
	input [1:0] CS,
	input [15:0] frequency,
	input red,
	input green,
	input blue,
	input diode_change,
	output reg [15:0] red_raw,
	output reg [15:0] green_raw,
	output reg [15:0] blue_raw,
	output reg [15:0] clear
);
//Internal regs
reg [1:0] S;
initial begin
    S = 2;
end
assign CS = S;
//Change the color coming in via CS.
// RED		00	0
// GREEN	01	1
// BLUE		11	3
// CLEAR	10	2

always @ (posedge clk)
  begin
	   red_raw <= frequency;  
  //Sets the individual color frequencies to whatever its supposed to be.
     if (diode_change)
       begin

          case (CS)
            0: begin
					//red_raw <= frequency;
					S <= 2'b01;
				end
            1: begin
					green_raw <= frequency;
					S <= 2'b11;
				end
            2: begin
					clear <= frequency;
					S <= 2'b00;
				end
            3: begin
					blue_raw <= frequency;
					S <= 2'b10;
				end
          endcase
		  
       end  
  end		
  
endmodule	