module testbench;

reg clk;
reg diode_change;
reg [15:0] color_freq;
wire wave;
wire [1:0] port;
  
//pwm #(16,12346)
//red_freq_UUT(
//	.clk (clk),
//	.width (6173),
//	.pulse (pred)
//);

//pwm #(16,20000)
//green_freq_UUT(
//	.clk (clk),
//	.width (10000),
//	.pulse (pgreen)
//);

//pwm #(16, 35648)
//blue_freq_UUT(
//	.clk (clk),
//	.width (17824),
//	.pulse (pblue)
//);

//pwm #(16,63000)
//clear_freq_UUT(
//	.clk (clk),
//	.width (31500),
//	.pulse (pclear)
//);
//freq_counter freq__counter_UUT(
//	.clk (clk),
//	.freq (wave),
//	.frequency (color_freq),
//	.diode_change (diode_change)
//);


color_sensor colorSens_UUT(
	.clk (clk),
	.CS	(port),
	.frequency (color_freq),
	.red (red),
	.green (green),
	.blue (blue),
	.diode_change (diode_change),
	.red_raw (red_raw),
	.green_raw (green_raw),
	.blue_raw (blue_raw),
	.clear (clear)
);

//Divided red freq by clear to normalize red waveform.
division #(16)red_div_UUT(
	.clk (clk),
	.dividend (clear),
	.divisor (red_raw),
	.quotient (red)
);

//Divide green freq by clear to normalize green waveform.
division #(16)green_div_UUT(
	.clk (clk),
	.dividend (clear),
	.divisor (green_raw),
	.quotient (green)
);

//Divide blue freq by clear to normalize blue waveform.
division #(16)blue_div_UUT(
	.clk (clk),
	.dividend (clear),
	.divisor (blue_raw),
	.quotient (blue)
);
//assign wave = (port == 0) ? pred : 
//              (port == 1) ? pgreen :
//              (port == 2) ? pclear : pblue;
  
initial begin
    diode_change= 1;
    color_freq = 32000;
    #5 diode_change =0;
    #100 color_freq = 12434;
    diode_change = 1;
    # 5 diode_change = 0;
    #100 color_freq = 41200;
    diode_change = 1;
end
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule