module I2C_Com(
	input clk,
	input SCL,
	reg SDA,
	reg [2:0] state,
	output SCL_port
);
assign SCL_port = SCL;
initial begin
	state = 4'b0;
	SDA=1;
end

always @ (posedge clk)
begin
	// Startup sequence for communication.
	if (start==0)
	begin
		SDA=0;
		start=1; //Set state to start write to port.
	end
	
	//
end

always @ (posedge SCL)
begin
	
end

endmodule