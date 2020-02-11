module pwm(input clk, input [11:0] duty, output reg pulse);
	reg [11:0] count =0;
	always@(posedge clk)
	begin
		count <= (count < 0xF<<8) ? count + 1 : 0;
		pulse <= (count < duty);
	end
endmodule
