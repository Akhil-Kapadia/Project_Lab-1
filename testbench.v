module testbench;

reg clk;
reg [1:0] OC = 2'b01;
reg [7:0] sw = 8'b10010001;
reg btnC;
wire [3:0] IN;
wire [1:0] EN;
wire [6:0] seg;
wire [3:0] an;
wire [11:0] duty = sw[7:4] * 255;
wire pulse;
wire reset;
pwm freq_UUT(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);

switch flips_UUT(
	.clk (clk),
	.btnC (btnC),
	.sw (sw),
	.IN (IN),
	.EN (EN),
	.OC (OC),
	.duty (duty),
	.pulse (pulse),
	.reset (reset)
);

sevenSeg disp_UUT(
	.clk (clk),
	.OC (OC),
	.an (an),
	.seg (seg),
	.sw (sw)
);
	 
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
     initial begin
          btnC = 0;
          #51 OC[1:0] = 2'b00;
		  #100 btnC=1;
		  #10 btnC=0;
    end
endmodule