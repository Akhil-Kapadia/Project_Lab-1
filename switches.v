module switches(
input [7:0] sw ,
input [7:6] JA  ,	//PMOD for input to basys board.
output reg [5:0] JA ,	//PMOD for output to basys board.
output reg [7:0] disp1,	// output to 7seg.
output reg [7:0] duty;
)

always @ (sw)
//Switch case that uses sw[0-8].
case (sw)	//Case statement might not be best here. Will find out Tuesday.
	2b'000: //1st switch turns on motors, but we want to check the comparator signal first.
		begin
		//Control direction of current and motors here by detecting comparator signal and sending signal to input[1-4] on hbridge.
			if (sw[0] == 1 && JA[7:6] == 1b'11 ) //Might change this so i don't always have to check JA
				begin
					assign JA[3:0] = 3b'1001;
				end
			else
				begin
					assign JA[3:0] = 1b'0000;
				end
		end
	2b'001: //2nd switch. Reverse the current flow, change 7seg to display B (backwards).
		begin
			if (sw[1] == 1 && JA[7:6] == 1b'11)
				begin
					assign JA[3:0] = 3b'1001; //Forwards.
				end
			else
				begin
					assign JA[3:0] = 3b'0110; //Backwards
				disp1 = 7'b0000000;	// Set 7seg display to "B"
				end				
		end
	2b'010: //3rd Switch lowest pwm, slow motor speed. Set duty cycle here.
		begin
			if (
		end
	2b'011: //Increase pwm duty cycle to make motor faster.
		begin
			duty = d'80;
		end
	2b'100:
		begin
			duty = d'120;
		end
	2b'101:
		begin
			duty = d'160;
		end
	2b'110:
		begin
			duty = d'200;
		end
	2b'111:
		begin
			duty=d'255;
		end
	default:
endcase


endmodule