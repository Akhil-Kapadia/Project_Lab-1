module servo(
input clk,
input [2:0] servo_flag,
input s_pulse,
output reg [18:0] s_duty,
output SERVO
);

//Outputs pwm to servo motor to change its position.
assign SERVO = s_pulse;

//always @ (posedge clk)
//begin
//	if (servo_flag[1])
//		while (s_duty <= 200000)
//			s_duty <= s_duty + 1;
//	if (servo_flag[2])	
//		while (s_duty >= 100000)
//			s_duty <= s_duty - 1;
//	if (servo_flag[0])
//	begin
//		while (s_duty != 150000)
//			s_duty = (s_duty>150000) ? s_duty - 1 : s_duty +1;
//	end
//end
endmodule