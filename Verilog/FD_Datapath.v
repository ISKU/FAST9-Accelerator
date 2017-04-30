module FD_Datapath(refPixel, adjPixel, thres, isCorner);
	input [7:0] refPixel;
	input [127:0] adjPixel;
	input [5:0] thres;
	output isCorner;
	
	wire [7:0] lower;
	wire [7:0] upper;
	wire [31:0] compare;
	
	assign lower = refPixel - thres;
	assign upper = refPixel + thres;
	
	assign compare[1:0] = (adjPixel[127:120] <= lower) ? 2'b01 : (adjPixel[127:120] >= upper) ? 2'b10 : 2'b00;
	assign compare[3:2] = (adjPixel[119:112] <= lower) ? 2'b01 : (adjPixel[119:112] >= upper) ? 2'b10 : 2'b00;
	assign compare[5:4] = (adjPixel[111:104] <= lower) ? 2'b01 : (adjPixel[111:104] >= upper) ? 2'b10 : 2'b00;
	assign compare[7:6] = (adjPixel[103:96] <= lower) ? 2'b01 : (adjPixel[103:96] >= upper) ? 2'b10 : 2'b00;
	assign compare[9:8] = (adjPixel[95:88] <= lower) ? 2'b01 : (adjPixel[95:88] >= upper) ? 2'b10 : 2'b00;
	assign compare[11:10] = (adjPixel[87:80] <= lower) ? 2'b01 : (adjPixel[87:80] >= upper) ? 2'b10 : 2'b00;
	assign compare[13:12] = (adjPixel[79:72] <= lower) ? 2'b01 : (adjPixel[79:72] >= upper) ? 2'b10 : 2'b00;
	assign compare[15:14] = (adjPixel[71:64] <= lower) ? 2'b01 : (adjPixel[71:64] >= upper) ? 2'b10 : 2'b00;
	assign compare[17:16] = (adjPixel[63:56] <= lower) ? 2'b01 : (adjPixel[63:56] >= upper) ? 2'b10 : 2'b00;
	assign compare[19:18] = (adjPixel[55:48] <= lower) ? 2'b01 : (adjPixel[55:48] >= upper) ? 2'b10 : 2'b00;
	assign compare[21:20] = (adjPixel[47:40] <= lower) ? 2'b01 : (adjPixel[47:40] >= upper) ? 2'b10 : 2'b00;
	assign compare[23:22] = (adjPixel[39:32] <= lower) ? 2'b01 : (adjPixel[39:32] >= upper) ? 2'b10 : 2'b00;
	assign compare[25:24] = (adjPixel[31:24] <= lower) ? 2'b01 : (adjPixel[31:24] >= upper) ? 2'b10 : 2'b00;
	assign compare[27:26] = (adjPixel[23:16] <= lower) ? 2'b01 : (adjPixel[23:16] >= upper) ? 2'b10 : 2'b00;
	assign compare[29:28] = (adjPixel[15:8] <= lower) ? 2'b01 : (adjPixel[15:8] >= upper) ? 2'b10 : 2'b00;
	assign compare[31:30] = (adjPixel[7:0] <= lower) ? 2'b01 : (adjPixel[7:0] >= upper) ? 2'b10 : 2'b00;
	
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
		(compare[31:0] == 32'b 10xxxxxxxxxxxxxx1010101010101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 01xxxxxxxxxxxxxx0101010101010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 1010xxxxxxxxxxxxxx10101010101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 0101xxxxxxxxxxxxxx01010101010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 101010xxxxxxxxxxxxxx101010101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 010101xxxxxxxxxxxxxx010101010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 10101010xxxxxxxxxxxxxx1010101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 01010101xxxxxxxxxxxxxx0101010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 1010101010xxxxxxxxxxxxxx10101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 0101010101xxxxxxxxxxxxxx01010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 101010101010xxxxxxxxxxxxxx101010 ) ? 1'b1 :
		(compare[31:0] == 32'b 010101010101xxxxxxxxxxxxxx010101 ) ? 1'b1 :
		(compare[31:0] == 32'b 10101010101010xxxxxxxxxxxxxx1010 ) ? 1'b1 :
		(compare[31:0] == 32'b 01010101010101xxxxxxxxxxxxxx0101 ) ? 1'b1 :
		(compare[31:0] == 32'b 1010101010101010xxxxxxxxxxxxxx10 ) ? 1'b1 :
		(compare[31:0] == 32'b 0101010101010101xxxxxxxxxxxxxx01 ) ? 1'b1 : 1'b0;
endmodule 