module bus_addr (address, S0_sel, S1_sel, S2_sel, S3_sel);							//declare bus_addr module

	input [7:0]address;															//set input
	output reg S0_sel, S1_sel, S2_sel, S3_sel;													//set input

	always@(address)																//whenever address is changed
	begin
	if((address >= 8'h0) && (address < 8'h20))							//if address >= 8'h0 and address < 8'h20
	begin
		S0_sel <= 1'b1;															//output is 10
		S1_sel <= 1'b0;
		S2_sel <= 1'b0;
		S3_sel <= 1'b0;
	end

	else if((address >= 8'h20) && (address < 8'h40))					//else if address >= 8'h20 && address < 8'h40
	begin
		S0_sel <= 1'b0;															//output is 01
		S1_sel <= 1'b1;
		S2_sel <= 1'b0;
		S3_sel <= 1'b0;
	end

	else if((address >= 8'h40)&&(address < 8'h60))							//else if address >= 8'h40 && address < 8'h60
	begin
		S0_sel <= 1'b0;																//output is 00	
		S1_sel <= 1'b0;
		S2_sel <= 1'b1;
		S3_sel <= 1'b0;
	end
	
	else if((address >= 8'h60)&&(address < 8'h80))
	begin
		S0_sel <= 1'b0;	
		S1_sel <= 1'b0;
		S2_sel <= 1'b0;
		S3_sel <= 1'b1;
	end

	else																				//else
	begin
		S0_sel <= 1'b0;	
		S1_sel <= 1'b0;
		S2_sel <= 1'b0;
		S3_sel <= 1'b0;
	end
	end
	
endmodule
