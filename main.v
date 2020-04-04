module main(
	input clk,
	input [3:0] sw,
	input [2:0] IPS,
	input [3:0] DIS,
	input [1:0] OC,
	input sw_ON,
	input FREQ,
	output [3:0] an,
	output [6:0] seg,
	output [3:0] IN,
	output [1:0] EN,
	output SERVO

);

wire speed;
wire [11:0] motor_duty = sw[3:0] * 255;
wire SCL;
wire s_pulse;

//Pwm for rovor motors use. Has a freq of 25Khz.mmn=M 
pwm #(12,4095)
motors(
	.clk (clk),
	.width (motor_duty),
	.pulse (speed)
);

//PWM for servo motor use. Has a freq of 50Hz.
pwm #(21,2000000)
servo_pwm(
	.clk (clk),
	.width (servo_duty),
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
	.servo_flag (servo_flag)
);

//outputs a flag when sensors detect object to the sides of rover.
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
	.SERVO (SERVO)
);

//handles getting all the frequencies of R, G , B , Clear
freq_counter color_freq(
	.clk (clk),
	.freq (FREQ),
	.frequency (C_freq),
	.diode_change (diode_change)
);

color_sensor colorSens(
	.clk (clk),
	.CS	(CS),
	.frequency (C_freq),
	.red (red),
	.green (green),
	.blue (blue),
	.diode_change (diode_change),
	.red_raw (red),
	.green_raw (green),
	.blue_raw (blue),
	.clear (clear)
);

//Divided red freq by clear to normalize red waveform.
division #(16)red_div(
	.clk (clk),
	.dividend (clear),
	.divisor (red_raw),
	.quotient (red)
);

//Divide green freq by clear to normalize green waveform.
division #(16)green_div(
	.clk (clk),
	.dividend (clear),
	.divisor (green_raw),
	.quotient (green)
);

//Divide blue freq by clear to normalize blue waveform.
division #(16)blue_div(
	.clk (clk),
	.dividend (clear),
	.divisor (blue_raw),
	.quotient (blue)
);


endmodule