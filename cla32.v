module cla32(a,b,ci,s,co);																			//declar emodule
	input [31:0]a,b;																					//set the input that has 32 line
	input ci;																							//set the input
	output [31:0] s;																					//set the input that has 32 line
	output co;																							//set the input
	
	wire c1, c2, c3, c4, c5, c6, c7;																//set the wire
	
	cla4 U0_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(c1));				//set the cla4 module and connect line
	cla4 U1_cla4(.a(a[7:4]), .b(b[7:4]), .ci(c1), .s(s[7:4]), .co(c2));				//set the cla4 module and connect line
	cla4 U2_cla4(.a(a[11:8]), .b(b[11:8]), .ci(c2), .s(s[11:8]), .co(c3));			//set the cla4 module and connect line
	cla4 U3_cla4(.a(a[15:12]), .b(b[15:12]), .ci(c3), .s(s[15:12]), .co(c4));		//set the cla4 module and connect line
	cla4 U4_cla4(.a(a[19:16]), .b(b[19:16]), .ci(c4), .s(s[19:16]), .co(c5));		//set the cla4 module and connect line
	cla4 U5_cla4(.a(a[23:20]), .b(b[23:20]), .ci(c5), .s(s[23:20]), .co(c6));		//set the cla4 module and connect line
	cla4 U6_cla4(.a(a[27:24]), .b(b[27:24]), .ci(c6), .s(s[27:24]), .co(c7));		//set the cla4 module and connect line
	cla4 U7_cla4(.a(a[31:28]), .b(b[31:28]), .ci(c7), .s(s[31:28]), .co(co));		//set the cla4 module and connect line
	endmodule																							//end of program
	
module clb4(a,b,ci,c1,c2,c3,co);											//declare module
	input [3:0] a,b;																//set input that has 4 lines
	input ci;																		//set input
	output c1, c2, c3, co;														//set output

	wire [3:0] g,p;																//set wire that has 4 lines

	wire w0_c1;																		//set wire
	wire w0_c2, w1_c2;															//set wire
	wire w0_c3, w1_c3, w2_c3;													//set wire
	wire w0_co, w1_co, w2_co, w3_co;											//set wire

	//Generate
	_and2 U0_and2 (.a(a[0]), .b(b[0]), .y(g[0]));						//set and2 module and connect each lines
	_and2 U1_and2 (.a(a[1]), .b(b[1]), .y(g[1]));						//set and2 module and connect each lines
	_and2 U2_and2 (.a(a[2]), .b(b[2]), .y(g[2]));						//set and2 module and connect each lines
	_and2 U3_and2 (.a(a[3]), .b(b[3]), .y(g[3]));						//set and2 module and connect each lines

	//Propagate
	_or2 U4_or2 (.a(a[0]), .b(b[0]), .y(p[0]));							//set or2 module and connect each lines
	_or2 U5_or2 (.a(a[1]), .b(b[1]), .y(p[1]));							//set or2 module and connect each lines
	_or2 U6_or2 (.a(a[2]), .b(b[2]), .y(p[2]));							//set or2 module and connect each lines
	_or2 U7_or2 (.a(a[3]), .b(b[3]), .y(p[3]));							//set or2 module and connect each lines

	//c1 = g[0] | (p[0] & ci);
	_and2 U8_and2 (.a(p[0]),.b(ci),.y(w0_c1));							//set and2 module and connect each lines
	_or2 U9_or2 (.a(g[0]),.b(w0_c1),.y(c1));								//set or2 module and connect each lines

	//c2 = g[1]
	//    | (p[1] & g[0])
	//    | (p[1] & p[0] & ci)
	_and2 U10_and2 (.a(p[1]),.b(g[0]),.y(w0_c2));						//set and2 module and connect each lines
	_and3 U11_and3 (.a(p[1]),.b(p[0]),.c(ci),.y(w1_c2));				//set and2 module and connect each lines
	_or3 U12_or3 (.a(g[1]),.b(w0_c2),.c(w1_c2),.y(c2));				//set or2 module and connect each lines

	//c3 = g[2]
	//     | (p[2] & g[1])
	//     | (p[2] & p[1] & g[0])
	//     | (p[2] & p[1] & p[0] & ci)
	_and2 U13_and2(.a(p[2]),.b(g[1]),.y(w0_c3));							//set and2 module and connect each lines
	_and3 U14_and3(.a(p[2]),.b(p[1]),.c(g[0]),.y(w1_c3));				//set and3 module and connect each lines
	_and4 U15_and4(.a(p[2]),.b(p[1]),.c(p[0]),.d(ci),.y(w2_c3));	//set and4 module and connect each lines
	_or4 U16_or4(.a(g[2]),.b(w0_c3),.c(w1_c3),.d(w2_c3),.y(c3));	//set or2 module and connect each lines


	//co= g[3]
	//     | (p[3] & g[2])
	//     | (p[3] & p[2] & g[1])
	//     | (p[3] & p[2] & p[1] & g[0])
	//     | (p[3] & p[2] & p[1] & p[0] & ci)
	_and2 U17_and2(.a(p[3]),.b(g[2]),.y(w0_co));										//set and2 module and connect each lines
	_and3 U18_and3(.a(p[3]),.b(p[2]),.c(g[1]),.y(w1_co));							//set and3 module and connect each lines
	_and4 U19_and4(.a(p[3]),.b(p[2]),.c(p[1]),.d(g[0]),.y(w2_co));				//set and4 module and connect each lines
	_and5 U20_and5(.a(p[3]),.b(p[2]),.c(p[1]),.d(p[0]),.e(ci),.y(w3_co));	//set and5 module and connect each lines
	_or5  U21_or5 (.a(g[3]),.b(w0_co),.c(w1_co),.d(w2_co),.e(w3_co),.y(co));	//set or5 module and connect each lines
endmodule						//end of pro

module cla4(a,b,ci,s,co);													//declare cla4 module
input [3:0] a,b;																//set input that has 4 lines
input ci;																		//set input
output [3:0] s;
output co;

wire c1, c2, c3;																	//set wire
fa_v2 U0_fa_v2 (.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]));				//set fa_v2 module and connect each lines
fa_v2 U1_fa_v2 (.a(a[1]), .b(b[1]), .ci(c1), .s(s[1]));				//set fa_v2 module and connect each lines
fa_v2 U2_fa_v2 (.a(a[2]), .b(b[2]), .ci(c2), .s(s[2]));				//set fa_v2 module and connect each lines
fa_v2 U3_fa_v2 (.a(a[3]), .b(b[3]), .ci(c3), .s(s[3]));				//set fa_v2 module and connect each lines
clb4 U0_clb4 (.a(a), .b(b), .ci(ci), .c1(c1), .c2(c2), .c3(c3) , .co(co));			//set clb4 module and connect each lines

endmodule																			//end of program

module fa_v2(a,b,ci,s);									//declare module
input a,b,ci;												//set input
output s;													//set output

wire w0;														//set wire
 _xor2 U0_xor2(.a(a), .b(b), .y(w0));				//set module and connect each line
 _xor2 U1_xor2(.a(w0), .b(ci), .y(s));				//set module and connect each line
endmodule 													//end of program