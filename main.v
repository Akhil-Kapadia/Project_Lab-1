module main(
	input clk,
	//input pulse,
	//input [11:0] duty,
	output [3:0] an,
	output [6:0] seg,
	input [1:0] OC,
	output [3:0] IN,
	output [1:0] EN,
	input [7:0] sw
);

wire pulse;
wire [11:0] duty;

//instantiate pwm with duty set be rate at 25khz.
pwm freq(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);

switch flips(
	.clk (clk),
	.sw (sw),
	.IN (IN),
	.EN (EN),
	.OC (OC),
	.duty (duty),
	.pulse (pulse)
);

sevenSeg disp(
	.clk (clk),
	.OC (OC),
	.an (an),
	.seg (seg),
	.sw (sw)
);

endmodule