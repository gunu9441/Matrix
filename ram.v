module ram(clk, cen, wen, addr, din, dout);
	input clk;
	input	cen, wen;
	input [4:0] addr;
	input [31:0] din;
	output reg [31:0] dout;
	
	reg [31:0] mem [0:31];
	
	integer i;									//loop
	
	initial begin								//initiate memory
		for(i=0;i<32;i=i+1)begin
			mem[i]=32'b0;
	end
	end
	
	always @(posedge clk)					//if clk rising...
	begin
	if(cen & wen)begin
		mem[addr]=din;							//input din to mem[addr]
		dout = 32'b0;
	end
	else if(cen&!wen)
		dout=mem[addr];						//mem[addr] move to dout
	else if(!cen) 
		dout = 32'b0;							//dout = 0		
	else dout = 32'bx;						//default
	end
endmodule
