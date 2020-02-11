//Rovy The Best Rover

//To-Test:
// 1. Motor Control
// 2. Left/Right movement
// 3. 7-Segment display of Movement/Amps
// 4. Switch Control

//JA[] Signals
//--------------
//JA[0] Port  1 == Comparator A
//JA[1] Port  2 == Comparator B
//JA[2] Port  3 == Enable A
//JA[3] Port  4 == Enable B
//JA[4] Port  7 == H-Bridge Input 1
//JA[5] Port  8 == H-Bridge Input 2
//JA[6] Port  9 == H-Bridge Input 3
//JA[7] Port 10 == H-Bridge Input 4
//--------------
//SW[] Signals
//--------------
//SW[0] == primaryEnable
//SW[1] == Forward Enable
//SW[2] == Backward Enable (If both 1 and 2 then disable until 1 or 2 is off)
//SW[3] == Enable/Disable Display of Direction/Amps
//SW[4] == Duty 25%
//SW[5] == Duty 25%
//SW[6] == Duty 25%
//SW[7] == Duty 25%
//Each of switches 4-7 adds 25% duty cycle
//'timescale 1ms/1ns


//-----------------------------------------------------
//Main Module
//-----------------------------------------------------
module main(
input pulse,
output reg [7:0] JA,
input [7:0] sw
);


always @ (JA[0] || JA[1])
begin
	if(sw[0]) //If Primary enable is on
	begin
		if(~JA[0] && ~JA[1]);//No comp signals
		begin
			JA[2] <= pulse;
			JA[3] <= pulse;
		end
	if(~sw[0]) //Comp says over limit on at least one
		begin
			JA[2] <= 0;
			JA[3] <= 0;
		end
	end
end
endmodule
//-----------------------------------------------------
//-----------------------------------------------------


//-----------------------------------------------------
//Module For Switches
//-----------------------------------------------------
module switch(
input [7:0] sw,
output reg [7:4] JA, //Control of forward/back movement
output reg [2:0] duty
);

//JA[4] == H-Bridge Input 1
//JA[7] == H-Bridge Input 4
//
//JA[5] == H-Bridge Input 2
//JA[6] == H-Bridge Input 3

always @ (sw[1] || sw[2])
begin
	if(sw[1] && sw[2]); //Disable if both are on
	begin
		JA[2] <= 0;
		JA[3] <= 0;
	end
	if(sw[1]); //Forwards movement
	begin
	   JA[7] <= 1;
	   JA[6] <= 1;
	   JA[5] <= 0;
	   JA[4] <= 1;
	end
	if(sw[2]); //Backwards movement
	begin
	   JA[7] <= 0;
	   JA[6] <= 1;
	   JA[5] <= 1;
	   JA[4] <= 0;
	end
end

always @ (sw[4] || sw[5] || sw[6] || sw[7])
begin
	duty = sw[4] + sw[5] + sw[6] + sw[7];
	
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
	input [2:0] duty,
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
	input [7:0] amps [1:0],
	output reg [1:0] JA,
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
	if(sw[3])
	begin
		case(refresh)
		2'b00:	begin // Displays 0/1 for current threshold
					an = 4'b0111;
					if(JA[0] || JA[1])
						seg = 7'b1111001;
					else
						seg = 7'b1000000;
				end
		2'b01:  begin //Displays A for Amps
					an = 4'b1011;
                    seg = 7'b0001000;
				end
		2'b10:  begin //Forward/Backward Movement
					an = 4'b1101;
					if(sw[1] && sw[2])
						seg = 7'b0000000;
					else if(sw[1])
						seg = 7'b0001110;
					else if(sw[2])
						seg = 7'b0000011;
					else
						seg = 7'b0000000;
				end
		2'b11:  begin //Off Currently
					an = 4'b1110;
					seg = 7'b1111111;
				end
			endcase
        end
	end
endmodule
//-----------------------------------------------------
//-----------------------------------------------------















