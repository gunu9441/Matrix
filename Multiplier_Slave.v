module Multiplier_Slave(clk, reset_n, M_din, S_din, S_address, S_sel, S_wr, adder_opdone, result, S_dout, adder_opstart, m_interrupt, multi_opclear, multi_opstart, multiplicand, multiplier, multiplicand_we, multiplier_we, rAddr);
	input clk, reset_n;
	input [31:0] M_din, S_din;
	input	[7:0] S_address;
	input S_sel, S_wr;
	input adder_opdone;
	input  [31:0] result;
	output reg [31:0] S_dout;
	output reg adder_opstart;
	output reg m_interrupt, multi_opclear, multi_opstart;
	output reg [31:0] multiplicand, multiplier;
	output reg multiplicand_we, multiplier_we;
	output reg [2:0] rAddr;
	
	reg [31:0] A_Matrix, B_Matrix, INTERRUPT_ENABLE, /*MULTI_START,*/ ADD_START, OPERATION_CLEAR, READ_ADDRESS;
	reg [31:0] next_A_Matrix, next_B_Matrix, next_INTERRUPT_ENABLE, next_MULTI_START, next_ADD_START, next_OPERATION_CLEAR, next_READ_ADDRESS;
	reg [2:0] next_state;
	
	reg [31:0] MULTI_START;
	reg [2:0] state;
	
	parameter IDLE = 2'b00; 
	parameter MULT = 2'b01;
	parameter ADDE = 2'b10;
	parameter DONE = 2'b11;
	
	//ns_logic
	always@(state or OPERATION_CLEAR or MULTI_START[0] or ADD_START[0] or adder_opdone)begin
		case(state)
		IDLE:
		begin
			if(OPERATION_CLEAR==32'b1)
				next_state <= IDLE;
			else if(MULTI_START[0]==1'b1) //MULTI_START[0]==1
				next_state <= MULT;
			else
				next_state <= IDLE;
		end
		MULT:
		begin
			if(OPERATION_CLEAR==32'b1)
				next_state <= IDLE;
			else if(ADD_START[0] == 1'b1)		//ADD_START[0] == 1
				next_state <= ADDE;
			else
				next_state <= MULT;
		end
		ADDE:
		begin
			if(OPERATION_CLEAR==32'b1)
				next_state <= IDLE;
			else if(adder_opdone==1'b1)
				next_state <= DONE;
			else
				next_state <= ADDE;
		end
		DONE:
		begin
			if(OPERATION_CLEAR==32'b1)
				next_state <= IDLE;
			else
				next_state <= DONE;
		end
		default:
			next_state <= 2'bx;
		endcase
	end
	
	//state_flip_flop
	always@(posedge clk or negedge reset_n)
	begin
		if(reset_n==1'b0) state <= IDLE;
		else					state <= next_state;
	end
	
	//signal_flip_flop
	always@(posedge clk or negedge reset_n or posedge OPERATION_CLEAR[0])
	begin
		if(reset_n==1'b0||OPERATION_CLEAR[0]==1'b1)
		begin
			A_Matrix <= 32'b0;
			B_Matrix <= 32'b0;
			INTERRUPT_ENABLE <= 32'b0;
			MULTI_START <= 32'b0;
			ADD_START <= 32'b0;
			OPERATION_CLEAR <= next_OPERATION_CLEAR;
			READ_ADDRESS <= 32'b0;
		end
		else        
		begin
			A_Matrix <= next_A_Matrix;
			B_Matrix <= next_B_Matrix;
			INTERRUPT_ENABLE[0] <= next_INTERRUPT_ENABLE[0];
			MULTI_START[0] <= next_MULTI_START[0];
			ADD_START[0] <= next_ADD_START[0];
			OPERATION_CLEAR <= next_OPERATION_CLEAR;
			READ_ADDRESS[3:0] <= next_READ_ADDRESS[3:0];
		end
	end
	
	//offset_register_logic
	always@(S_wr or S_sel or S_address or S_din or M_din or OPERATION_CLEAR)
	begin
		if(S_wr&&S_sel&&S_address[3:0]==4'h0)
			next_A_Matrix <= M_din;
	
		else if(S_wr&&S_sel&&S_address[3:0]==4'h1)
			next_B_Matrix <= M_din;
			
		else if(S_wr&&S_sel&&S_address[3:0]==4'h2)
			next_INTERRUPT_ENABLE <= S_din;
			
		else if(S_wr&&S_sel&&S_address[3:0]==4'h3)
			next_MULTI_START <= S_din;
			
		else if(S_wr&&S_sel&&S_address[3:0]==4'h4)
			next_ADD_START <= S_din;
			
		else if(S_wr&&S_sel&&S_address[3:0]==4'h5)
			next_OPERATION_CLEAR <= S_din;
			
		else if(S_wr&&S_sel&&S_address[3:0]==4'h6)
			next_READ_ADDRESS <= S_din;
			
		else
			begin
			end
		if(OPERATION_CLEAR==32'b1)begin
			next_A_Matrix <= 32'b0;
			next_B_Matrix <= 32'b0;
		end
	end
	
	always@(state or OPERATION_CLEAR[0] or MULTI_START[0] or ADD_START[0] or adder_opdone or INTERRUPT_ENABLE[0])
	begin
		case(state)
		IDLE:
		begin
			if(OPERATION_CLEAR==32'b1)
				multi_opclear <= 1'b1;
			else
				multi_opclear <= 1'b0;
				
			if(MULTI_START[0]==1'b1)
				multi_opstart <= 1'b0;
			else
				multi_opstart <= 1'b0;
				
			if(ADD_START[0]==1'b1)
				adder_opstart <= 1'b0;
			else
				adder_opstart <= 1'b0;
				
			if(adder_opdone==1&&INTERRUPT_ENABLE[0]==1)
				m_interrupt <= 1'b0;
			else
				m_interrupt <= 1'b0;
		end
		MULT:
		begin
			if(OPERATION_CLEAR==32'b1)
				multi_opclear <= 1'b1;
			else
				multi_opclear <= 1'b0;
				
			if(MULTI_START[0]==1'b1)
				multi_opstart <= 1'b1;
			else
				multi_opstart <= 1'b0;
			
			if(ADD_START[0]==1'b1)
				adder_opstart <= 1'b0;
			else
				adder_opstart <= 1'b0;
				
			if(adder_opdone==1&&INTERRUPT_ENABLE[0]==1)
				m_interrupt <= 1'b0;
			else
				m_interrupt <= 1'b0;
		end
		ADDE:
		begin
			if(OPERATION_CLEAR==32'b1)
				multi_opclear <= 1'b1;
			else
				multi_opclear <= 1'b0;
				
			if(MULTI_START[0]==1'b1)
				multi_opstart <= 1'b1;
			else
				multi_opstart <= 1'b0;
			
			if(ADD_START[0]==1'b1)
				adder_opstart <= 1'b1;
			else
				adder_opstart <= 1'b0;
				
			if(adder_opdone==1&&INTERRUPT_ENABLE[0]==1)
				m_interrupt <= 1'b0;
			else
				m_interrupt <= 1'b0;
				
		end
		DONE:
		begin
			if(OPERATION_CLEAR==32'b1)
				multi_opclear <= 1'b1;
			else
				multi_opclear <= 1'b0;
				
			if(MULTI_START[0]==1'b1)
				multi_opstart <= 1'b0;
			else
				multi_opstart <= 1'b0;
			
			if(ADD_START[0]==1'b1)
				adder_opstart <= 1'b0;
			else
				adder_opstart <= 1'b0;
				
			if(adder_opdone==1&&INTERRUPT_ENABLE[0]==1)
				m_interrupt <= 1'b1;
			else
				m_interrupt <= 1'b0;
		end
		endcase
	end
	
	//output_signal_logic->when offset_register_signal change, output_signal change
	always@(state or OPERATION_CLEAR or A_Matrix or B_Matrix)
	begin
		case(state)
			IDLE:
			begin
				if(OPERATION_CLEAR==32'b1||reset_n==0)begin
					multiplicand_we <= 1'b0;
					multiplier_we <= 1'b0;
					end
				else 
				begin
					if(S_wr&&S_address[3:0]==4'b0)
					begin
						multiplicand_we <= 1'b1;
						multiplier_we <= 1'b0;
					end
					else if(S_wr&&S_address[3:0]==4'b1)
					begin
						multiplicand_we <= 1'b0;
						multiplier_we <= 1'b1;
					end
					else
					begin
						multiplicand_we <= 1'b0;
						multiplier_we <= 1'b0;
					end
				end	
			end
			MULT:
			begin
				multiplicand_we <= 1'b0;
				multiplier_we <= 1'b0;
			end
			ADDE:
			begin
				multiplicand_we <= 1'b0;
				multiplier_we <= 1'b0;
			end
			DONE:
			begin
				multiplicand_we <= 1'b0;
				multiplier_we <= 1'b0;
			end
		endcase
	end
	
	always@(state or A_Matrix or B_Matrix or result or READ_ADDRESS)begin
		case(state)
			IDLE:
			begin
				multiplicand <= A_Matrix;
				multiplier <= B_Matrix;
			end
			MULT:
				begin
				end
			ADDE:
				begin
				end
			DONE:
				begin
					S_dout <= result;
					rAddr <= READ_ADDRESS[2:0];
				end
		endcase
	end
		
endmodule	
	
	