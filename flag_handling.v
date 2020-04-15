module flag_handling(
input clk,
input sw_ON,
input pulse,
input dist_state,
input [2:0] IR_state
output reg [2:0] servo_state,
output reg magnet_state,
output reg [2:0] display_state,
output [1:0] EN
);
//Local variables
reg [2:0] state;

always @ (posedge clk)
begin
	
	case(state)
		0: //Rover is on and following path.
		begin
			EN[1:0] <= (sw_on && IR_state[1]) ? {2{pulse}} : 0;	//Set Enables to pulse.
			servo_state <= 0;		//Set servo to neutral 90.
			magnet_state <= 0;		//Turn magnet off.
			display_state <= 1;		//Change display to show speed and GO.
		end
		1://Stops rover at station and checks for color.
		begin
			EN[1:0] <= 0;	//Stops rover
			servo_state <= 0;	//set servo to neutral 90.
			magnet_state <= 0;	//Turn off servo.
			display_state <= 2;	//Display color of station.
			state <= (IR_state[0]) ? 2 :		//Pick up at station.
					 (IR_state[1]) ? 3 : 0;	//Drop of at station.
		end
		2://Pick up from stations.
		begin
			EN[1:0] <= 2'b00;	//Stop rover.
			servo_state <= 1;	//Activate pickup.
			magnet_state <= 1;	//Turn on magnet while arm is sweeping.
			display_state <= 2;	//Display Color of station.
		end
		3:// Drop off at station.
		begin
			EN[1:0] <= 2'b00;	//Stop rover
			servo_state <= 2;	//Active dropoff routine. 
			magnet_state <= 1;	//Turn on magnet.
			display_state <= 2;	//display DrOP.
		end
		default: //Rover is stopped 
		begin
			EN[1:0] <= 2'b00;	//Set enables to 0. Stops rover.
			servo_state <= 0;	//Set servo to neutral postion 90.
			magnet_state <= 0;	//Set magnet to OFF.
			display_state <= 0;	//Set 7 seg to display OFF
		end
	endcase
	
	if(servo_done)	//Resume movement, rover is moving.
		state <= 0;
		
	if(dist_state)	//Stops at station and checks color.
		state <= 1;
endmodule