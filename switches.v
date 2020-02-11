//-----------------------------------------------------
//Module For Switches
//-----------------------------------------------------
module switch(
input clk,
input [7:0] sw,		//Switch states
output [3:0] IN, 		//Sets the inputs of HBRidge -> Controls direction  of rover.
output [1:0] EN,
input [1:0] OC,
output [13:0] duty,	//For use in case statement in pwm.v -  Will store how many switches toggled.
input pulse
);
reg temp[3:0];	//Saves old IN bits.

// Turns rover on if switch is flipped and OC isnt 1.
assign EN[1:0] = (|OC[1:0] && ~sw[0] ) ? 0 : pulse ; 				//Sets the EN to pulse if OC isnt 1 and 1st switch is ON 

//Change the duty depending on how many switches toggled.

assign duty = sw[7:4] << 10;
000000001111 11110000000000

//IN[0] == H-Bridge Input 1.
//IN[1] == H-Bridge Input 2.
//IN[2] == H-Bridge Input 3.
//IN[3] == H-Bridge Input 4.

assign IN[7:4] = (sw[1] && ~sw[2] && ~sw[3]) ? 3'b0110 : 			//Sets rover forwards or backwards
				 (sw[2] && ~sw[3]) ? 3'b0101 : 						//Sets rover to go right if ON
				 (sw[3]) ? 3'b1010 : 3'b1001 ;						//Sets rover to go left if ON

endmodule