module fifo(clk, reset_n, opclear, rd_en, wr_en, din, dout, data_count);			//declare fifo module
input clk, reset_n, opclear, rd_en, wr_en;													//set input
input [31:0] din;																				//set input
output [31:0] dout;																			//set data out																		//set full, empty to output
output [3:0] data_count;																	//set data_count output

wire [2:0] head, next_head;																//set wire
wire [2:0] tail, next_tail;																//set wire
wire [2:0] state, next_state;																//set wire
wire [3:0] next_data_count;																//set wire
wire we, re;																					//set wire
wire [31:0] to_mux, to_ff;																	//set wire


_dff_3_ro U0__dff_3_ro(.clk(clk), .reset_n(reset_n), .opclear(opclear), .d(next_head), .q(head));							//set dffr_3_r
_dff_3_ro U1__dff_3_ro(.clk(clk), .reset_n(reset_n), .opclear(opclear), .d(next_tail), .q(tail));							//set dffr_3_r
_dff_3_ro U2__dff_3_ro(.clk(clk), .reset_n(reset_n), .opclear(opclear), .d(next_state), .q(state)); 						//set dffr_3_r

fifo_ns U4_fifo_ns (.wr_en(wr_en), .rd_en(rd_en), .state(state), .data_count(data_count), .next_state(next_state));				//set fifo_next_state

fifo_cal U5_fifo_cal(.state(next_state), .head(head), .tail(tail), .data_count(data_count), .we(we), .re(re), .next_head(next_head), .next_tail(next_tail), .next_data_count(next_data_count));				//set calculate address module

RF U7_RF (.clk(clk), .clear(opclear), .wAddr(tail), .wData(din), .we(we), .rAddr(head), .rData(to_mux));																			//set register_file
	
mux2_32bit U8_mux2_32bit(.d0(32'h0000_0000), .d1(to_mux), .s(re), .y(to_ff));																					//set MUX2->if re is 1'b0, to_ff is 32'b0

_dff_4_ro U9_dff_4_ro(.clk(clk), .reset_n(reset_n), .opclear(opclear), .d(next_data_count), .q(data_count));											//set dff_4_r

_dff_32_ro U8_dff_32_ro(.clk(clk), .reset_n(reset_n), .opclear(opclear), .d(to_ff), .q(dout));																		//set dff_32

endmodule
