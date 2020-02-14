module testbench;

reg clk;
reg [1:0] OC = 1'b00;
reg [7:0] sw = 8'b10100001;
wire [3:0] IN;
wire [1:0] EN;
wire [6:0] seg;
wire [3:0] an;
reg pulse1;
wire pulse2;
reg [11:0] duty1;
wire [11:0] duty2;
	 
pwm freq_UUT(
	.clk (clk),
	.duty (duty1),
	.pulse (pulse2)
);

switch flips_UUT(
	.clk (clk),
	.sw (sw),
	.IN (IN),
	.EN (EN),
	.OC (OC),
	.duty (duty2),
	.pulse (pulse1)
);

sevenSeg disp_UUT(
	.clk (clk),
	.OC (OC),
	.an (an),
	.seg (seg),
	.sw (sw)
);
	 
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          duty1 = duty2;
          pulse1 = pulse2;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule