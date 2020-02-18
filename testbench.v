module testbench;

reg clk;
reg [1:0] OC = 2'b00;
reg [7:0] sw = 8'b10010001;
wire [3:0] IN;
wire [1:0] EN;
//wire [6:0] seg;
//wire [3:0] an;
wire [19:0] duty = sw[7:4] * 65535;
wire pulse;
pwm freq_UUT(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);

switch flips_UUT(
	.clk (clk),
	.sw (sw),
	.IN (IN),
	.EN (EN),
	.OC (OC),
	.duty (duty),
	.pulse (pulse)
);

//sevenSeg disp_UUT(
//	.clk (clk),
//	.OC (OC),
//	.an (an),
//	.seg (seg),
//	.sw (sw)
//);
	 
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule