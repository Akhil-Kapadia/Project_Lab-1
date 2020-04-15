module Distance_sensor(
    input [3:0] DIS,
    output dist_state
);
//Sets output flag to 1 if IR distance sensors (1 and 2) or (3 and 4) detect the station.
assign dist_flag = (&DIS[1:0] || &DIS[3:2]) ? 1 : 0;

endmodule