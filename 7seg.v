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
	input [3:0] IR
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
				case(color)
				3'b001: seg = 7'b0000011;	//Blue "b"
				3'b010: seg = 7'b0000010;	//Green "G"
				3'b100: seg = 7'b0101111;	//Red "r"
				default seg = 7'b0101011;	// "n"
				endcase
			end
	2'b01:  begin //Displays which IR signal we are getting.
	
	
				an = 4'b1011;
                seg = 7'b1111111;
                case(IR)
				4'b0001: seg = 7'b1000000;
				4'b0010: seg = 7'b1111001;
				4'b0100: seg = 7'b0100100;
				4'b1000: seg = 7'b0110000;
                endcase
			end
	2'b10:  begin //Displays "P" if picking up or "b" if dropping off. If neither turns off
				an = 4'b1101;
				seg = (MSM == 2) ? 7'b0001100 :
					  (MSM == 3) ? 7'b0000011 : 7'b1111111;
			end
	2'b11:  begin //Displays the current state for the MSM
				an = 4'b1110;
				case(MSM)
				0: seg = 7'b1000000;
				1: seg = 7'b1111001;
				2: seg = 7'b0100100;
				3: seg = 7'b0110000;
				default seg = 7'b1111111;
				endcase
			end
	endcase
end
endmodule