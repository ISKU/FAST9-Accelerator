`define COLUMNS 8'd180
`define ROWS 8'd120

module FD_AddrCal (refAddr, adjNumber, sramAddr);
	input [14:0] refAddr;
	input [4:0] adjNumber;
	output [14:0] sramAddr;
	
	assign sramAddr =
		(adjNumber == 5'd0) ? refAddr :
		(adjNumber == 5'd1) ? refAddr - (3 * `COLUMNS) :
		(adjNumber == 5'd2) ? refAddr - (3 * `COLUMNS) + 1 :
		(adjNumber == 5'd3) ? refAddr - (2 * `COLUMNS) + 2 :
		(adjNumber == 5'd4) ? refAddr - (1 * `COLUMNS) + 3 :
		(adjNumber == 5'd5) ? refAddr + 3 :
		(adjNumber == 5'd6) ? refAddr + (1 * `COLUMNS) + 3 :
		(adjNumber == 5'd7) ? refAddr + (2 * `COLUMNS) + 2 :
		(adjNumber == 5'd8) ? refAddr + (3 * `COLUMNS) + 1 :
		(adjNumber == 5'd9) ? refAddr + (3 * `COLUMNS) :
		(adjNumber == 5'd10) ? refAddr + (3 * `COLUMNS) - 1 :
		(adjNumber == 5'd11) ? refAddr + (2 * `COLUMNS) - 2 :
		(adjNumber == 5'd12) ? refAddr + (1 * `COLUMNS) - 3 :
		(adjNumber == 5'd13) ? refAddr - 3 :
		(adjNumber == 5'd14) ? refAddr - (1 * `COLUMNS) - 3 :
		(adjNumber == 5'd15) ? refAddr - (2 * `COLUMNS) - 2 :
		(adjNumber == 5'd16) ? refAddr - (3 * `COLUMNS) - 1 : 15'bx;
endmodule 