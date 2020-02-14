//-----------------------------------------------------
//Module For Switches
//-----------------------------------------------------
module switch(
input clk,
input [7:0] sw,		//Switch states
output [3:0] IN , 		//Sets the inputs of HBRidge -> Controls direction  of rover.
output [1:0] EN,
input [1:0] OC,
output [11:0] duty,	//For use in case statement in pwm.v -  Will store how many switches toggled.
input pulse
);

// Turns rover on if switch is flipped and OC isnt 1.
assign EN[1:0] = (|OC[1:0] && ~sw[0] ) ? 0 : pulse ; 				//Sets the EN to pulse if OC isnt 1 and 1st switch is ON 

//Change the duty depending on how many switches toggled.
assign duty[11:0] = sw[7:4] << 8;

//IN[0] == H-Bridge Input 1.
//IN[1] == H-Bridge Input 2.
//IN[2] == H-Bridge Input 3.
//IN[3] == H-Bridge Input 4.

assign IN[3:0] = (sw[3:1] == 3'b001) ? 4'b0110 : 					//Sets rover forwards or backwards
				 (sw[2] && ~sw[3]) ? 4'b0101 : 						//Sets rover to go right if ON
				 (sw[3]) ? 4'b1010 : 4'b1001 ;						//Sets rover to go left if ON
endmodule
