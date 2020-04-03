module testbench;

reg clk;
wire duty = 100000;

pwm #(21,2000000)
freq_UUT(
	.clk (clk),
	.width (duty),
	.pulse (pulse)
);
 
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule