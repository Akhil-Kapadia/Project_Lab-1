module main(
input pulse,
output [0:0] JA,	//Not sure how to output signal to pmod. How many bits is it? What bus should it use?
//input boolean variable from switches
);
//Connect all the modules together here.

//Set the frequency to 1KHz, as pwm doesn't affect motors speed if freq is higher.
//not sure how, maybe a clock divider?


//Output pulse to pmod.
//We want motor speeds to be synchronous, so we'll output pulse to hbridge input 1 & 3. (+ voltage)
//And we'll output the inverse(?) to inputs 2 & 4. (-voltage)
//Or should they all be the same?

