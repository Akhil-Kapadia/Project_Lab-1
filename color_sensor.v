module color_sensor(
	input clk,
	input [1:0] CS,
	input reg [15:0] frequency,
	input reg [15:0] color,
	output reg [15:0] red,
	output reg [15:0] green,
	output reg [15:0] blue,
	output reg [15:0] clear
);
//Change the color coming in via CS.
// RED		00	0
// GREEN	01	1
// BLUE		11	3
// CLEAR	10	2

always @ (frequency)
begin
	if (frequency != 0)
	begin
		CS <= CS +1;
		if (CS == 0)
			red <= frequency;
		if (CS == 1)
			green <= frequency;
		if (CS == 3)
			blue <= frequency;
		if (CS == 2)
		begin
			clear <= frequency;
		end
	end
end
			
			
			
		