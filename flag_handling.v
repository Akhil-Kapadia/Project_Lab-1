module flag_handling(
input clk,
input sw_ON,
input pulse,
input [1:0] dist_state,
input [1:0] IR_state,
input servo_done,
output reg servo_state,
output [1:0] EN,
output reg [2:0] state,
output [1:0] distance_count
);

//Local variables
reg enable;
reg move;
reg [1:0] distanceCount;
reg [11:0] distanceFlag;
initial state <= 0;
assign EN[1:0] = (enable) ? {2{pulse}} : 0;
assign distance_count = distanceCount;



always @ (posedge clk)
begin
	if(distanceCount == 0)
		distanceCount = distanceCount + 1;
	case(state)
		0: //Rover is on and following path.
		begin
			enable <= (sw_ON && IR_state[1]);	//Set Enables to pulse.
		end
		1://Stops rover at station and checks for color.
		begin
			enable <= 0;	//Stops rover
			case(dist_state[1:0])
				2'b10 : state <= (IR_state[0]) ? 2 : 4;
				2'b01 : state <= 3;
			endcase 
		end
		2://Pick up from stations.
		begin
			servo_state <= 1;	//Activate pickup.
		end
		3:// Drop off at station.
		begin
			servo_state <= 0;	//Active dropoff routine.
		end
		4://Wait x time to move
		begin
			enable <= (sw_ON && IR_state[1]);	//Set Enables to pulse.
			if(distanceFlag == 12'b111111111111)
			begin
				state <= 0;
				distanceFlag = 0;
			end
			else
				distanceFlag = distanceFlag + 1;
				
		end
		default: //Rover is stopped 
		begin
			enable <= 0;	//Set enables to 0. Stops rover.
		end
	endcase
	
	if(servo_done)	//Resume movement, rover is moving.
	begin
		state <= 4;
	end
		
	if(|dist_state[1:0] && (distanceFlag == 0))	//Stops at station and checks color.
	begin
		if(dist_state[1])
			distanceCount = distanceCount + 1;
		state <= 1;
		distanceFlag = distanceFlag + 1;
	end
end
endmodule