module pwm(input clk, input [11:0] duty, output reg pulse);
	reg [11:0] count = 0;
	
	always@(posedge clk)
	begin
//		count <= (count < 'hF<<8) ? count + 1 : 0;
		count <= count +1;
		pulse <= (count < duty);
	end
endmodule
