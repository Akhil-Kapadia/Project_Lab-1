module testbench;

reg clk;
reg [15:0] duty = 32768;
wire [15:0] color_freq;
pwm #(16,15422)
freq_UUT(
	.clk (clk),
	.width (duty),
	.pulse (pulse)
);
freq_counter freq__counter_UUT(
	.clk (clk),
	.freq (pulse),
	.frequency (color_freq)
);

	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule