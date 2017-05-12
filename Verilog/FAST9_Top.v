module FAST9_Top (clock, nReset);
	input clock;
	input nReset;
	
	wire isCorner; // 코너 확인
	wire [31:0] compare; // DARK, BRIGHT, SIMILAR 값
	wire [14:0] refAddr; // 기준점 주소
	wire [7:0] refPixel; // 기준점 데이터
	wire [127:0] adjPixel; // 인접한 16개의 점 데이터
	wire [7:0] thres; // 임계값
	
	// Feature Detection
	FD_Top fd(
		.clock(clock), 
		.nReset(nReset),
		.isCorner(isCorner),
		.refAddr(refAddr),
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres),
		.compare(compare)
	);
	
	// Feature Score
	FS_Top fs(
		.clock(clock), 
		.nReset(nReset),
		.isCorner(isCorner),
		.compare(compare),
		.refAddr(refAddr),
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres)
	);
endmodule 