module multi(
input clk,
input [3:0] switches,
output [5:0] block_position
);

reg [5:0] blockPosition;

assign block_position = blockPosition;

always @(posedge clk)
begin
	case(switches)
		3'b001://Red Green Blue
		begin
			blockPosition = 6'b011011;
		end
		3'b010://Red Blue Green
		begin
			blockPosition = 6'b011110;
		end
		3'b011://Green Red Blue
		begin
			blockPosition = 6'b100111;
		end
		3'b100://Green Blue Red
		begin
			blockPosition = 6'b110110;
		end
		3'b101://Blue Green Red
		begin
			blockPosition = 6'b111001;
		end
		3'b110://Blue Red Green
		begin
			blockPosition = 6'b101101;
		end
		default:
		begin
			blockPosition = 6'b011011;
		end
	endcase
end
endmodule

