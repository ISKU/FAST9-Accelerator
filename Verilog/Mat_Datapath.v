module Mat_Datapath (adjFBPixel, dbValue, matPoint);
	input [63:0] adjFBPixel;
	input [287:0] dbValue;
	output matPoint;

	wire [7:0] refAvg;
	
	assign refAvg = 
		(adjFBPixel[7:0] +
		adjFBPixel[15:8] +
		adjFBPixel[23:16] +
		adjFBPixel[31:24] +
		adjFBPixel[39:32] +
		adjFBPixel[47:40] +
		adjFBPixel[55:48] +
		adjFBPixel[63:56]) / 8;
		
endmodule 