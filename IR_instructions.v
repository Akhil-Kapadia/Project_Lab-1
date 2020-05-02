module IR_instructions(
	input clk,
	input [3:0] IR,
	output reg [1:0] IR_state,
	input [5:0] positions,
	input [1:0] distance_count,
	input [1:0] dist_state
);
reg [1:0] instruction;
always @ (posedge clk)
begin

//Red position positions[5:4]
//Green position positions[3:2]
//Blue position positions[1:0]
/*
Have a 2 bit number counting up everytime dist() procs
then if(position[5:4] = number) We at RED check all three 
positions

*/
if(dist_state[0] == 1)
begin
	case(IR)
		4'b1110: instruction <= 0;		//Stop instructions @ 8 KHz	
		4'b1101: instruction <= 1;		//Pick Up from Red and Blue. @200Hz
		4'b1011: instruction <= 2;		//Pick up from Red and Green. @1kHz
		4'b0111: instruction <= 3;		//Pick up from Blue and green. @5kHz
		default: instruction <= 2'b00;
	endcase
	if(instruction == 0)
		IR_state[1] <= 0;
	else
		IR_state[1] <= 1;
	//distance_count == positions[5:4] //We at RED
	//distance_count == positions[3:2] //We at GREEN
	//distance_count == positions[1:0] //We at BLUE
	
	case(instruction)
		2'b00: IR_state <= 2'b00;		//Send stop state.
		2'b01: IR_state[0] <= ((distance_count == positions[5:4]) || (distance_count == positions[1:0]));	//If color detected is red or blue start pickup. 
		2'b10: IR_state[0] <= ((distance_count == positions[5:4]) || (distance_count == positions[3:2]));	//If color detected is red or green, pick up.
		2'b11: IR_state[0] <= ((distance_count == positions[1:0]) || (distance_count == positions[3:2]));	//If color detected is blue or green, pickup.
		default: IR_state <= 2'b01;
	endcase
end
end
endmodule 