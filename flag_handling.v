module flag_handling(
input clk,
input sw_ON,
input pulse,
input dist_state,
input [2:0] IR_state,
input servo_done,
output reg [2:0] servo_state,
output reg magnet_state,
output [1:0] EN,
output state
);
//Local variables
reg [2:0] state;
reg enable;

assign EN[1:0] = (enable) ? {2{pulse}} : 0;
always @ (posedge clk)
begin
	case(state)
		0: //Rover is on and following path.
		begin
			enable <= (sw_ON && IR_state[1]);	//Set Enables to pulse.
			servo_state <= 0;		//Set servo to neutral 90.
			magnet_state <= 0;		//Turn magnet off.
		end
		1://Stops rover at station and checks for color.
		begin
			enable <= 0;	//Stops rover
			servo_state <= 0;	//set servo to neutral 90.
			state <= (IR_state[0]) ? 2 :		//Pick up at station.
					 (IR_state[1]) ? 3 : 0;	//Drop of at station.
		end
		2://Pick up from stations.
		begin
			enable <= 0;	//Stop rover.
			servo_state <= 1;	//Activate pickup.
			magnet_state <= 1;	//Turn on magnet while arm is sweeping.
		end
		3:// Drop off at station.
		begin
			enable <= 0;	//Stop rover
			servo_state <= 2;	//Active dropoff routine. 
			magnet_state <= 1;	//Turn on magnet.
		end
		default: //Rover is stopped 
		begin
			enable <= 0;	//Set enables to 0. Stops rover.
			servo_state <= 0;	//Set servo to neutral postion 90.
			magnet_state <= 0;	//Set magnet to OFF.
		end
	endcase
	
	if(servo_done)	//Resume movement, rover is moving.
	begin
		state <= 0;
		magnet_state <= (servo_state == 1) ? 1 : 0;	//Unless servo picked something up. Turn magnet off.
	end
		
	if(dist_state && ~servo_done)	//Stops at station and checks color.
		state <= 1;
	end
endmodule