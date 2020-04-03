module color_sensor(
	input clk,
	input [1:0] CS,
	input reg [15:0] frequency,
	input reg [15:0] color,
	output reg [15:0] red,
	output reg [15:0] green,
	output reg [15:0] blue,
	output reg [15:0] clear
);
//Internal regs
reg [1:0] S;
initial begin
    S = 0;
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
     if (frequency > 0)
       begin
          case (CS)
            0: red <= frequency;
            1: green <= frequency;
            2: clear <= frequency;
            3: blue <= frequency;
          endcase
          S <= S + 1;
		  		  
       end  
  end		
  
endmodule	