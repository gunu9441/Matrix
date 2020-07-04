module Multiplier(clk, reset_n, fifo_data_count0, fifo_data_count1, multi_opclear, multi_opstart, multiplicand, multiplier, din_result, fifo_re, fifo_we, multi_opdone);
	input clk, reset_n, multi_opclear, multi_opstart;
	input [3:0] fifo_data_count0, fifo_data_count1;
	input [15:0] multiplier, multiplicand;
	output [31:0] din_result;
	output reg fifo_re, fifo_we;
	output reg multi_opdone;
	reg [31:0] din_result, next_din_result;
	reg[16:0] nX, X;																													//set next multiplier register and multiplier register
	reg[5:0] next_count, count;																		//set count and next_count register
	reg[2:0] state;
	reg [2:0] next_state;																									//set state and next_state register
	reg [15:0] t_multiplier, t_multiplicand;
	
	wire [31:0] w_add, w_sub, w_add2, w_sub2, w_result;														//set wire that connect cla to multiplier
	wire [16:0] w_X;																						//set wire that coonect LSR to multiplier

	parameter IDLE = 3'b000;																		//declare 000 to IDLE state
	parameter POP  = 3'b001;																		//declare 001 to POP state
	parameter EXEC = 3'b010;																		//declare 010 to EXEC state
	parameter WRITE= 3'b011;																		//declare 011 to WRITE state
	parameter DONE = 3'b100;																		//declare 100 to DONE state
	
	/*reset state*/
	always@(posedge clk or negedge reset_n)					//always clk is positive edge or reset_n is negative edge														
	begin
		if(!reset_n) 					state <= IDLE;												//if reset signal is 0, state is IDLE
		else 			 					state <= next_state;										//else current state is next_state
	end
	
	//ns_logic
	always@(state or count or multi_opstart or fifo_data_count0 or fifo_data_count1 or multi_opclear) begin								//always state, op_start, op_clear, op_done is changed
		case(state)																						//if state is...
		IDLE	: 																							//IDLE																							
		begin 																						
			if(multi_opstart==1)		next_state <= POP;
			else  						next_state <= IDLE;											//else next_state is EXEC
		end
      POP   :
		begin
			if(multi_opclear)													next_state <= IDLE;	
			else if(fifo_data_count0==0&&fifo_data_count1==0)		next_state <= DONE;
			else																	next_state <= EXEC;
		end
      EXEC	:
		begin
			if(multi_opclear)			next_state <= IDLE;
			else if(count != 8)		next_state <= EXEC;
			else							next_state <= WRITE;
		end
		WRITE	:
			if(multi_opclear)			next_state <= IDLE;
			else							next_state <= POP;
		DONE	:
			if(multi_opclear)			next_state <= IDLE;
			else							next_state <= DONE;
		default:
			next_state <= 3'bx;
   endcase
	end

	/*reset signal*/
	always@(posedge clk or negedge reset_n)
	begin
		if(!reset_n)
		begin
			count <= 6'b0;	
			X <= 17'h0;																						//reset X to 0
			din_result <= 32'h0;
		end
		else
		begin
			count <= next_count;	
			X <= nX;																						//reset X to 0
			din_result <= next_din_result;
		end
	end
	/*calculate logic*/
	always@(state or w_add or w_add2 or w_sub or w_sub2 or w_result or w_X or count or X or multi_opstart or multi_opclear or din_result or t_multiplicand or t_multiplier)
	begin
		case(state)
			IDLE:
			begin
				next_count <= 6'b0;	
				nX <= 17'h0;																						//reset X to 0
				next_din_result <= 32'b0;
			end
			POP:
			begin
			end
			EXEC:
			begin
				  if(X[2] == 1'b0 && X[1] == 1'b0 && X[0] == 1'b0) next_din_result <= w_result;				
				  else if(X[2] == 1'b0 && X[1] == 1'b0 && X[0] == 1'b1)begin									//else if two bits are 01,
						next_din_result = w_add;																//add and shift to right
						nX = w_X;
					end
				  else if(X[2] == 1'b0 && X[1] == 1'b1 && X[0] == 1'b0)begin									//else if two bits are 10,
						next_din_result = w_add;																//subtract and shift to right
						nX = w_X;
					end
					else if(X[2] == 1'b0 && X[1] == 1'b1 && X[0] == 1'b1)begin									//else if two bits are 10,
						next_din_result = w_add2;																//subtract and shift to right
						nX =w_X;
					end
					else if(X[2] == 1'b1 && X[1] == 1'b0 && X[0] == 1'b0)begin									//else if two bits are 10,
						next_din_result = w_sub2;																//subtract and shift to right
						nX = w_X;
					end
					else if(X[2] == 1'b1 && X[1] == 1'b0 && X[0] == 1'b1)begin									//else if two bits are 10,
						next_din_result = w_sub;																//subtract and shift to right
						nX = w_X;
					end
					else if(X[2] == 1'b1 && X[1] == 1'b1 && X[0] == 1'b0)begin									//else if two bits are 10,
						next_din_result = w_sub;																//subtract and shift to right
						nX = w_X;
					end
					else begin
						next_din_result <= w_result;
					end
					  if(count == 0)																		//if count is 0
						nX	<= {t_multiplier,1'b0};														//next set next X to 33bit(multiplicand + 0)
						else nX <= w_X;																	//if count is not 0, shift to right logically
					next_count <= count + 1'b1;														//add 1 to count
			end
			WRITE:
				begin
				next_din_result <= din_result;
				next_count <= 1'b0;
				end
			DONE:
			begin
			end
		endcase
	end
	
	always@(state or fifo_data_count0 or fifo_data_count1)
	begin
		case(state)
		IDLE:
			begin
				fifo_re <=1'b0;
				fifo_we <=1'b0;
				multi_opdone<=1'b0;
			end
		POP:	
			begin
				if(fifo_data_count0!=0 || fifo_data_count1!=0)
				begin
				fifo_re <= 1'b1;
				fifo_we <= 1'b0;
				multi_opdone<=1'b0;
				end
				else
				begin
				fifo_re <= 1'b0;
				fifo_we <= 1'b0;
				multi_opdone<=1'b0;
				end
			end
		EXEC:
			begin
				t_multiplier<=multiplier;
				t_multiplicand<=multiplicand;
				fifo_re <= 1'b0;
				fifo_we <= 1'b0;
				multi_opdone<=1'b0;
			end
		WRITE:
			begin
				fifo_re <= 1'b0;
				fifo_we <= 1'b1;
				multi_opdone<=1'b0;
			end
		DONE:
			begin
				fifo_re <= 1'b0;
				fifo_we <= 1'b0;
				multi_opdone<=1'b1;
			end
		endcase
	end
	
	ASR2 U0_ASR2 (.din(din_result), .dout(w_result));
	cal_cand U1_add (.a(din_result),.b(t_multiplicand),.ci(1'b0), .s(w_add));
	cal_cand U2_sub (.a(din_result),.b(~t_multiplicand),.ci(1'b1), .s(w_sub));
	cal_2mul U3_add(.a(din_result),.b(t_multiplicand),.ci(1'b0),.s(w_add2));
	cal_2mul U4_sub(.a(din_result),.b(~t_multiplicand),.ci(1'b1),.s(w_sub2));
	LSR U5_LSR (.din(X), .dout(w_X));															//instance LSR module
endmodule
