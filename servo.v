module servo(
input clk,
input [2:0] servo_flag,
input s_pulse,
output reg [18:0] s_duty,
output SERVO,
output move_flag
);

reg moved_flag;
//Outputs pwm to servo motor to change its position.
assign SERVO = s_pulse;
assign move_flag = moved_flag;

always @ (posedge clk)
begin
	if (servo_flag[1])
		if(s_duty <= 200000) // Change 200000 to 250000 to do width check 
			s_duty <= s_duty + 1;
	    else
	        moved_flag <= 1;
	if (servo_flag[2])	
		if (s_duty >= 100000) // Change 100000 to 150000 to do width check
			s_duty <= s_duty - 1;
		else 
		    moved_flag <= 1;
	if (servo_flag[0])
	begin
		if (s_duty != 150000) // Change 150000 to 200000 to do width check
			s_duty = (s_duty>150000) ? s_duty - 1 : s_duty +1;
		else 
		  moved_flag <= 0;
	end
end
endmodule