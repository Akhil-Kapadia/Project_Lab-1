module switches(
input sw [7:0],
input led [7:0],
input JA [7:0] ,	//PMOD for output to basys board.
output reg [7:0] disp1,	// output to 7seg.
output reg [7:0] duty;
)

always @ (sw)
//Switch case that uses sw[0-8].
case (sw)	//Preferably I want sw[2-7] to increase duty cycle by 40 to increase speed of motors. IDK how to do that though. If multiple switches are on then that will create problems I'm sure...
	b'000: //1st switch Set both enables to 1 to start motors motors
		begin
			JA[0]=1;
			JA[1]=1;
		end
	b'001 //2nd switch. Reverse the current flow, change 7seg to display B (backwards).
		begin 
			//Set a boolean variable here, which will be used to swap the inputs on the hbridge. (Should reverse flow??)
			disp1 = 7'b0000000
		end
	b'010 //3rd Switch lowest pwm, slow motor speed. Set duty cycle here.
		begin
			duty = d'40;
		end
	b'011 //Increase pwm duty cycle to make motor faster.
		begin
			duty = d'80;
		end
	b'100
		begin
			duty = d'120;
		end
	b'101
		begin
			duty = d'160;
		end
	b'110
		begin
			duty = d'200;
		end
	b'111
		begin
			duty=d'255;
		end
endcase


endmodule