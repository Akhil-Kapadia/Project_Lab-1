module servo(
input clk,
	input [1:0] servo_flag,
output MAGNET,
output reg [18:0] s_duty,
output reg move_flag,
output SERVO,
input s_pulse
);

//Count used for increment
reg [9:0] count = 0;

assign SERVO = s_pulse;

//move_flag_reset used for pulse extension
reg [1:0] move_flag_reset = 0;
reg [1:0] mode;
reg [1:0] servoFlag;
reg magnetEnable;
reg moveFlag;
reg servoFlagPrev = 0;

assign MAGNET = magnetEnable;

always @(posedge clk)
begin

	if(servoFlagPrev == 0 && servo_flag[1] == 1)
	begin
		if(servo_flag[0])
		begin
			mode = 2'b10;
		end
		else
		begin
			mode = 2'b01;
		end
	end
	servoFlagPrev = servo_flag[1];

	
	//Resets move flag back to 0 after a clock pulse pass
	if(move_flag == 1)
	begin		
	if(move_flag_reset == 3)
		begin
			move_flag = 0;
			move_flag_reset = 0;
		end
		else
			move_flag_reset = move_flag_reset + 1;
	end

	if(servo_flag[1])
	begin
		//Count used to slow down Servo
		count = count + 1;
	
		//Mode used to change the servo + magnet pair
		case(mode)
			2'b01://DropOff
			begin
				if(~moveFlag)
				begin
					magnetEnable = 1;
					servoFlag = 2'b10;
				end
				else
				begin
					moveFlag = 0;
					magnetEnable = 0;
					mode = 2'b00;
				end
			end
			2'b10://PickUp
			begin
				if(~moveFlag)
				begin
					magnetEnable = 1;
					servoFlag = 2'b01;
				end
				else
				begin
					moveFlag = 0;
					mode = 2'b00;
				end
			end
			2'b00://Back To Neutral
			begin
				if(~moveFlag)
					servoFlag = 2'b00;
				else
				begin
					moveFlag = 0;
					magnetEnable = 0;
				end
			end
		endcase
	

		//Same servo movement
		if(count == 0 && servo_flag[1])
		begin
			case(servoFlag)
				2'b00: //To Neutral (90)
				begin
					if (s_duty < 164500 || s_duty > 165500)
					begin
						if(s_duty < 165000)
							s_duty = s_duty + 1;
						if(s_duty > 165000)
							s_duty = s_duty -1;
					end
					else 
					begin
						move_flag = 1;
						moveFlag = 1;
					end
				end
				2'b01: //To Pickup (0)
				begin
					if (s_duty > 72000)
						s_duty = s_duty -1;
					else 
						moveFlag = 1;
				end
				2'b10: //To Dropoff (180)
				begin
					if (s_duty < 253000)
						s_duty = s_duty + 1;
					else 
						moveFlag = 1;
				end
			endcase
		end
	end
end
endmodule

