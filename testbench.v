module testbench;

reg clk;
wire [15:0] color_freq;
wire [15:0] color_raw;
wire [15:0] clear;
wire [15:0] color;
wire [2:0] color_detected;
wire wave;
wire [1:0] port;
  
pwm #(16,7340)
red_freq_UUT(
	.clk (clk),
	.width (100),
	.pulse (pred)
);

pwm #(16,20000)
green_freq_UUT(
	.clk (clk),
	.width (100),
	.pulse (pgreen)
);

pwm #(16, 12600)
blue_freq_UUT(
	.clk (clk),
	.width (100),
	.pulse (pblue)
);

pwm #(16,2810)
clear_freq_UUT(
	.clk (clk),
	.width (100),
	.pulse (pclear)
);
freq_counter freq__counter_UUT(
	.clk (clk),
	.freq (wave),
	.frequency (color_freq),
	.diode_change (diode_change)
);


color_sensor RGB_det(
	.clk (clk),
	.CS	(port),
	.frequency (color_freq),
	.color (color),
	.calc_done (normalizer_Done),
	.diode_change (diode_change),
	.calc_EN (normalizer_EN),
	.calc_reset (normalizer_reset),
	.color_raw (color_raw),
	.clear (clear),
	.color_detected (color_detected)
);


//Find the percentage of clear compared to color.
calc_perc normailizer(
	.clk (clk),
	.reset (normalizer_reset),
	.numerator (clear),
	.denominator (color_raw),
	.enable (normalizer_EN),
	.done (normalizer_Done),
	.percent (color)
);
wire color;

//Divided red freq by clear to normalize red waveform.
assign wave = (port == 0) ? pred : 
              (port == 1) ? pgreen :
              (port == 2) ? pclear : pblue;
  
	 initial begin
     // Initialize the clock to 0.
          clk <= 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
endmodule