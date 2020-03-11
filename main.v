module main(
	input clk,
	input [3:0] sw,
	input [2:0] IPS,
	output [3:0] an,
	output [6:0] seg,
	input [1:0] OC,
	output [3:0] IN,
	output [1:0] EN,
	input sw_ON
);

wire speed;
wire [11:0] motor_duty = sw[3:0] * 255;

//instantiate pwm with duty set be rate at 25khz.
pwm motors(
	.clk (clk),
	.duty (motor_duty),
	.pulse (speed)
);

IPS_sensors pathfinding(
	.clk(clk),
	.IPS (IPS),
	.IN (IN),
	.EN (EN),
	.speed (speed),
	.sw_ON (sw_ON)
);


sevenSeg disp(
	.clk (clk),
	.OC (OC),
	.an (an),
	.seg (seg),
	.sw (sw)
);

endmodule