module ADDER(clk, reset_n, fifo_data_count0, multi_opclear, adder_opstart, add, RF_we, adder_opdone, din_result, fifo_re, wAddr);
	input clk, reset_n;
	input [3:0] fifo_data_count0;
	input multi_opclear, adder_opstart;
	input [31:0] add;
	output reg RF_we, adder_opdone;
	output reg [31:0] din_result;
	output reg fifo_re;
	output reg [3:0] wAddr;
	
	reg [31:0] first, second;
	reg [31:0] next_din_result;
	reg [2:0] next_state;													
	reg [3:0] next_wAddr;
	reg [3:0] t_wAddr;
	reg [2:0] state;
	
	parameter IDLE = 3'b000;																		//declare 000 to IDLE state
	parameter POP1 = 3'b001;																		//declare 001 to POP1 state
	parameter POP2 = 3'b010;																		//declare 010 to POP2 state
	parameter EXEC = 3'b011;																		//declare 011 to EXEC state
	parameter WRITE= 3'b100;																		//declare 100 to WRITE state
	parameter DONE = 3'b101;																		//declare 101 to DONE state
	
	wire [31:0] w_add;
	
	/*reset state*/
	always@(posedge clk or negedge reset_n)					//always clk is positive edge or reset_n is negative edge														
	begin
		if(!reset_n) 					state <= IDLE;												//if reset signal is 0, state is IDLE
		else 			 					state <= next_state;										//else current state is next_state
	end
	
	//ns_logic
	always@(state or adder_opstart or fifo_data_count0 or multi_opclear)begin
		case(state)
		IDLE	:
		begin
			if(adder_opstart)			next_state <= POP1;
			else							next_state <= IDLE;
				
		end
		POP1	:
		begin	
			if(multi_opclear)							next_state <= IDLE;
			else if(fifo_data_count0==4'b0)		next_state <= DONE;
			else											next_state <= POP2;
		end
		POP2	:
		begin
			if(multi_opclear)							next_state <= IDLE;
			else											next_state <= EXEC;
		end
		EXEC	:
		begin
			if(multi_opclear)							next_state <= IDLE;
			else											next_state <= WRITE;
		end
		WRITE	:
		begin
			if(multi_opclear)							next_state <= IDLE;
			else											next_state <= POP1;
		end
		DONE	:
		begin
			if(multi_opclear)							next_state <= IDLE;
			else											next_state <= DONE;
		end
		default:
			next_state <= 3'bx;
		endcase
	end
	
	/*reset signal*/
	always@(posedge clk or negedge reset_n)
	begin
		if(!reset_n)
		begin
			din_result <= 32'b0;
		end
		else
		begin
			din_result <= next_din_result;
			t_wAddr <= next_wAddr;
		end
	end
	
	//calculation output logic
	always@(state or din_result or w_add or t_wAddr)
	begin
		case(state)
		IDLE:
			begin
				next_din_result <= 32'b0;
				next_wAddr <= 4'b0;
			end
		POP1:
			begin
				next_din_result <= din_result;
				next_wAddr <= t_wAddr;
			end
		POP2:
			begin
				next_din_result <= din_result;
				next_wAddr <= t_wAddr;
			end
		EXEC:
			begin
				next_din_result <= w_add;
				next_wAddr <= t_wAddr;
			end
		WRITE:
			begin
				next_din_result <= din_result;
				wAddr <= t_wAddr;
				next_wAddr <= t_wAddr + 1;
			end
		DONE:
			begin
			end
		endcase
	end
	
	//signal logic
	always@(state or next_state or fifo_data_count0)
	begin
		case(state)
		IDLE:
			begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b0;
			end
		POP1:
			begin
				if(fifo_data_count0!=0)
				begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b1;
				end
				else
				begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b0;
				end
			end
		POP2:
			begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b1;
				first <= add;
			end
		EXEC:
			begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b0;
				second <= add;
			end
		WRITE:
			begin
				RF_we <= 1'b1;
				adder_opdone <= 1'b0;
				fifo_re <= 1'b0;
			end
		DONE:
			begin
				RF_we <= 1'b0;
				adder_opdone <= 1'b1;
				fifo_re <= 1'b0;
			end
		endcase
	end
	
	cla32 U0_cla32(.a(first),.b(second),.ci(1'b0),.s(w_add),.co());
	
endmodule	