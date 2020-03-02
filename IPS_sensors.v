module IPS_Sensor(
input clk,
input [2:0] IPS,
input speed,
output IN[3:0],
output EN[1:0],
);

assign IN[3:0] = (IPS[1]) ? 4'b1001 : 				//If middle IPS lit, Go forwards.
				 (IPS[0]) ? 4'b1010 :				//If left IPS lit, Go left.
				 (IPS[2]) ? 4'b0101 : 4'b0000;		//If right IPS lit, go right. If none lit stop.

assign EN[1:0] = {2{speed}};		//Sets the enable to always equal pwm pulse (speed).

endmodule