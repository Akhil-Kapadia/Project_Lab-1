module servo(
input clk,
input [1:0] servo_flag,
input s_pulse,
output reg [18:0] s_duty,
output SERVO,
output reg move_flag
);

//Count used for increment
reg [9:0] count = 0;

//move_flag_reset used for pulse extension
reg move_flag_reset = 0;

always @ (posedge clk)
begin
	//Count used to slow down Servo
    count = count +1;

	//Resets move flag back to 0 after a clock pulses pass
	if(move_flag == 1)
	begin
		if(move_flag_reset == 1)
		begin
			move_flag = 0;
			move_flag_reset = 0;
		end
		else
			move_flag_reset = 1;
	end
	
	//Servo Movement
	//Count used to slow down motor
	//Move_Flag used to prevent movement of Servo until move_flag has been read
	if(count == 0 && move_flag == 0)
	begin
		case (servo_flag)
			2'b00://To 90
			begin
				if (s_duty < 164500 || s_duty > 165500)
				begin
					if(s_duty < 165000)
						s_duty = s_duty + 1;
					if(s_duty > 165000)
						s_duty = s_duty -1;
				end
				else 
					move_flag = 1;
			end
			2'b01: //To 0
			begin
				if (s_duty > 72000)
					s_duty = s_duty -1;
				else 
					move_flag = 1;
			end
			2'b10: //To 180
		  begin
				if (s_duty < 253000)
					s_duty = s_duty + 1;
				else 
					move_flag = 1;
			end
		endcase
	end
end
endmodule