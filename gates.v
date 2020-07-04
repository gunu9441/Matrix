module gates(a, y);				//declare the module
input a;								//set the input
output y;							//set the output
assign y = a;						//assign a's value to y
endmodule							//end of program

//inverter
module _inv(a,y);					//declare the module
input a;								//set the input
output y;							//set the output
assign y = ~a;						//assign ~a to y
endmodule							//end of program

//2 input nand
module _nand2(a,b,y);			//declare the module
input a,b;							//set the input
output y;							//set the output
assign y = ~(a&b);				//assign ~(a&b) to y
endmodule							//end of program

//2 input and
module _and2(a,b,y);				//declare the module
input a,b;							//set the input
output y;							//set the output
assign y = a&b;					//assign a&b to y
endmodule							//end of program

//2 input or
module _or2(a,b,y);				//declare the module
input a,b;							//set the input
output y;							//set the output
assign y = a|b;					//assign a|b to y
endmodule							//end of program

//2 input xor
module _xor2(a,b,y);				//declare the module
input a,b;							//set the input
output y;							//set the output

wire w0, w1, w2, w3;				//set the wire	

_inv U0_inv(.a(a), .y(w0));						//declare inverter variable
_inv U1_inv(.a(b), .y(w1));						//declare inverter variable

_and2 U2_and2 (.a(w0),.b(b),.y(w2));			//declare and gate variable
_and2 U3_and2 (.a(w1),.b(a),.y(w3));			//declare and gate variable

_or2 U4_or2 (.a(w2), .b(w3), .y(y));			//declare ore gate variable

endmodule	

//3 input and
module _and3(a,b,c,y);								//declare _and3 module
input a,b,c;											//set input	
output y;												//set output
assign y=a&b&c;										//assign y's value to a&b&c
endmodule												//end

//4 input and
module _and4(a,b,c,d,y);							//declare _and4 module
input a,b,c,d;											//set input
output y;												//set output
assign y=a&b&c&d;										//assign y's value to a&b&c&d
endmodule

//5 input and
module _and5(a,b,c,d,e,y);							//declare _and5 module
input a,b,c,d,e;										//set input
output y;												//set output
assign y=a&b&c&d&e;									//assign y's value to a&b&c&d&e
endmodule

//3 input or
module _or3(a,b,c,y);								//declare _or3 module
input a,b,c;											//set input
output y;												//set output
assign y=a|b|c;										//assign y's value to a|b|c
endmodule

//4 input or
module _or4(a,b,c,d,y);								//declare _or4 module
input a,b,c,d;											//set input
output y;												//set output
assign y=a|b|c|d;										//assign y's value to a|b|c|d
endmodule

//5 input or
module _or5(a,b,c,d,e,y);							//declare _or5 module
input a,b,c,d,e;										//set input
output y;												//set output
assign y=a|b|c|d|e;									//assign y's value to a|b|c|d|e
endmodule

//4bits inverter
module _inv_4bits(a,y);								//declare _inv_4bits module
input [3:0] a;											//set 4bits input
output [3:0] y;										//set 4bits output
assign y=~a;											//assign y's value to ~a
endmodule

//4bits 2input and
module _and2_4bits(a,b,y);							//declare _and2_4bits module
input [3:0] a,b;										//set 4bits input	
output [3:0] y;										//set 4bits output
assign y=a&b;											//assign y's value to a&b
endmodule

//4bits 2input or
module _or2_4bits(a,b,y);							//declare _or2_4bits module
input [3:0] a,b;										//set 4bits input
output [3:0] y;										//set 4bits output
assign y=a|b;											//assign y's value to a|b
endmodule

//4bits 2input xor
module _xor2_4bits(a,b,y);							//declare _xor2_4bits module
input [3:0] a,b;										//set 4bits input
output [3:0] y;										//set 4bits output
_xor2 U0_xor2(.a(a[0]), .b(b[0]), .y(y[0])); _xor2 U1_xor2(.a(a[1]), .b(b[1]), .y(y[1])); _xor2 U2_xor2(.a(a[2]), .b(b[2]), .y(y[2])); _xor2 U3_xor2(.a(a[3]), .b(b[3]), .y(y[3]));			//set xor2 module
endmodule

//4 bits 2 input xnor
module _xnor2_4bits(a,b,y);						//declare _xnor2_4bits module
input [3:0] a,b;										//set 4bits input
output [3:0] y;										//set 4bits output
wire [3:0] w0;											//ser 4bits wire 
_xor2_4bits U0_xor2_4bits(.a(a), .b(b), .y(w0)); _inv_4bits  U1_inv_4bits(.a(w0), .y(y));				//set xor2_4bits module
endmodule

//32 bits inverter 
module _inv_32bits(a,y);							//declare _inv_32bits module
input [31:0] a;										//set 32bits input
output [31:0] y;										//set 32bits output
assign y=~a;											//assign y's value to ~a
endmodule

// 32 bits 2-to-1 and gate 
module _and2_32bits(a,b,y);						//declare _and2_32bits module
input [31:0] a,b;										//set 32bits input
output [31:0] y;										//set 32bits output
assign y=a&b;											//assign y's value to a&b
endmodule

// 32 bits 2-to-1 or gate
module _or2_32bits(a,b,y);							//declare _or2_32bits module
input [31:0] a,b;										//set 32bits input
output [31:0] y;										//set 32bits output
assign y=a|b;											//assign y's value to a|b
endmodule 												//end of program

//32 bits exclusive or gate
module _xor2_32bits(a,b,y);							//declare _xor2_32bits module
input [31:0] a,b;											//set 32bits input
output [31:0] y;											//set 32bits output
_xor2_4bits U0_xor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0]));			//set xor2_4bits module U0
_xor2_4bits U1_xor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4]));			//set xor2_4bits module U1
_xor2_4bits U2_xor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8]));				//set xor2_4bits module U2
_xor2_4bits U3_xor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12]));			//set xor2_4bits module U3
_xor2_4bits U4_xor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16]));			//set xor2_4bits module U4
_xor2_4bits U5_xor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20]));			//set xor2_4bits module U5
_xor2_4bits U6_xor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24]));			//set xor2_4bits module U6
_xor2_4bits U7_xor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28]));			//set xor2_4bits module U7
endmodule


//32 bits exclusive nor gate
module _xnor2_32bits(a,b,y);						//declare _xnor2_32bits module
input [31:0] a,b;										//set 32bits input
output [31:0] y;										//set 32bits output
_xnor2_4bits U0_xnor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0]));							//set xNor2_4bits module U0
_xnor2_4bits U1_xnor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4]));							//set xnor2_4bits module U1
_xnor2_4bits U2_xnor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8]));						//set xnor2_4bits module U2
_xnor2_4bits U3_xnor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12]));					//set xnor2_4bits module U3
_xnor2_4bits U4_xnor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16]));					//set xnor2_4bits module U4
_xnor2_4bits U5_xnor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20]));					//set xnor2_4bits module U5
_xnor2_4bits U6_xnor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24]));					//set xnor2_4bits module U6
_xnor2_4bits U7_xnor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28]));					//set xnor2_4bits module U7
endmodule

//2-to-1 nor gate
module _nor2(a,b,y);
input a,b;
output y;
assign y=~(a|b);
endmodule
