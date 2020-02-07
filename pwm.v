module pwm(input clk, input [7:0] duty, output reg pulse);
	reg [7:0] count =0;
	always@(posedge clk)
	begin
		count <= count + 1;
		pulse <= (count < duty);
	end
endmodule
