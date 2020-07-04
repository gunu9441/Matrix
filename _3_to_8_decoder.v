module _3_to_8_decoder(d,q);						//declare 3_to_1 decoder
	input [2:0]d;										//set input
	output reg [7:0] q;								//set output reg
	
	always@(d) begin									//always d is changed
		case(d)											//if d is...
			3'b000 : q = 8'b0000_0001;				//000, q is 0000_0001
			3'b001 : q = 8'b0000_0010;				//001, q is 0000_0010
			3'b010 : q = 8'b0000_0100;				//010, q is 0000_0100
			3'b011 : q = 8'b0000_1000;				//011, q is 0000_1000
			3'b100 : q = 8'b0001_0000;				//100, q is 0001_0000
			3'b101 : q = 8'b0010_0000;				//101, q is 0010_0000
			3'b110 : q = 8'b0100_0000;				//101, q is 0100_0000
			3'b111 : q = 8'b1000_0000;				//110, q is 1000_0000
			default: q = 8'hx;						//default q is xxxx_xxxx
		endcase
	end
endmodule												//end