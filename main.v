module main(
	input clk,
	input [3:0] sw,
	input [2:0] IPS,
	input [3:0] DIS,
	output [3:0] an,
	output [6:0] seg,
	input [1:0] OC,
	output [3:0] IN,
	output [1:0] EN,
	output SERVO,
	input sw_ON
);

wire speed;
wire [11:0] motor_duty = sw[3:0] * 255;
wire SCL;
wire s_pulse;

//instantiate pwm with duty set be rate at 25khz.
pwm #(12,4095)
motors(
	.clk (clk),
	.width (motor_duty),
	.pulse (speed)
);

//PWM for servo motor use.
pwm #(21,2000000)
servo_pwm(
	.clk (clk),
	.width (s_duty),
	.pulse (s_pulse)
);


//Create a slower clock at 400khz.
clk_div scl_clk(
	.clk (clk),
	.reset (reset),
	.scale (250),
	.clk_out (SCL)
);

//Keeps rover on alum tape track
IPS_sensors pathfinding(
 	.clk(clk),
	.IPS (IPS),
	.IN (IN)
);

sevenSeg disp(
	.clk (clk),
	.OC (OC),
	.an (an),
	.seg (seg),
	.sw (sw)
);

flag_handling flags(
    .clk (clk),
    .SCL (SCL),
    .sw_ON (sw_ON),
    .pulse (speed),
    .dist_flag (dist_flag),
    .EN (EN),
	.servo_flag (servo_flag),
	.move_flag (move_flag)
);

Distance_sensor dist_stop(
.DIS (DIS),
.dist_flag (dist_flag)
);

//Controls operation of servo motor.
servo servo_motor(
	.clk (clk),
	.servo_flag (servo_flag),
	.s_pulse (s_pulse),
	.s_duty (s_duty),
	.SERVO (SERVO),
	.move_flag(move_flag)
);



endmodule