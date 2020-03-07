module testbench;

reg clk;
wire [3:0] IN;
wire [1:0] EN;
reg sw_ON=1;
reg [2:0] IPS;

wire [11:0] duty = 2048;

pwm freq_UUT(
	.clk (clk),
	.duty (duty),
	.pulse (pulse)
);


IPS_sensors pathfindingUUT(
	.clk (clk),
	.IPS (IPS),
	.IN (IN),
	.EN (EN),
	.speed (pulse),
	.sw_ON (sw_ON)
);	 
	 initial begin
     // Initialize the clock to 0.
          clk = 0;
          // Alternative way of simulating 100 MHz clock, works the same way
          forever #5 clk = !clk;
     end
     initial begin
		IPS[2:0] = 010;
		#20 IPS[2:0] = 100;
		#20 IPS[2:0] = 001;
		#20 IPS[2:0] = 110;
    end
endmodule