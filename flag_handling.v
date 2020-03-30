module flag_handling(
input clk,
input SCL,
input sw_ON,
input dist_flag,
input pulse,
output [1:0] EN,
output servo_flag
);

//Local variables 
// output reg [width-1:0] duty;
assign EN[1:0] = (~sw_ON)    ? 	0 :
				 (dist_flag) ?  0 :
				 {2{pulse}};

endmodule