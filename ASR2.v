module ASR2(din, dout);								//declare ASR module
	input [31:0] din;									//set din		[31:0]	
	output [31:0]	dout;								//set dout		[31:0]
	
	assign dout[29:0] = din[31:2];				//shift to right except 63bit [29:0] [31:2]
	assign dout[31] = din[31];						//copy msb to dout's msb    [31] [31]
	assign dout[30] = din[31];						//[30] [31]
endmodule 
