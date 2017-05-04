module FD_Datapath(refPixel, adjPixel, thres, isCorner);
	input [7:0] refPixel; // 기준점 데이터
	input [127:0] adjPixel; // 16개의 점 데이터
	input [7:0] thres; // 임계값
	output isCorner; // 코너 확인
	
	wire [8:0] lower; // 기준점 - 임계값 
	wire [8:0] upper; // 기준점 + 임계값 
	wire [31:0] compare; // 16개의 점에 대해서 각각 DARK, BRIGHT, SIMILAR를 저장
	
	assign lower = ((refPixel - thres) > 255) ? 8'd0 : (refPixel - thres); // 하한
	assign upper = ((refPixel + thres) > 255) ? 8'd255 : (refPixel + thres); // 상한 
	
	// 01 = DARK, 10 = BRIGHT, 00 = SIMILAR
	assign compare[1:0] = ({1'b0, adjPixel[127:120]} < lower) ? 2'b01 : ({1'b0, adjPixel[127:120]} > upper) ? 2'b10 : 2'b00;
	assign compare[3:2] = ({1'b0, adjPixel[119:112]} < lower) ? 2'b01 : ({1'b0, adjPixel[119:112]} > upper) ? 2'b10 : 2'b00;
	assign compare[5:4] = ({1'b0, adjPixel[111:104]} < lower) ? 2'b01 : ({1'b0, adjPixel[111:104]} > upper) ? 2'b10 : 2'b00;
	assign compare[7:6] = ({1'b0, adjPixel[103:96]} < lower) ? 2'b01 : ({1'b0, adjPixel[103:96]} > upper) ? 2'b10 : 2'b00;
	assign compare[9:8] = ({1'b0, adjPixel[95:88]} < lower) ? 2'b01 : ({1'b0, adjPixel[95:88]} > upper) ? 2'b10 : 2'b00;
	assign compare[11:10] = ({1'b0, adjPixel[87:80]} < lower) ? 2'b01 : ({1'b0, adjPixel[87:80]} > upper) ? 2'b10 : 2'b00;
	assign compare[13:12] = ({1'b0, adjPixel[79:72]} < lower) ? 2'b01 : ({1'b0, adjPixel[79:72]} > upper) ? 2'b10 : 2'b00;
	assign compare[15:14] = ({1'b0, adjPixel[71:64]} < lower) ? 2'b01 : ({1'b0, adjPixel[71:64]} > upper) ? 2'b10 : 2'b00;
	assign compare[17:16] = ({1'b0, adjPixel[63:56]} < lower) ? 2'b01 : ({1'b0, adjPixel[63:56]} > upper) ? 2'b10 : 2'b00;
	assign compare[19:18] = ({1'b0, adjPixel[55:48]} < lower) ? 2'b01 : ({1'b0, adjPixel[55:48]} > upper) ? 2'b10 : 2'b00;
	assign compare[21:20] = ({1'b0, adjPixel[47:40]} < lower) ? 2'b01 : ({1'b0, adjPixel[47:40]} > upper) ? 2'b10 : 2'b00;
	assign compare[23:22] = ({1'b0, adjPixel[39:32]} < lower) ? 2'b01 : ({1'b0, adjPixel[39:32]} > upper) ? 2'b10 : 2'b00;
	assign compare[25:24] = ({1'b0, adjPixel[31:24]} < lower) ? 2'b01 : ({1'b0, adjPixel[31:24]} > upper) ? 2'b10 : 2'b00;
	assign compare[27:26] = ({1'b0, adjPixel[23:16]} < lower) ? 2'b01 : ({1'b0, adjPixel[23:16]} > upper) ? 2'b10 : 2'b00;
	assign compare[29:28] = ({1'b0, adjPixel[15:8]} < lower) ? 2'b01 : ({1'b0, adjPixel[15:8]} > upper) ? 2'b10 : 2'b00;
	assign compare[31:30] = ({1'b0, adjPixel[7:0]} < lower) ? 2'b01 : ({1'b0, adjPixel[7:0]} > upper) ? 2'b10 : 2'b00;
	
	// 9개의 연속한 점이 DARK 또는 BRIGHT인 모든 경우의 수를 비교하여 코너 확인
	assign isCorner =
		(compare[31:14] == 18'h15555) ? 1'b1 :
		(compare[31:14] == 18'h2AAAA) ? 1'b1 :
		(compare[29:12] == 18'h15555) ? 1'b1 :
		(compare[29:12] == 18'h2AAAA) ? 1'b1 :
		(compare[27:10] == 18'h15555) ? 1'b1 :
		(compare[27:10] == 18'h2AAAA) ? 1'b1 :
		(compare[25:8] == 18'h15555) ? 1'b1 :
		(compare[25:8] == 18'h2AAAA) ? 1'b1 :
		(compare[23:6] == 18'h15555) ? 1'b1 :
		(compare[23:6] == 18'h2AAAA) ? 1'b1 :
		(compare[21:4] == 18'h15555) ? 1'b1 :
		(compare[21:4] == 18'h2AAAA) ? 1'b1 :
		(compare[19:2] == 18'h15555) ? 1'b1 :
		(compare[19:2] == 18'h2AAAA) ? 1'b1 :
		(compare[17:0] == 18'h15555) ? 1'b1 :
		(compare[17:0] == 18'h2AAAA) ? 1'b1 :
		((compare[31:30] == 2'b10) && (compare[15:0] == 16'hAAAA)) ? 1'b1 :
		((compare[31:30] == 2'b01) && (compare[15:0] == 16'h5555)) ? 1'b1 :
		((compare[31:28] == 4'hA) && (compare[13:0] == 14'h2AAA)) ? 1'b1 :
		((compare[31:28] == 4'h5) && (compare[13:0] == 14'h1555)) ? 1'b1 :
		((compare[31:26] == 6'h2A) && (compare[11:0] == 12'hAAA)) ? 1'b1 :
		((compare[31:26] == 6'h15) && (compare[11:0] == 12'h555)) ? 1'b1 :
		((compare[31:24] == 8'hAA) && (compare[9:0] == 10'h2AA)) ? 1'b1 :
		((compare[31:24] == 8'h55) && (compare[9:0] == 10'h155)) ? 1'b1 :
		((compare[31:22] == 10'h2AA) && (compare[7:0] == 8'hAA)) ? 1'b1 :
		((compare[31:22] == 10'h155) && (compare[7:0] == 8'h55)) ? 1'b1 :
		((compare[31:20] == 12'hAAA) && (compare[5:0] == 6'h2A)) ? 1'b1 :
		((compare[31:20] == 12'h555) && (compare[5:0] == 6'h15)) ? 1'b1 :
		((compare[31:18] == 14'h2AAA) && (compare[3:0] == 4'hA)) ? 1'b1 :
		((compare[31:18] == 14'h1555) && (compare[3:0] == 4'h5)) ? 1'b1 :
		((compare[31:16] == 16'hAAAA) && (compare[1:0] == 2'b10)) ? 1'b1 :
		((compare[31:16] == 16'h5555) && (compare[1:0] == 2'b01)) ? 1'b1 : 1'b0;
endmodule 