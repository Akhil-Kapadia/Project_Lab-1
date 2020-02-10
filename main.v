module main(
input pulse,
output [7:0] JA,	//Not sure how to output signal to pmod. How many bits is it? What bus should it use?
//input boolean variable from switches
);
//Connect all the modules together here.

//Set the frequency to 1KHz, as pwm doesn't affect motors speed if freq is higher.
//not sure how, maybe a clock divider?

//Control direction of current and motors here by detecting comparator signal and sending signal to input[1-4] on hbridge


//Set the enables to pulse to change speed of motors/
always @ (sw)

assign JA[0] = pulse;		
assign JA[1] = pulse;

endmodule