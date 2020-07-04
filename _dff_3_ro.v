module _dff_3_ro(clk, reset_n, opclear, d, q);							//declare d flip flop resetable module
	input clk, reset_n, opclear;												//set input
	input [2:0] d;
	output reg [2:0] q;												//set output reg
	
	always@ (posedge clk or negedge reset_n or posedge opclear)					//always clk is positive edge and reset_n is negetive edge
	begin		
		if(reset_n == 0) q <= 3'b0;								//if reset_n is 0, q is 0
		else if(opclear == 1) q <= 3'b0;
		else q <= d;													//else q is d (nonblocking)
	end
endmodule
