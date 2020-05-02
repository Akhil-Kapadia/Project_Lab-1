module Distance_sensor(
    input clk,
    input [3:0] DIS,
	output [1:0] proximity,
    output [1:0] dist_state
);
//Sets output flag to 1 if IR distance sensors (1 and 2) or (3 and 4) detect the station.
assign dist_state[0] = &DIS[1:0];
assign dist_state[1] = &DIS[3:2];

//For rising edge of all distance sensors.
wire [1:0] prox;
reg [1:0] proximity_last;

//Detection for both sides.
assign prox[0] = &DIS[1:0];
assign prox[1] = &DIS[3:2];

//latch for delayed prox
always @ (posedge clk)
begin
	proximity_last[0] <= prox[0];
	proximity_last[1] <= prox[1];
end

//Outputs 1 for rising edge of proximity.
assign proximity[0] = prox[0] & ~proximity_last[0];
assign proximity[1] = prox[1] & ~proximity_last[1];
	
endmodule