//To-Test:
// 1. Motor Control
// 2. Left/Right movement
// 3. 7-Segment display of Movement/Amps
// 4. Switch Control

//JA[] Signals
//--------------
//JA[0] Port  1 == Overcurrent A
//JA[1] Port  2 == Overcurrent B
//JA[2] Port  3 == Enable A
//JA[3] Port  4 == Enable B
//JA[4] Port  7 == H-Bridge Input 1
//JA[5] Port  8 == H-Bridge Input 2
//JA[6] Port  9 == H-Bridge Input 3
//JA[7] Port 10 == H-Bridge Input 4
//--------------
//SW[] Signals
//--------------
//SW[0] == ON/OFF for entire rover.
//SW[1] == [OFF] Set rover to go forwards. [ON] Set Rover to go backwards.
//SW[2] == Toggled ON. Rover will begin turning RIGHT.
//SW[3] == Toggled ON. Rover will begin turning LEFT.
//SW[4] == Increase Duty by 25%
//SW[5] == Increase Duty by 25%
//SW[6] == Increase Duty by 25%
//SW[7] == Increase Duty by 25%
//			Switches [7:4] increase duty by 25% of full duty cycle value. (255)
//'timescale 1ms/1ns


//-----------------------------------------------------
//Main Module
//-----------------------------------------------------
module main(
input pulse,
input [1:0] JA,
output [7:2] JA,
input [7:0] sw
);

//Turns rover on and off based on 1st switch
always @ (JA[1:0])	//This is the same as {JA[1] || JA[0]), right?
begin
	if (~JA[0] && ~JA[1])	//If no Overcurrent detected.
	begin
		assign JA[3:2] = (JA[0]) ? pulse : 0 ;
	end

//	if(sw[0]) //If ON state.
//	begin
//		if(~JA[0] && ~JA[1]);//No comp signals
//		begin
//			JA[2] <= pulse;		//Enables A&B
//			JA[3] <= pulse;
//		end
//	if(~sw[0]) //Turns off rover.
//		begin
//			JA[2] <= 0;			//Enables A&B
//			JA[3] <= 0;
//		end
//	end
end

//Change the frequency to 1KHz so pwm signal makes noticable change in motor speeds.

endmodule
//-----------------------------------------------------
//-----------------------------------------------------


//-----------------------------------------------------
//Module For Switches
//-----------------------------------------------------
module switch(
input [7:0] sw,
output [7:4] JA, //Sets the inputs of HBRidge -> Controls direction  of rover.
output reg [2:0] rate	//For use in case statement in pwm.v -  Will store how many switches toggled.
);

//JA[4] == H-Bridge Input 1
//JA[7] == H-Bridge Input 2
//JA[5] == H-Bridge Input 3
//JA[6] == H-Bridge Input 4

always @ (sw[7:1])
begin
	assign JA[7:4] = (sw[1]) ? 3'b0110 : 3'b1001 ;	//Sets rover forwards or backwards
	assign JA[7:4] = (sw[2]) ? 3'b0101 : 3'bxxxx ;	//Sets rover to go right if ON
	assign JA[7:4] = (sw[3]) ? 3'b1010 : 3'bxxxx ;	//Sets rover to go left if ON
	
	rate = sw[4] + sw[5] + sw[6] + sw[7];
end

endmodule
//-----------------------------------------------------
//-----------------------------------------------------


//-----------------------------------------------------
//Module For Pulse Width Modulation
//-----------------------------------------------------
//'timescale 1ms/1ns

module pwm(
	input clk,
	input [2:0] rate,
	output reg pulse,
	reg [9:0] count,
	reg [9:0] dutyCycle = 10'b0000000000 //In Case a larger Duty Variable is needed
);
always @ (duty)
begin
	case(duty)
	3'b001: begin
			dutyCycle = 10'b0011111010;
			end
	3'b010:	begin
			dutyCycle = 10'b0111110100;
			end
	3'b011: begin
			dutyCycle = 10'b1011101110;
			end
	3'b100: begin
			dutyCycle = 10'b1111101000;
			end
	endcase
			
end
	always @ (posedge clk) 
	begin
		count = 10'b0000000000;
		while(count <= dutyCycle) 
		begin
			count <= count + 1;
			pulse <= (count < dutyCycle);
		end
		pulse = 0;
	end
endmodule
//-----------------------------------------------------
//-----------------------------------------------------


//-----------------------------------------------------
//Module For Seven Segment Display
//-----------------------------------------------------
module sevenSeg(
	input clk,
	input [1:0] JA,
	output reg [3:0] an,
	output reg [6:0] seg,
	input [7:0] sw
);

reg [18:0] count;
always @ (posedge clk)
	count = count + 1;
wire [1:0] refresh;
assign refresh = count[18:17];//Refreshing Display

always @(*)
begin
	case(refresh)
	2'b00:	begin //	Sets 7seg to display "1" or "0" depending if overcurrent detected.
				seg = (JA[1:0]) ? 7'b1111001 : 7'b10000000
			end
	2'b01:  begin //Displays A for Amps
				an = 4'b1011;
                seg = 7'b0001000;
			end
	2'b10:  begin //Displays "F" or "b" for forwards of backwards movement
				an = 4'b1101;
				seg = (sw[1]) ? 7'b0000011 : 7'b00001110 ;
			end
	2'b11:  begin //Displays "r" and "L", for right and left movement.
				an = 4'b1110;
				if(sw[3:2])
				begin
					seg = (sw[2]) ? 7'b10011111 : 7'b10001111 ;
				end
				else
				begin
					seg = 7'b11111111;
				end
			end
	endcase
end
endmodule
//-----------------------------------------------------
//-----------------------------------------------------