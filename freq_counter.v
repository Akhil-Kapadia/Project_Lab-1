module freq_counter(
input clk,
input freq,
output reg [15:0] frequency
);
//Local reg
wire risingEdge;
reg freq_last;
reg [15:0] count;

initial begin
frequency <= 0;
count <= 0;
end

//Latch to retain last value. Used in finding freq.
always @ (posedge clk)
begin
	freq_last <= freq;
end

//Detects risingEdge of freq data stream.
assign risingEdge = freq & ~freq_last;


//Now find the freq of the data stream by counting clock pulses.
always @ (posedge clk)
begin
	//If posedge of freq is found, output # of clock pulses as freq and reset it.
	if (risingEdge)
	begin
		frequency <= count;
//		count <= 0;
	end
	count <= count + 1;
end

endmodule      
