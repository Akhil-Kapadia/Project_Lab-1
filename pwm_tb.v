module pwm_tb();
	reg clk;
	wire [7:0] duty =128;
	wire out;
	pwm test(.clk(clk),.duty(duty),.PWM_output(out));
	initial begin
		clk=0;
		forever #5 clk =!clk;
	end
endmodule