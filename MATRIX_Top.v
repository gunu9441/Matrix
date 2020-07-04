module MATRIX_Top(clk, reset_n, S_sel, S_wr, S_address, S_din, S_dout, m_interrupt, M1_wr, M1_req, M1_address, M1_dout, M_din, multi_done);
	input clk, reset_n;
	output multi_done;
	wire fifo_we;
	
	wire read_enable;
	wire [3:0] multiplier_data_count, multiplicand_data_count;//wire
	wire [15:0] multiplier_dout, multiplicand_dout;
	
	wire [3:0] adder_data_count;
	wire RF_we;
	wire adder_opdone;
	wire [31:0] adder_din_result;
	wire [3:0] wAddr;
	wire adder_read_enable;
	wire [31:0] rData;
	
	input [31:0] M_din;
	input [31:0] S_din;
	input [7:0] S_address;
	input S_sel, S_wr;
	output [31:0] S_dout;
	wire adder_opstart;
	output m_interrupt;
	wire opclear;
	wire multi_opstart;
	wire [31:0] multiplier, multiplicand;
	wire multiplier_wr_en, multiplicand_wr_en;
	wire [2:0] rAddr;
	
	wire [2:0] state;
	wire [31:0] MULTI_START;
	wire [31:0] din_result;
	wire [31:0] adder_dout;
	
	output [7:0] M1_address;
	output [31:0] M1_dout;
	output M1_req, M1_wr;
	wire [1:0] M_state, M_next_state;
	wire [1:0] count, next_count;
	
	Multiplier 			U0_Main(.clk(clk), .reset_n(reset_n), .fifo_data_count0(multiplier_data_count), .fifo_data_count1(multiplicand_data_count), .multi_opclear(opclear), .multi_opstart(multi_opstart), .multiplier(multiplier_dout), .multiplicand(multiplicand_dout), .din_result(din_result), .fifo_re(read_enable), .fifo_we(fifo_we), .multi_opdone(multi_done));
	fifo 		  			U1_multiplier(.clk(clk), .reset_n(reset_n), .opclear(opclear), .rd_en(read_enable), .wr_en(multiplier_wr_en), .din(multiplier), .dout(multiplier_dout), .data_count(multiplier_data_count));
	fifo 		  			U2_multiplicand(.clk(clk), .reset_n(reset_n), .opclear(opclear), .rd_en(read_enable), .wr_en(multiplicand_wr_en), .din(multiplicand), .dout(multiplicand_dout), .data_count(multiplicand_data_count));
	fifo		  			U3_Adder(.clk(clk), .reset_n(reset_n), .opclear(opclear), .rd_en(adder_read_enable), .wr_en(fifo_we), .din(din_result), .dout(adder_dout), .data_count(adder_data_count));
	ADDER		  			U4_ADDER(.clk(clk), .reset_n(reset_n), .fifo_data_count0(adder_data_count), .multi_opclear(opclear), .adder_opstart(adder_opstart), .add(adder_dout), .RF_we(RF_we), .adder_opdone(adder_opdone), .din_result(adder_din_result), .fifo_re(adder_read_enable), .wAddr(wAddr));
	RF						U5_ADDER_RF(.clk(clk), .clear(opclear), .we(RF_we), .wData(adder_din_result), .wAddr(wAddr[2:0]), .rAddr(rAddr), .rData(rData));
	Multiplier_Slave  U6_Multiplier_Slave(.clk(clk),
													 .reset_n(reset_n), 
													 .M_din(M_din), 
													 .S_din(S_din), 
													 .S_address(S_address), 
													 .S_sel(S_sel), 
													 .S_wr(S_wr), 
													 .adder_opdone(adder_opdone), 
													 .result(rData), 
													 .S_dout(S_dout), 
													 .adder_opstart(adder_opstart), 
													 .m_interrupt(m_interrupt), 
													 .multi_opclear(opclear), 
													 .multi_opstart(multi_opstart), 
													 .multiplicand(multiplicand), 
													 .multiplier(multiplier), 
													 .multiplicand_we(multiplicand_wr_en), 
													 .multiplier_we(multiplier_wr_en), 
													 .rAddr(rAddr));
	MATRIX_Master 	  U7_MATRIX_Master(.clk(clk), 
												 .reset_n(reset_n), 
												 .S_address(S_address), 
												 .S_sel(S_sel), 
												 .S_wr(S_wr), 
												 .clear(opclear), 
												 .m_interrupt(m_interrupt), 
												 .rData(S_dout), 
												 .M1_address(M1_address), 
												 .M1_dout(M1_dout), 
												 .M1_req(M1_req), 
												 .M1_wr(M1_wr));
endmodule	