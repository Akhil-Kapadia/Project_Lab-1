module testbench;

reg clk;
reg [15:0] duty = 8000;
wire [15:0] color_freq;
wire wave;
pwm #(16,16000)
freq_UUT(
	.clk (clk),
	.width (duty),
	.pulse (wave)
);
freq_counter freq__counter_UUT(
	.clk (clk),
	.freq (wave),
	.frequency (color_freq)
);

	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule