module IPS_sensors(
input clk,
input [2:0] IPS,
input speed,
input sw_ON,
output [3:0] IN,
output [1:0] EN
);
reg [3:0] IN_Last;

localparam max =200_000_000;

assign IN[3:0] = (~IPS[1]) ? 4'b1001 : 				//If middle IPS lit, Go forwards.
				 (~IPS[2]) ? 4'b1010 :				//If left IPS lit, Go left.
				 (~IPS[0]) ? 4'b0101 : IN_Last;				//If right IPS lit, go right. If none lit stop.

//Latch to retain last value.
always @ (posedge clk)
	IN_Last <= IN;
	
assign EN[1:0] = (sw_ON) ? {2{speed}}: 0;		//Sets the enable to always equal pwm pulse (speed).

endmodule