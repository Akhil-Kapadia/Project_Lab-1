module freq_counter(
input clk,
input freq,
output reg [15:0] frequency,
output reg diode_change
);
//Local reg
wire risingEdge;
reg freq_last;
reg [15:0] count;
reg start_count;

initial begin
frequency <= 0;
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
		frequency <= count;
		count <= 0;
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
