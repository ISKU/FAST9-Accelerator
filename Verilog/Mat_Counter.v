module Mat_Counter (matPoint, posAddr, posReaden, isMatching);
	input matPoint;
	output posAddr;
	output posReaden;
	output isMatching;
	
	reg [5:0] count;
	
	// FSM
	always @(matPoint) begin
		casex (curState)
			`INIT: begin
				nextState = `S0;
				adjNumber = 3'bx;
				regAddr = 3'bx;
				matReaden = 1'b0;
				
				if (refAddr == 15'd21600)
					refAddr = 0;
				else if (refAddr != 0)
					refAddr = refAddr + 1;
				else
					refAddr = 15'b0;
			end
		
			`S0: begin
				nextState = `S1;
				adjNumber = 3'd0;
				regAddr = 3'bx;
			end
			
			`S1: begin
				nextState = `S2;
				adjNumber = 3'd1;
				regAddr = 3'bx;
			end
			
			`S2: begin
				nextState = `S3;
				adjNumber = 3'd2;
				regAddr = 3'd0;
			end
			
			`S3: begin
				nextState = `S4;
				adjNumber = 3'd3;
				regAddr = 3'd1;
			end
			
			`S4: begin
				nextState = `S5;
				adjNumber = 3'd4;				
				regAddr = 3'd2;
			end
			
			`S5: begin
				nextState = `S6;
				adjNumber = 3'd5;
				regAddr = 3'd3;
			end
			
			`S6: begin
				nextState = `S7;
				adjNumber = 3'd6;
				regAddr = 3'd4;
			end
			
			`S7: begin
				nextState = `S8;
				adjNumber = 3'd7;
				regAddr = 3'd5;
			end
			
			`S8: begin
				nextState = `S9;
				adjNumber = 3'dx;
				regAddr = 3'd6;
			end
			
			`S9: begin
				nextState = `S10;
				adjNumber = 3'dx;
				regAddr = 3'd7;
			end
			
			`S10: begin
				nextState = `INIT;
				adjNumber = 3'bx;
				regAddr = 3'bx;
				matReaden = 1'b1;
			end
		endcase
	end
endmodule 