module IR_instructions(
	input clk,
	input [3:0] IR,
	input [2:0] color,
	output reg [1:0] IR_state
);
reg [1:0] instruction;
always @ (posedge clk)
begin

	case(IR)
		4'b0001: instruction <= 0;		//Stop instructions @ 8 KHz	
		4'b0010: instruction <= 1;		//Pick Up from Red and Blue. @200Hz
		4'b0100: instruction <= 2;		//Pick up from Red and Green. @1kHz
		4'b1000: instruction <= 3;		//Pick up from Blue and green. @5kHz
		default: instruction <= 2'b00;
	endcase
	
	case(instruction)
		2'b00: IR_state <= 2'b00;		//Send stop state.
		2'b01: IR_state[0] <= (color[0] || color[2]);	//If color detected is red or blue start pickup. 
		2'b10: IR_state[0] <= (color[0] || color[1]);	//If color detected is red or green, pick up.
		2'b11: IR_state[0] <= (color[2]  || color[1]);//If color detected is blue or green, pickup.
		default: IR_state <= 2'b01;
	endcase
end
endmodule 