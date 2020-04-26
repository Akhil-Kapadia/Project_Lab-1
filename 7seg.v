//Adapted from Rice Rodrigues tutorial code.


//-----------------------------------------------------
//Module For Seven Segment Display
//-----------------------------------------------------
module sevenSeg(
	input clk,
	output reg [3:0] an,
	output reg [6:0] seg,
	input [1:0] MSM,
	input [2:0] color,
	input [1:0] CS
);
//local registers
reg [18:0] count;
always @ (posedge clk)
	count = count + 1;
wire [1:0] refresh;
assign refresh = count[18:17];//Refreshing Display

always @(*)
begin

	case(refresh)
	2'b00:	begin //	Sets 7seg to display "1" or "0" depending if overcurrent detected.
				an = 4'b0111;
//				seg = (color[2]) ? 7'b0101111 :
//				      (color[1]) ? 7'b0000010 :
//				      (color[0]) ? 7'b0000011 : 7'b0101011;
				case(color)
				3'b001: seg = 7'b0000011;	//Blue "b"
				3'b010: seg = 7'b0000010;	//Green "G"
				3'b100: seg = 7'b0101111;	//Red "r"
				default seg = 7'b0101011;	// "n"
				endcase
			end
	2'b01:  begin //Turned off
				an = 4'b1011;
                seg = 7'b1111111;
//               case(CS)
//               0: seg = 7'b0101111;
//               1: seg = 7'b0000010;
//               2: seg = 7'b0100111;
//               3: seg = 7'b0000011;
//               endcase
			end
	2'b10:  begin //Displays "P" if picking up or "b" if dropping off. If neither turns off
				an = 4'b1101;
				seg = (MSM == 2) ? 7'b0001100 :
					  (MSM == 3) ? 7'b0000011 : 7'b1111111;
			end
	2'b11:  begin //Displays 0 or 1 if rover is on or not.
				an = 4'b1110;
				seg = (MSM != 0) ? 7'b1111001 : 7'b1000000;
			end
	endcase
end
endmodule