module flag_handling(
input clk,
input SCL,
input sw_ON,
input [1:0] dist_flag,
input pulse,
output [1:0] EN,
output [2:0] servo_flag,
input move_flag
);

//Local variables 
// output reg [width-1:0] duty;
assign EN[1:0] = (~sw_ON)    ? 	0 :
                 (servo_flag[0] && ~move_flag) ? {2{pulse}} :
				 (|dist_flag) ?  0 :
				 {2{pulse}};

assign servo_flag[2:0] = move_flag ? 3'b001 :
                         dist_flag[0] ? 3'b100 :
                         dist_flag[1] ? 3'b010 :
                         3'b000;
/*
assign mag_flag = move_flag && servo_flag[2] ? 0 :
                  move_flag && servo_flag[1] ? 1 :
                  ~move_flag && servo_flag[0] ? 0 :
                  0;

*/
endmodule