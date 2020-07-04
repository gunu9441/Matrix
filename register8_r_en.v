module register8_r_en(clk, clear, d_in, d_out, en);																			//declare 8bit register resetable enable module
	input clk, clear, en;																												//set input
	input [7:0] d_in;																														//set input
	output [7:0] d_out;																													//set output
	
	_dff_r_en U0_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[0]), .q(d_out[0]));			//instance d flip flop with resetable enable
	_dff_r_en U1_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[1]), .q(d_out[1]));			//instance d flip flop with resetable enable
	_dff_r_en U2_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[2]), .q(d_out[2]));			//instance d flip flop with resetable enable
	_dff_r_en U3_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[3]), .q(d_out[3]));			//instance d flip flop with resetable enable
	_dff_r_en U4_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[4]), .q(d_out[4]));			//instance d flip flop with resetable enable
	_dff_r_en U5_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[5]), .q(d_out[5]));			//instance d flip flop with resetable enable
	_dff_r_en U6_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[6]), .q(d_out[6]));			//instance d flip flop with resetable enable
	_dff_r_en U7_dff_r_en(.clk(clk), .clear(clear), .en(en), .d(d_in[7]), .q(d_out[7]));			//instance d flip flop with resetable enable
	
endmodule																																				//end


module _dff_r_en(clk, clear, en, d, q);												//declare d flip flop with resetable enable module
	input clk, clear, en, d;																//set input
	output reg q;																				//set output reg
	
	always@ (posedge clk or posedge clear)begin				//always clk is positive edge or reset_n is negetive edge
		if(clear)			q <= 1'b0;
		else if(en)			q <= d;															//else if en is not zero, q is d
		else					q <= q;															//else q is q
	end
endmodule																						//end