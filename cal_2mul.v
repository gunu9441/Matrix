module cal_2mul(a,b,ci,s);

	input [31:0] a;			//[31:0]
	input [15:0] b;			//[15:0]
	input ci;	
	output [31:0] s;			//[31:0]

	wire [15:0] w_s1, w_s2;	//15:0
	wire[31:0] w_ASR;//31:0

	cla16 U0_cla16 (.a(a[31:16]),.b(b),.ci(ci),.s(w_s1), .co());  //31:16
	cla16 U1_cla16 (.a(w_s1),.b(b),.ci(ci),.s(w_s2), .co());				//set cla32
	
	ASR2 U2_ASR2(.din({w_s2,a[15:0]}), .dout(s));					//[15:0]
endmodule