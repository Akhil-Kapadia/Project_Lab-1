module Distance_sensor(
    input clk,
    input [3:0] DIS,
	output proximity,
    output [1:0] dist_state
);
//Sets output flag to 1 if IR distance sensors (1 and 2) or (3 and 4) detect the station.
assign dist_state[0] = &DIS[1:0];
assign dist_state[1] = &DIS[3:2];

//For rising edge of all distance sensors.
wire prox;
reg proximity_last;

//Detection for both sides.
assign prox = (&DIS[1:0] || &DIS[3:2]);

//latch for delayes prox
always @ (posedge clk)
	proximity_last <= proximity;

//Outputs 1 for rising edge of proximity.
assign proximity = prox & ~proximity_last;
	
endmodule