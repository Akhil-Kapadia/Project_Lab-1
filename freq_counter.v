/*
-------------------------------------------------------
Freq_counter  Module
-------------------------------------------------------
Given a square wave, this module will find the period using a 10ns clock.
It does this by detecting the rising edge of the input square wave (Read: FREQ)
and counting each time the 10ns clk pulses. Once another rising edge is detected,
it sends the count to an output and resets.
-------------------------------------------------------
Author : Akhil Kapadia
-------------------------------------------------------
*/
module freq_counter(
input clk,
input freq,
output reg [18:0] frequency,
output reg diode_change
);
//Local reg
wire risingEdge;
reg freq_last;
reg [18:0] count;
reg start_count;
reg [18:0] out;

initial begin
frequency <= 1;
out <= 0;
count <= 0;
diode_change <=0;
start_count <= 0;
end

//Latch to retain last value. Used in finding freq.
always @ (posedge clk)
	freq_last <= freq;


//Detects risingEdge of freq data stream.
assign risingEdge = freq & ~freq_last;


//Now find the freq of the data stream by counting clock pulses.
always @ (posedge clk)
begin
	//If posedge of freq is found, output # of clock pulses as freq and reset it.
	if (risingEdge)
	begin
		frequency <= (count>0) ? count : frequency;
		count <= 0;
		//Ensure that we always start counting from risingEdge to rising Edge.
		diode_change <= start_count;
		start_count <= start_count + 1;
	end
	else
	begin
		if(start_count)
			count <= count + 1;
		diode_change <= 0;
	end	
end

endmodule      
