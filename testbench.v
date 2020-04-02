module testbench;

reg clk;
reg duty = 100000;
reg s_pulse;
reg [2:0] servo_flag;

pwm #(21,2000000)
servo_pwm(
	.clk (clk),
	.width (duty),
	.pulse (s_pulse)
);

servo servo_motor(
	.clk (clk),
	.servo_flag (servo_flag),
	.s_pulse (s_pulse),
	.s_duty (duty),
	.SERVO (SERVO)
);
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          servo_flag = 3'b111;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule