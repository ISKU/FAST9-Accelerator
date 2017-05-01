module FD_Reg (clock, nReset, readen, regAddr, sramData, refPixel, adjPixel, thres);
	input clock;
	input nReset;
	input readen;
	input [4:0] regAddr;
	input [7:0] sramData;
	output [7:0] refPixel;
	output [127:0] adjPixel;
	output [5:0] thres;

	reg [7:0] refPoint;
	reg [7:0] r1;
	reg [7:0] r2;
	reg [7:0] r3;
	reg [7:0] r4;
	reg [7:0] r5;
	reg [7:0] r6;
	reg [7:0] r7;
	reg [7:0] r8;
	reg [7:0] r9;
	reg [7:0] r10;
	reg [7:0] r11;
	reg [7:0] r12;
	reg [7:0] r13;
	reg [7:0] r14;
	reg [7:0] r15;
	reg [7:0] r16;
	
	wire [16:0] decoder;
	assign decoder =
		(regAddr == 5'd0) ? 17'd1 :
		(regAddr == 5'd1) ? 17'd2 :
		(regAddr == 5'd2) ? 17'd4 :
		(regAddr == 5'd3) ? 17'd8 :
		(regAddr == 5'd4) ? 17'd16 :
		(regAddr == 5'd5) ? 17'd32 :
		(regAddr == 5'd6) ? 17'd64 :
		(regAddr == 5'd7) ? 17'd128 :
		(regAddr == 5'd8) ? 17'd256 :
		(regAddr == 5'd9) ? 17'd512 :
		(regAddr == 5'd10) ? 17'd1024 :
		(regAddr == 5'd11) ? 17'd2048 :
		(regAddr == 5'd12) ? 17'd4096 :
		(regAddr == 5'd13) ? 17'd8192 :
		(regAddr == 5'd14) ? 17'd16384 :
		(regAddr == 5'd15) ? 17'd32768 :
		(regAddr == 5'd16) ? 17'd32768 : 17'bx;
		
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			refPoint <= 8'b0;
		else if (decoder[0])
			refPoint <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r1 <= 8'b0;
		else if (decoder[1])
			r1 <= sramData;

	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r2 <= 8'b0;
		else if (decoder[2])
			r2 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r3 <= 8'b0;
		else if (decoder[3])
			r3 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r4 <= 8'b0;
		else if (decoder[4])
			r4 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r5 <= 8'b0;
		else if (decoder[5])
			r5 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r6 <= 8'b0;
		else if (decoder[6])
			r6 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r7 <= 8'b0;
		else if (decoder[7])
			r7 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r8 <= 8'b0;
		else if (decoder[8])
			r8 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r9 <= 8'b0;
		else if (decoder[9])
			r9 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r10 <= 8'b0;
		else if (decoder[10])
			r10 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r11 <= 8'b0;
		else if (decoder[11])
			r11 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r12 <= 8'b0;
		else if (decoder[12])
			r12 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r13 <= 8'b0;
		else if (decoder[13])
			r13 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r14 <= 8'b0;
		else if (decoder[14])
			r14 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r15 <= 8'b0;
		else if (decoder[15])
			r15 <= sramData;
			
	always @ (posedge clock or negedge nReset)
		if (!nReset)
			r16 <= 8'b0;
		else if (decoder[16])
			r16 <= sramData;
			
	assign refPixel = (readen) ? refPoint : 8'bx;
	assign adjPixel = (readen) ? {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15} : 128'bx;
	assign thres = (readen) ? 5'd30 : 5'bx;
endmodule 