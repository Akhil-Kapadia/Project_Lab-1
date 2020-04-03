
module division(clk, dividend, divisor, quotient);
//Modular size of division.
parameter WIDTH = 16;
//	I/O ports
input clk,
input [WIDTH-1:0] dividend;	//Must be greater than divisor. Should be clear freq.
input [WIDTH-1:0] divisor;	//Should be the color freqs
output [WIDTH-1:0] quotient;
//Internal regs
reg [WIDTH-1:0] Res = 0;
reg [WIDTH-1:0] a, b;
reg [WIDTH-1:0] p;
integer i;

always @ (dividend)
begin
	//Initialise variables
	a=dividend;
	b=divisor;
	p=0;
	
	//Start loop for division
	for (i=0; i < WIDTH ;i=i+1)
	begin
		p = {p[WIDTH-1], a[WIDTH-1]};
		a[WIDTH-1:1] = a[WIDTH-2:0];
		p = p - b;
		if (p[WIDTH-1] == 1)
		begin
			a[0] = 0;
			p = p + b;
		end
		else
			a[0] = 1;
	end
	quotient = a;
end

endmodule