`define INIT 4'd15
`define S0 4'd0
`define S1 4'd1
`define S2 4'd2
`define S3 4'd3
`define S4 4'd4
`define S5 4'd5
`define S6 4'd6
`define S7 4'd7
`define S8 4'd8
`define S9 4'd9
`define S10 4'd10

module NMS_Controller (clock, nReset, refAddr, adjNumber, regAddr, readen);
	input clock;
	input nReset;
	input [14:0] refAddr;
	output [3:0] adjNumber;
	output [3:0] regAddr;
	output readen;
	
	reg [3:0] adjNumber; // 8개의 점 Index
	reg [3:0] regAddr; // 레지스터 주소
	reg readen; // Datapath가 수행될 수 있도록 하는 enable 신호
	
	reg [3:0] curState, nextState; // 상태 변화
	
	// 클락이 상승할 때마다 현재 상태에서 다음상태로 변화
	always @(posedge clock or negedge nReset) begin
		if (!nReset)
			curState <= `INIT;
		else
			curState <= nextState;
	end
	
	// FSM
	always @(curState) begin
		casex (curState)
			`INIT: begin			
				if (refAddr < 15'd904) begin
					nextState = `INIT;
					readen = 1'b0;
				end
				else begin
					nextState = `S0;
					adjNumber = `S0;
					readen = 1'b0;
				end
			end
		
			`S0: begin
				nextState = `S1;
				adjNumber = `S1;
				regAddr = 4'bx;
			end
			
			`S1: begin
				nextState = `S2;
				adjNumber = `S2;
				regAddr = `S0;
			end
			
			`S2: begin
				nextState = `S3;
				adjNumber = `S3;
				regAddr = `S1;
			end
			
			`S3: begin
				nextState = `S4;
				adjNumber = `S4;
				regAddr = `S2;
			end
			
			`S4: begin
				nextState = `S5;
				adjNumber = `S5;				
				regAddr = `S3;
			end
			
			`S5: begin
				nextState = `S6;
				adjNumber = `S6;
				regAddr = `S4;
			end
			
			`S6: begin
				nextState = `S7;
				adjNumber = `S7;
				regAddr = `S5;
			end
			
			`S7: begin
				nextState = `S8;
				adjNumber = `S8;
				regAddr = `S6;
			end
			
			`S8: begin
				nextState = `S9;
				adjNumber = 4'bx;
				regAddr = `S7;
			end
			
			`S9: begin
				nextState = `INIT;
				adjNumber = 4'bx;
				regAddr = `S8;
				readen = 1'b1;
			end
		endcase
	end
endmodule 