module Distance_sensor(
    input [3:0] DIS,
    output [1:0] dist_state
);
//Sets output flag to 1 if IR distance sensors (1 and 2) or (3 and 4) detect the station.
assign dist_state[0] = (&DIS[1:0]);
assign dist_state[1] = (&DIS[3:2]);
endmodule