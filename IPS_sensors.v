/*
--------------------------------------------------------
Path Following Module
--------------------------------------------------------
This module takes in 3 active low inputs from 3 IPS sensors mounted on the front 
of the rover. Depending on which one sensor is activated, the direction of the 
rover will change. The rovers directions is controlled by 4 outputs from the 
basys to the hbridge. The IPS sensors changes the outputs which change the current
flow to the rover.
--------------------------------------------------------
Author : Akhil Kapadia
--------------------------------------------------------
*/

module IPS_sensors(
input clk,
input [2:0] IPS,
output [3:0] IN
);
reg [3:0] IN_Last;

assign IN[3:0] = (~IPS[1]) ? 4'b1001 : 				        //If middle IPS lit, Go forwards.
				 (~IPS[2]) ? 4'b1010 :				        //If left IPS lit, Go left.
				 (~IPS[0]) ? 4'b0101 : IN_Last;	   			//If right IPS lit, go right. If none lit stop.

//Latch to retain last value.
always @ (posedge clk)
	IN_Last <= IN;
	
endmodule