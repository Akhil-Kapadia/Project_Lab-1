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


