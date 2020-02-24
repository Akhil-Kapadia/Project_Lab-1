//Adapted from Rice Rodrigues tutorial code.


//-----------------------------------------------------
//Module For Seven Segment Display
//-----------------------------------------------------
module sevenSeg(
	input clk,
	input [1:0] OC,
	output reg [3:0] an,
	output reg [6:0] seg,
	input [7:0] sw
);

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
				seg = (OC[1]||OC[0]) ? 7'b1111001 : 7'b1000000 ;
			end
	2'b01:  begin //Displays A for Amps
				an = 4'b1011;
                seg = 7'b0001000;
			end
	2'b10:  begin //Displays "F" or "b" for forwards of backwards movement
				an = 4'b1101;
				seg = (sw[1]) ? 7'b0000011 : 7'b0001110 ;
			end
	2'b11:  begin //Displays "r" and "L", for right and left movement. Off if neither.
				an = 4'b1110;
				seg = (sw[2]) ? 7'b0101111 : 
					  (sw[3]) ? 7'b1000111 :
								7'b1111111 ;
			end
	endcase
end
endmodule