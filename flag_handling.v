module flag_handling(
input clk,
input sw_ON,
input pulse,
input [1:0] dist_state,
input [2:0] IR_state,
input servo_done,
output reg servo_state,
output reg servo_EN,
output [1:0] EN,
output reg [1:0] state
);
//Local variables
reg enable;
reg move;
initial state <= 0;
assign EN[1:0] = (enable) ? {2{pulse}} : 0;
always @ (posedge clk)
begin
	case(state)
		0: //Rover is on and following path.
		begin
			enable <= (sw_ON && IR_state[1]);	//Set Enables to pulse.
			servo_EN <= 0;
			move <= (|dist_state) ? move : 0;
		end
		1://Stops rover at station and checks for color.
		begin
			enable <= 0;	//Stops rover
			servo_EN <= 0;
			state <= (IR_state[0]) ? 2 :		//Pick up at station.
					 (IR_state[0]) ? 3 : 0;	//Drop of at station. ! If not then continue. 
		end
		2://Pick up from stations.
		begin
			enable <= 0;	//Stop rover.
			servo_EN <= 1;
			servo_state <= 0;	//Activate pickup.
		end
		3:// Drop off at station.
		begin
			enable <= 0;	//Stop rover
			servo_EN <= 1;
			servo_state <= 1;	//Active dropoff routine.
		end
		default: //Rover is stopped 
		begin
			enable <= 0;	//Set enables to 0. Stops rover.
			servo_EN <= 0;
			servo_state <= 0;	//Set servo to neutral postion 90.
		end
	endcase
	
	if(servo_done)	//Resume movement, rover is moving.
	begin
		state <= 0;
		move <= 1;
	end
		
	if(|dist_state[1:0] && ~move)	//Stops at station and checks color.
		state <= 1;
	end
endmodule