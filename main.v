module main(
input clk,
input pulse,
input [1:0] JAI,
output [7:2] JA,
input [7:0] sw
reg rate
);

//instaniate pwm with duty set be rate at 25khz.
pwm freq(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);


endmodule