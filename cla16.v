module cla16(a,b,ci,s,co);																			//declar emodule
	input [15:0]a,b;																					//set the input that has 32 line
	input ci;																							//set the input
	output [15:0] s;																					//set the input that has 32 line
	output co;																							//set the input
	
	wire c1, c2, c3;																//set the wire
	
	cla4 U0_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(c1));				//set the cla4 module and connect line
	cla4 U1_cla4(.a(a[7:4]), .b(b[7:4]), .ci(c1), .s(s[7:4]), .co(c2));				//set the cla4 module and connect line
	cla4 U2_cla4(.a(a[11:8]), .b(b[11:8]), .ci(c2), .s(s[11:8]), .co(c3));			//set the cla4 module and connect line
	cla4 U3_cla4(.a(a[15:12]), .b(b[15:12]), .ci(c3), .s(s[15:12]), .co(co));		//set the cla4 module and connect line
endmodule																							//end of program
	

