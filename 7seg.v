//Adapted from Rice Rodrigues tutorial code.


//-----------------------------------------------------
//Module For Seven Segment Display
//-----------------------------------------------------
module sevenSeg(
	input clk,
	input [1:0] JAI,
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
				seg = (JA[1:0]) ? 7'b1111001 : 7'b10000000
			end
	2'b01:  begin //Displays A for Amps
				an = 4'b1011;
                seg = 7'b0001000;
			end
	2'b10:  begin //Displays "F" or "b" for forwards of backwards movement
				an = 4'b1101;
				seg = (sw[1]) ? 7'b0000011 : 7'b00001110 ;
			end
	2'b11:  begin //Displays "r" and "L", for right and left movement.
				an = 4'b1110;
				if(sw[3:2])
				begin
					seg = (sw[2]) ? 7'b10011111 : 7'b10001111 ;
				end
			end
	endcase
end
endmodule