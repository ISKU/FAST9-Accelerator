module FD_Testbench;
	reg clock;
	reg nReset;
	
	wire isCorner;
	wire [14:0] refAddr;
	wire [7:0] refPixel;
	wire [127:0] adjPixel;
	wire [7:0] thres;
	
	always begin
		#10 clock = ~clock;
		if (isCorner == 1'b1)
			$display($time, " isCorner: %d, refAddr: %d, refPixel: %h", isCorner, refAddr, refPixel);
	end
		
	FD_Top fd(
		.clock(clock), 
		.nReset(nReset),
		.isCorner(isCorner),
		.refAddr(refAddr),
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres)
	);
	
	initial begin
		clock = 1'b0;
		nReset = 1'b1;
		#100 nReset = 1'b0;
		#100 nReset = 1'b1;
		
		#6000000 $finish;
	end
endmodule 