module main(
	input clk,
	input pulse,
	input duty,
	output reg [3:0] an,
	output reg [6:0] seg,
	input [1:0] OC,
	output [3:0] IN,
	output [1:0] EN,
	input [7:0] sw
);

//instaniate pwm with duty set be rate at 25khz.
pwm freq(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);

switches flips(
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