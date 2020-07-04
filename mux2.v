module mux2(d0, d1, s, y);								//declare MUX2 module
 input d0, d1; 											//set input
 input s; 													//set input
 output y; 													//set output
 
 assign y=(s==1'b0)?d0:d1; 							//assign y if(s is 1) to d0 else d1
 
endmodule