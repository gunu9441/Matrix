module register32_8(clk, clear, en, d_in, d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7);			//declare 32bit register(8) module
	input clk, clear;										//set input
	input [7:0] en;														//set input
	input [31:0] d_in;													//set input
	output [31:0] d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7;													//set output
	
	register32_r_en U0_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out0), .en(en[0]));			//instance 32bit register resetable enable
	register32_r_en U1_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out1), .en(en[1]));			//instance 32bit register resetable enable
	register32_r_en U2_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out2), .en(en[2]));			//instance 32bit register resetable enable
	register32_r_en U3_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out3), .en(en[3]));			//instance 32bit register resetable enable
	register32_r_en U4_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out4), .en(en[4]));			//instance 32bit register resetable enable
	register32_r_en U5_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out5), .en(en[5]));			//instance 32bit register resetable enable
	register32_r_en U6_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out6), .en(en[6]));			//instance 32bit register resetable enable
	register32_r_en U7_register32_r_en (.clk(clk), .clear(clear), .d_in(d_in), .d_out(d_out7), .en(en[7]));			//instance 32bit register resetable enable

	endmodule																//end
	
	
module register32_r_en(clk, clear, d_in, d_out, en);			 	//declare 32bit register resetable enable module
	input clk, clear, en;														//set input
	input [31:0] d_in;																		//set input
	output [31:0] d_out;																		//set output
	
	register8_r_en U0_register8_r_en(.clk(clk), .clear(clear), .d_in(d_in[7:0]), .d_out(d_out[7:0]), .en(en));				//instance 8 bit register restable enable
	register8_r_en U1_register8_r_en(.clk(clk), .clear(clear), .d_in(d_in[15:8]), .d_out(d_out[15:8]), .en(en));			//instance 8 bit register restable enable
	register8_r_en U2_register8_r_en(.clk(clk), .clear(clear), .d_in(d_in[23:16]), .d_out(d_out[23:16]), .en(en));		//instance 8 bit register restable enable
	register8_r_en U3_register8_r_en(.clk(clk), .clear(clear), .d_in(d_in[31:24]), .d_out(d_out[31:24]), .en(en));		//instance 8 bit register restable enable
	
	endmodule																					//end
	