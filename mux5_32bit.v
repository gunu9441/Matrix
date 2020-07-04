module mux5_32bit(d0, d1, d2, d3, s, y);										//declare MUX2 module
 input [31:0] d0, d1, d2, d3; 													//set input
 input [3:0] s; 																		//set input
 output [31:0] y; 																	//set output
 
 assign y=(s==4'b0000)?32'h00:(s==4'b0001)?d0:(s==4'b0010)?d1:(s==4'b0100)?d2:(s==4'b1000)?d3:32'hx;					//assign y if(s is 1) to d0 else d1
 
endmodule		