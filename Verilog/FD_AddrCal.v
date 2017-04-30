`define COLUMNS 4'd180
`define ROWS 4'd120

module FD_AddrCal (refAddr, adjNumber, sramAddr);
	input [14:0] refAddr;
	input [3:0] adjNumber;
	output sramAddr;
	
	assign sramAddr =
		(adjNumber == 4'd0) ? refAddr - (3 * `COLUMNS) :
		(adjNumber == 4'd1) ? refAddr - (3 * `COLUMNS) + 1 :
		(adjNumber == 4'd2) ? refAddr - (2 * `COLUMNS) + 2 :
		(adjNumber == 4'd3) ? refAddr - (1 * `COLUMNS) + 3 :
		(adjNumber == 4'd4) ? refAddr + 3 :
		(adjNumber == 4'd5) ? refAddr + (1 * `COLUMNS) + 3 :
		(adjNumber == 4'd6) ? refAddr + (2 * `COLUMNS) + 2 :
		(adjNumber == 4'd7) ? refAddr + (3 * `COLUMNS) + 1 :
		(adjNumber == 4'd8) ? refAddr + (3 * `COLUMNS) :
		(adjNumber == 4'd9) ? refAddr + (3 * `COLUMNS) - 1 :
		(adjNumber == 4'd10) ? refAddr + (2 * `COLUMNS) - 2 :
		(adjNumber == 4'd11) ? refAddr + (1 * `COLUMNS) - 3 :
		(adjNumber == 4'd12) ? refAddr - 3 :
		(adjNumber == 4'd13) ? refAddr - (1 * `COLUMNS) - 3 :
		(adjNumber == 4'd14) ? refAddr - (2 * `COLUMNS) - 2 :
		(adjNumber == 4'd15) ? refAddr - (3 * `COLUMNS) - 1 : 16'bx;
endmodule 