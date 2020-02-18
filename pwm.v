module pwm(input clk, input [19:0] duty, output reg pulse = 0);
	reg [19:0] count = 0;
	
	always@(posedge clk)
	begin
//		count <= (count < 'hF<<8) ? count + 1 : 0;
		count <= count + 1;
		pulse <= (count < duty);
	end
endmodule
