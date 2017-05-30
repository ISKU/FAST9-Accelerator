module DBMEM (matReaden, dbValue, pointMat);
	input matReaden;
	output [287:0] dbValue;
	
	assign dbValue[7:0] = 8'd95; // 1
	assign dbValue[15:8] = 8'd95; // 2
	assign dbValue[23:16] = 8'd95; // 3
	assign dbValue[31:24] = 8'd95; // 4
	assign dbValue[39:32] = 8'd0; // 5
	assign dbValue[47:40] = 8'd0; // 6
	assign dbValue[55:48] = 8'd0; // 7
	assign dbValue[63:56] = 8'd0; // 8
	assign dbValue[71:64] = 8'd95; // 9
	assign dbValue[79:72] = 8'd95; // 10
	assign dbValue[87:80] = 8'd95; // 11
	assign dbValue[95:88] = 8'd95; // 12
	assign dbValue[103:96] = 8'd159; // 13
	assign dbValue[111:104] = 8'd159; // 14
	assign dbValue[119:112] = 8'd255; // 15
	assign dbValue[127:120] = 8'd255; // 16
	assign dbValue[135:128] = 8'd159; // 17
	assign dbValue[143:136] = 8'd159; // 18
	assign dbValue[151:144] = 8'd159; // 19
	assign dbValue[159:152] = 8'd159; // 20
	assign dbValue[167:160] = 8'd255; // 21
	assign dbValue[175:168] = 8'd255; // 22
 	assign dbValue[183:176] = 8'd159; // 23
	assign dbValue[191:184] = 8'd159; // 24
	assign dbValue[199:192] = 8'd95; // 25
	assign dbValue[207:200] = 8'd95; // 26
	assign dbValue[215:208] = 8'd95; // 27
	assign dbValue[223:216] = 8'd95; // 28
	assign dbValue[231:224] = 8'd0; // 29
	assign dbValue[239:232] = 8'd0; // 30
	assign dbValue[247:240] = 8'd0; // 31
	assign dbValue[255:248] = 8'd0; // 32
	assign dbValue[263:256] = 8'd95; // 33
	assign dbValue[271:264] = 8'd95; // 34
	assign dbValue[279:272] = 8'd95; // 35
	assign dbValue[287:280] = 8'd95; // 36
endmodule 