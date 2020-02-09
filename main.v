module main(
input pulse,
output [7:0] JA,	//Not sure how to output signal to pmod. How many bits is it? What bus should it use?
//input boolean variable from switches
);
//Connect all the modules together here.

//Set the frequency to 1KHz, as pwm doesn't affect motors speed if freq is higher.
//not sure how, maybe a clock divider?


//Output pulse to pmod.
//We want motor speeds to be synchronous, so we'll output pulse to hbridge input 1 & 3. (+ voltage)
//And we'll output the inverse(?) to inputs 2 & 4. (-voltage)
//Or should they all be the same?
always @ (JA)
	if (JA[4] < 1);	//If current comparator circuit outputs <1, then set enables to 1.
		begin
			JA[1] = 1;	//Pins to ribbon cable for hbridge enables.
			JA[0] = 1;
		end
	else	//If not then set enables to 0. Turn off motors.
		begin
			JA[0] = 0;	//Pins to ribbon cable for hbridge enables.
			JA[1] = 0;
		end
	end

//set input[1-4] of hbridge to pulse of pwm,
JA[7] <= pulse;		//We use nonblocking here to keep pulses synchronous. I hope.
JA[6] <= pulse;
JA[5] <= pulse;
JA[4] <= pulse;

endmodule