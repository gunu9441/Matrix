module cal_cand(a,b,ci, s);

	input [31:0] a; //31:0
	input [15:0] b; //15:0
	input ci;
	output [31:0] s; //31:0

	wire [15:0] w_s;//15:0
	wire [31:0] w_ASR;//31:0

	cla16 U0_cla16 (.a(a[31:16]),.b(b),.ci(ci),.s(w_s), .co());				//set cla32 [31:16]
	ASR2 U1_ASR2(.din({w_s,a[15:0]}), .dout(s));													//[15:0]
endmodule
