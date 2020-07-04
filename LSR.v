module LSR(din, dout);							//declare LSR module
	input [16:0] din;								//set input    16:0
	output [16:0] dout;							//set output	16:0
	
	assign dout[14:0] = din[16:2];			//shift to right except msb	14:0	16:2
	assign dout[16] = 1'b0;						//set output's msb to 0			16
	assign dout[15] = 1'b0;																//15
endmodule 	
