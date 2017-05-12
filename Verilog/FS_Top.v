module FS_Top (clock, nReset, isCorner, compare, refAddr, refPixel, adjPixel, thres);
	input clock;
	input nReset;
	input isCorner; // Corner 확인
	input [31:0] compare; // DARK, BRIGHT, SIMILAR 값
	input [14:0] refAddr; // 기준점 주소
	input [7:0] refPixel; // 기준점 데이터
	input [127:0] adjPixel; // 인접한 16개의 점 데이터
	input [7:0] thres; // 임계값
	
	wire wren; // Score Memory에 쓰기 신호
	wire [7:0] scoreValue; // 점수 데이터
	wire [7:0] q; 
	
	// 코너의 스코어를 계산하는 모듈
	FS_Datapath datapth(
		.isCorner(isCorner),
		.compare(compare),
		.refAddr(refAddr),
		.refPixel(refPixel),
		.adjPixel(adjPixel),
		.thres(thres),
		.wren(wren),
		.scoreValue(scoreValue)
	);
	
	// 코너의 스코어를 저장하는 SRAM
	FS_ScoreMem scoreMem(
		.clock(clock),
		.address(refAddr),
		.data(scoreValue),
		.wren(wren),
		.q(q)
	);
endmodule 