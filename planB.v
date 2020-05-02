module planB(
input clk,
input [2:0] sw,
input proximity,
output reg [2:0] color
);

//local regs
reg [1:0] count;
//assign count = (proximity) ? count + 1 : count;

always @ (posedge clk)
begin
	count = (proximity) ? count + 1 : count;
	
	case(sw[2:0])
	3'b100: //station order R, G, B.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b100;
		2: color <= 3'b010;
		3: color <= 3'b001;
		endcase
	end
	3'b110: //station order R, B, G.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b100;
		2: color <= 3'b001;
		3: color <= 3'b010;
		endcase
		end
	3'b010: //station order G, R, B.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b010;
		2: color <= 3'b100;
		3: color <= 3'b001;
		endcase
	end	
	3'b011: //station order G, B, R.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b010;
		2: color <= 3'b001;
		3: color <= 3'b100;
		endcase
	end
	3'b101: //station order B, R, G.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b001;
		2: color <= 3'b100;
		3: color <= 3'b010;
		endcase
	end		
	3'b001: //station order B, G, R.
	begin
		case(count)
		0: color <= 3'b000;
		1: color <= 3'b001;
		2: color <= 3'b010;
		3: color <= 3'b100;
		endcase
	end	
	endcase
end

endmodule