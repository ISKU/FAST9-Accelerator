module Addr_Reg (refAddr, posAddr, matPoint, posReaden, position);
	input [14:0] refAddr;
	input [3:0] posAddr;
	input matPoint;
	input posReaden;
	output [239:0] position;

	reg r1, r2, r3, r4, r5, r6, r7, r8, r9;
	reg r10, r11, r12, r13, r14, r15, r16;
	
	wire [15:0] decoder;
	assign decoder =
		(regAddr == 4'd0) ? 16'd1 :
		(regAddr == 4'd1) ? 16'd2 :
		(regAddr == 4'd2) ? 16'd4 :
		(regAddr == 4'd3) ? 16'd8 :
		(regAddr == 4'd4) ? 16'd16 :
		(regAddr == 4'd5) ? 16'd32 :
		(regAddr == 4'd6) ? 16'd64 :
		(regAddr == 4'd7) ? 16'd128 :
		(regAddr == 4'd8) ? 16'd256 :
		(regAddr == 4'd9) ? 16'd512 :
		(regAddr == 4'd10) ? 16'd1024 :
		(regAddr == 4'd11) ? 16'd2048 :
		(regAddr == 4'd12) ? 16'd4096 :
		(regAddr == 4'd13) ? 16'd8192 :
		(regAddr == 4'd14) ? 16'd16384 :
		(regAddr == 4'd15) ? 16'd32768 : 4'bx;
	
	always @(posAddr)
	if (decoder[0])
		r1 <= refAddr;
		
	always @(posAddr)
	if (decoder[1])
		r2 <= refAddr;
	
	always @(posAddr)
	if (decoder[2])
		r3 <= refAddr;
	
	always @(posAddr)
	if (decoder[3])
		r4 <= refAddr;
	
	always @(posAddr)
	if (decoder[4])
		r5 <= refAddr;
	
	always @(posAddr)
	if (decoder[5])
		r6 <= refAddr;
	
	always @(posAddr)
	if (decoder[6])
		r7 <= refAddr;
	
	always @(posAddr)
	if (decoder[7])
		r8 <= refAddr;
	
	always @(posAddr)
	if (decoder[8])
		r9 <= refAddr;
	
	always @(posAddr)
	if (decoder[9])
		r10 <= refAddr;
	
	always @(posAddr)
	if (decoder[10])
		r11 <= refAddr;
	
	always @(posAddr)
	if (decoder[11])
		r12 <= refAddr;
	
	always @(posAddr)
	if (decoder[12])
		r13 <= refAddr;
	
	always @(posAddr)
	if (decoder[13])
		r14 <= refAddr;
	
	always @(posAddr)
	if (decoder[14])
		r15 <= refAddr;
	
	always @(posAddr)
	if (decoder[15])
		r16 <= refAddr;
		
	assign position = 
		(posReaden == 1'b1) ? {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16} : 240'bx;
endmodule 