module pwm(input clk, input [11:0] duty, output reg pulse = 0);
	reg [11:0] count = 0;
	
	always@(posedge clk)
	begin
		count <= count + 1;
		pulse <= (count < duty);
	end
endmodule
