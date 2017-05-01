`define S0 5'd0
`define S1 5'd1
`define S2 5'd2
`define S3 5'd3
`define S4 5'd4
`define S5 5'd5
`define S6 5'd6
`define S7 5'd7
`define S8 5'd8
`define S9 5'd9
`define S10 5'd10
`define S11 5'd11
`define S12 5'd12
`define S13 5'd13
`define S14 5'd14
`define S15 5'd15
`define S16 5'd16
`define S17 5'd17
`define COLUMNS 4'd180
`define ROWS 4'd120

module FD_Controller (clock, nReset, refAddr, regAddr, readen);
	input clock;
	input nReset;
	output [14:0] refAddr;
	output [4:0] regAddr;
	output readen;
	
	reg [14:0] refAddr;
	reg [4:0] regAddr;
	reg [4:0] readen;
	
	reg [4:0] curState, nextState;
	reg [14:0] rowCount;
	
	always @(posedge clock or negedge nReset) begin
		if (!nReset) begin
			curState <= `S0;
			assign refAddr = 3 * `COLUMNS + 3;
			assign regAddr = 5'b0;
			rowCount <= 1'b1;
		end
		else
			curState <= nextState;
	end
	
	always @ (curState)
		casex (curState)
			`S0: begin
				nextState = `S1;
				regAddr = `S0;
				readen = 1'b0;
				
				if (refAddr == 14'd21600)
					refAddr = 1;
				else if (rowCount % `COLUMNS == 0)
					refAddr = refAddr + 3;
				else
					refAddr = refAddr + 1;
			end
			
			`S1: begin
				nextState = `S2;
				regAddr = `S1;
			end
			
			`S2: begin
				nextState = `S3;
				regAddr = `S2;
			end
			
			`S3: begin
				nextState = `S4;
				regAddr = `S3;
			end
			
			`S4: begin
				nextState = `S5;
				regAddr = `S4;
			end
			
			`S5: begin
				nextState = `S6;
				regAddr = `S5;
			end
			
			`S6: begin
				nextState = `S7;
				regAddr = `S6;
			end
			
			`S7: begin
				nextState = `S8;
				regAddr = `S7;
			end
			
			`S8: begin
				nextState = `S9;
				regAddr = `S8;
			end
			
			`S9: begin
				nextState = `S10;
				regAddr = `S9;
			end

			`S10: begin
				nextState = `S11;
				regAddr = `S10;
			end
			
			`S11: begin
				nextState = `S12;
				regAddr = `S11;
			end
			
			`S12: begin
				nextState = `S13;
				regAddr = `S12;
			end
			
			`S13: begin
				nextState = `S14;
				regAddr = `S13;
			end
			
			`S14: begin
				nextState = `S15;
				regAddr = `S14;
			end
			
			`S15: begin
				nextState = `S16;
				regAddr = `S15;
			end
			
			`S16: begin
				nextState = `S0;
				regAddr = `S16;
				readen = 1'b1;
			end
		endcase
endmodule 