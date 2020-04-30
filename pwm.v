/*
-------------------------------------------------------
Pulse Width Modulation Module
-------------------------------------------------------
Creates a pwm signal with a given period and duty cycle. Based on the 10 ns clk
of the basys board, will generated a signal that counts by 10 ns.
-------------------------------------------------------
Author : Rice Rodriguez
-------------------------------------------------------
-------------------------------------------------------
Collaborator : Akhil Kapadia
-------------------------------------------------------
*/
module pwm #(parameter SIZE = 12, PERIOD = 4095)
(input clk,
input [SIZE-1:0] width,
output reg pulse);

reg [SIZE-1:0] count;
initial
	begin
		count <=0;
		pulse <= 0;
	end

always @ (posedge clk)
	begin
		count <= (count < PERIOD) ? count + 1 : 0;
		pulse <= (count < width) ? 1 : 0;
	end
endmodule