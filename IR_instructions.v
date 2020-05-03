/*
--------------------------------------------------------
Color Sensor Module
--------------------------------------------------------
This modules read active low from 4 ports on the JMOD JB ports. Depending on what
signal comes in from the IR detection circuit, this state machine will tell the MSM
to either pickup or ignore this station. If the stop signal is sent then, the 
state machine will tell the rover to stop.
--------------------------------------------------------
Author : Akhil Kapadia
--------------------------------------------------------
*/
module IR_instructions(
	input clk,
	input [3:0] IR,
	input [2:0] color,
	output reg [1:0] IR_state
);
reg [1:0] last;
reg [1:0] instruction;
always @ (posedge clk)
begin
    last <= instruction;
	case(IR)
		~4'b0001: instruction[1:0] <= 2'b00;		//Stop instructions @ 10 KHz	
		~4'b0010: instruction[1:0] <= 2'b01;		//Pick Up from Red and Blue. @200Hz
		~4'b0100: instruction[1:0] <= 2'b10;		//Pick up from Red and Green. @1kHz
		~4'b1000: instruction[1:0] <= 2'b11;		//Pick up from Blue and green. @5kHz
		default: instruction[1:0] <= last;
	endcase
	IR_state[1] <= (instruction[1:0] != 2'b00);
	case(instruction)
		2'b00: IR_state <= 2'b00;		//Send stop state.
		2'b01: IR_state[0] <= (color[2] || color[0]);	//If color detected is red or blue start pickup. 
		2'b10: IR_state[0] <= (color[2] || color[1]);	//If color detected is red or green, pick up.
		2'b11: IR_state[0] <= (color[0] || color[1]);	//If color detected is blue or green, pickup.
		default: IR_state <= IR_state;
	endcase
end
endmodule 