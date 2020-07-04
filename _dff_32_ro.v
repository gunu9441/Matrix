module _dff_32_ro(clk, reset_n, opclear, d, q);								//declare d flip flop resetable module
	input clk, reset_n, opclear;
	input [31:0] d;										//set input
	output reg [31:0] q;									//set output reg
	
	always@ (posedge clk or negedge reset_n or posedge opclear)begin
		if(reset_n == 0) q <= 32'b0;
		else if(opclear == 1) q <= 32'b0;
		else q <= d;
	end
	
endmodule	