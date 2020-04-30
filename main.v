module main(
	input clk,
	input [3:0] sw,
	input [3:0] IR,
	input [2:0] IPS,
	input [3:0] DIS,
	input [1:0] OC,
	input sw_ON,
	input FREQ,
	output [3:0] an,
	output [6:0] seg,
	output [3:0] IN,
	output [1:0] EN,
	output [1:0] CS,
	output SERVO,
	output MAGNET
);

wire speed;	//For rover use. Sent to main_stateMachine
wire [11:0] motor_duty = sw[3:0] * 255;	//For rover use. pwm
wire s_pulse;	//For servo. Sent to servo_stateMachine
wire [18:0] s_duty;
wire [18:0] period;	//Frequency/period from color sensor. freq_counter to color_sensor.
wire [18:0] clear;  //Period of clear filter of photodiode from color sensor.
wire [7:0] RGB_percentage;	//color/clear from calc_perc to color_sensor.
wire [18:0] color_period;	//Period from color_stateMachine to normalizer.
wire [2:0] color_state;		//Corresponds to the color detected. [0] : Red, [1] : Green, [2] : Blue.
wire servo_state;           //Pick up or drop off mode of servo arm    	
wire servo_done;            //servo done .
wire [1:0] dist_state;      //Which side detected station. 
wire [1:0] MSM_state;
wire [2:0] IR_state;

//Pwm for rovor motors use. Has a freq of 25Khz.
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
	.width (s_duty),
	.pulse (s_pulse)
);

//Keeps rover on alum tape track
IPS_sensors pathfinding(
 	.clk(clk),
	.IPS (IPS),
	.IN (IN)
);

sevenSeg disp(
	.clk (clk),
	.an (an),
	.seg (seg),
	.MSM (MSM_state),
	.color (color_state),
	.IR (IR)
);


//Main module that combines all different functions of rover to make it work.
flag_handling main_stateMachine(
	.clk (clk),
	.sw_ON (sw_ON),
	.pulse (speed),
	.EN (EN),
	.dist_state (dist_state),
	.IR_state (2'b01),
	.servo_done (servo_done),
	.servo_state (servo_state),
	.servo_EN (servo_EN),
	.state (MSM_state)
);

//outputs a flag when sensors detect object to the sides of rover.
Distance_sensor distance_stateMachine(
.DIS (DIS),
.dist_state (dist_state)
);

//Gets input from IR detecting ckt. Then according to the instructions on black board
//will give instructions on which stations to pick up from. State determines pickip/dropoff/stop.
IR_instructions IR_stateMachine(
	.clk (clk),
	.IR (IR),
	.color (color_state),
	.IR_state (IR_state)
);


//Controls operation of servo motor.
servo servo_stateMachine(
	.clk (clk),
	.servo_flag (servo_state),
	.s_duty (s_duty),
	.move_flag (servo_done),
	.SERVO (SERVO),
	.MAGNET (MAGNET)
);

//handles getting all the frequencies of R, G , B , Clear
freq_counter frequency_Counter(
	.clk (clk),
	.freq (FREQ),
	.frequency (period),
	.diode_change (diode_change)
);

//Given the period of the 4 color diodes, returns which color is most prominent.
color_sensor color_stateMachine(
	.clk (clk),
	.frequency (period),
	.color (RGB_percentage),
	.calc_done (normalizer_done),
	.diode_change (diode_change),
	.CS	(CS),
	.calc_EN (normalizer_EN),
	.calc_reset (normalizer_reset),
	.clear (clear),
	.color_raw (color_period),
	.color_detected (color_state)
);

//Find the percentage of clear compared to color.
calc_perc normalizer(
	.clk (clk),
	.reset (normalizer_reset),
	.numerator (color_period),
	.denominator (clear),
	.enable (normalizer_EN),
	.done (normalizer_done),
	.percent (RGB_percentage)
);


endmodule