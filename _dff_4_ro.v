module _dff_4_ro(clk, reset_n, opclear, d, q);
	input clk, reset_n, opclear;
	input [3:0] d;
	output reg [3:0] q;
	
	always@ (posedge clk or negedge reset_n or posedge opclear)
	begin
		if(reset_n == 0) q <= 4'b0;
		else if(opclear == 1) q <= 4'b0;
		else q <= d;
	end
endmodule
	