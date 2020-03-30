module IPS_sensors(
input clk,
input [2:0] IPS,
output [3:0] IN
);
reg [3:0] IN_Last;

assign IN[3:0] = (~IPS[1]) ? 4'b1001 : 				        //If middle IPS lit, Go forwards.
				 (~IPS[2]) ? 4'b1010 :				        //If left IPS lit, Go left.
				 (~IPS[0]) ? 4'b0101 : IN_Last;	   			//If right IPS lit, go right. If none lit stop.

//Latch to retain last value.
always @ (posedge clk)
	IN_Last <= IN;
	
endmodule