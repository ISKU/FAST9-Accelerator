module FD_Top (clock, nReset, isCorner, refAddr, refPixel, adjPixel, thres);
	input clock;
	input nReset;
	output isCorner;
	output [14:0] refAddr;
	output [7:0] refPixel;
	output [127:0] adjPixel;
	output [5:0] thres;
	
	wire readen;
	wire [4:0] regAddr;
	wire [14:0] sramAddr;
	wire [7:0] sramData;
	
	FD_Controller controller(
		.clock(clock),
		.nReset(nReset),
		.refAddr(refAddr),
		.regAddr(regAddr),
		.readen(readen),
	);
	
	FD_Datapath addrCal(
		.refAddr(refAddr),
		.adjNumber(regAddr),
		.sramAddr(sramAddr)
	);

	SRAM sram(
		.clock(clock),
		.address(sramAddr),
		.data(8'bx),
		.wren(1'b0),
		.q(sramData)
	);

	FD_Reg fd_reg(
		.clock(clock),
		.nReset(nReset),
		.readen(readen),
		.regAddr(regAddr),
		.sramData(sramData),
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres)
	);
	
	FD_Datapath datapath(
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres),
		.isCorner(isCorner),
	);
	
endmodule 