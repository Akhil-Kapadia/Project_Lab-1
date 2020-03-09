module IPS_sensors(
input clk,
input [2:0] IPS,
input speed,
input sw_ON,
output [3:0] IN,
output [1:0] EN
);
reg find_path = 1;
reg [31:0] count=32'b0;
reg [1:0] seconds = 4'b0;

localparam max =200_000_000;
reg [3:0] IN_Last;

assign IN[3:0] = (~IPS[1]) ? 4'b1001 : 				//If middle IPS lit, Go forwards.
				 (~IPS[2]) ? 4'b1010 :				//If left IPS lit, Go left.
				 (~IPS[0]) ? 4'b0101 : 4'b0000;				//If right IPS lit, go right. If none lit stop.
//				 (find_path) ? 4'b1010 : 4'b0101;	//If path lost turn left 90 degrees, if still not found turn right 180.

//Latch to retain last value.
always @ (posedge clk)
	IN_Last <= IN;
	

//If path is lost, start turning left for 2 seconds (~90), if still not found turn right untill it is.
//always @ (posedge clk)
//begin
//	if (&IPS[2:0])
//	begin
//		if(count >= max)
//		begin
//			count =0;
//			seconds = seconds +1;
//		end
//		else
//		begin
//			count <=count +1;
//			if(seconds >= 1)
//				find_path <= 0;
//		end
//	end
//	else
//		find_path = 1;
//end
	

assign EN[1:0] = (sw_ON) ? {2{speed}}: 0;		//Sets the enable to always equal pwm pulse (speed).

endmodule