module _8_to_1_MUX(a,b,c,d,e,f,g,h,sel,d_out);							//declare 8_to_1 MUX module
	input [31:0] a,b,c,d,e,f,g,h;												//set input
	input [2:0] sel;																//set input
	output reg [31:0] d_out;													//set output
	
	always@ (sel,a,b,c,d,e,f,g,h) begin										//always sel,a,b,c,d,e,f,g,h is changed
		case(sel)																	//if sel is...
			3'b000: d_out <= a;													//000, d_out is a
			3'b001: d_out <= b;													//001, d_out is b
			3'b010: d_out <= c;													//010, d_out is c
			3'b011: d_out <= d;													//011, d_out is d
			3'b100: d_out <= e;													//100, d_out is e
			3'b101: d_out <= f;													//101, d_out is f
			3'b110: d_out <= g;													//110, d_out is g
			3'b111: d_out <= h;													//111, d_out is h
			default: d_out = 32'hx;												//default d_out is xxxx_xxxx
		endcase																		
	end
endmodule																			//end
