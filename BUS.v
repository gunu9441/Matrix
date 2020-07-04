module BUS(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M1_req, M1_wr, M1_address, M1_dout, S0_dout, S1_dout, S2_dout, S3_dout, M0_grant, M1_grant, M_din, S0_sel, S1_sel, S2_sel, S3_sel, S_address, S_wr, S_din);
	input clk, reset_n;												//flipflop signal
	input M0_req, M0_wr;												//Master 0 request and write or read signal
	input [7:0] M0_address;											//Master 0 address->something that is operated by Master 0 in Master 0 address
	input [31:0] M0_dout;											//data that is delivered by Master 0
	input M1_req, M1_wr;												//Master 1 request and write or read signal
	input [7:0] M1_address;											//Master 1 address->something that is operated by Master 0 in Master 1 address
	input [31:0] M1_dout;											//data that is delivered by Master 1
	input [31:0] S0_dout, S1_dout, S2_dout, S3_dout;		//slave 0, 1, 2, 3 data out
	output M0_grant, M1_grant;										//Master 0 grant, Master 1 grant
	output [31:0] M_din;												//data input to Master
	output S0_sel, S1_sel, S2_sel, S3_sel;						//S0 select, S1 select, S2 select, S3 select
	output [7:0] S_address;											//deliver address to slave
	output S_wr;														//deliver write or read signal to slave
	output [31:0] S_din;												//data input to slave
	
	wire [3:0] sel;													//receive S0 ~ S3_sel signal
	
	bus_arbit U0_bus_arbit(.M0_request(M0_req),.M1_request(M1_req),.M0_grant(M0_grant),.M1_grant(M1_grant),.clk(clk),.reset_n(reset_n));		//determine grant of M0 or M1
	mux2 U1_mux2(.d0(M0_wr),.d1(M1_wr),.s(M1_grant),.y(S_wr));																											//select M0_wr or M1_wr with M1_grant signal and deliver signal to slave
	mux2_8bit U2_mux2_8bit(.d0(M0_address),.d1(M1_address),.s(M1_grant),.y(S_address));																			//select M0_address or M1_address with M1_grant signal and deliver signal to slave
	bus_addr U3_bus_addr(.address(S_address), .S0_sel(S0_sel), .S1_sel(S1_sel), .S2_sel(S2_sel), .S3_sel(S3_sel));										//output Sn_sel determined by S_address
	_dff_4_r U4_dff_4_r(.clk(clk),.reset_n(reset_n),.d({S3_sel, S2_sel, S1_sel, S0_sel}),.q(sel));															//deliver S3_sel~S1_sel signal on clock rising
	mux5_32bit U4_mux5_32bit(.d0(S0_dout), .d1(S1_dout), .d2(S2_dout), .d3(S3_dout), .s(sel), .y(M_din));													//select the input data in S0~S3_dout
	mux2_32bit U3_mux2_32bit(.d0(M0_dout),.d1(M1_dout),.s(M1_grant),.y(S_din));																					//select M0_dout or M1_dout with M1_grant signal and deliver signal to slave
	
endmodule
	