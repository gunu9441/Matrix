module MATRIX_Master(clk, reset_n, S_address, S_sel, S_wr, clear, m_interrupt, rData, M1_address, M1_dout, M1_req, M1_wr);
	input clk, reset_n;
	input [7:0] S_address;
	input S_sel, S_wr, clear, m_interrupt;
	input [31:0] rData;
	output reg [7:0] M1_address;
	output reg [31:0] M1_dout;
	output reg M1_req, M1_wr;
	
	reg [1:0] state, next_state;
	reg [1:0] count, next_count;
	
	parameter IDLE = 2'b00; 
	parameter EXEC = 2'b01;
	parameter DONE = 2'b10;
	
	always@(negedge reset_n or posedge clk)
	begin
		if(!reset_n)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	always@(state or clear or S_sel or S_wr or S_address or m_interrupt or count)
	begin
		case(state)
		IDLE:
		begin
			if(clear==1'b1)
				next_state <= IDLE;
			else if(S_sel&&S_wr&&S_address[3:0]==4'h6&&m_interrupt)
				next_state <= EXEC;
			else
				next_state <= IDLE;
		end
		EXEC:
		begin
			if(clear==1'b1)
				next_state <= IDLE;
			else if(count==2'h3)
				next_state <= DONE;
			else if(S_sel&&S_wr&&S_address[3:0]==4'h6&&m_interrupt&&count!=2'h3)
				next_state <= EXEC;
			else
				next_state <= IDLE;
		end
		DONE:
		begin
			if(clear==1'b1)
				next_state <= IDLE;
			else
				next_state <= DONE;
		end
		default:
			next_state <= 2'bx;
		endcase
	end
	
	always@(negedge reset_n or posedge clk)
	begin
		if(!reset_n)
			count <= 0;
		else
		begin
			count <= next_count;
		end
	end
	
	always@(state or count or rData or S_wr)
	begin
		case(state)
			IDLE:
			begin
				M1_address <= 8'b0;
				M1_dout <= 8'b0;
				M1_req <= 1'b0;
				M1_wr <= 1'b0;
			end
			EXEC:
			begin
				if(count==2'h0)
					M1_address <= 8'h60;
					
				else if(count==2'h1)
					M1_address <= 8'h61;
					
				else if(count==2'h2)
					M1_address <= 8'h62;
					
				else if(count==2'h3)
					M1_address <= 8'h63;
					
				M1_dout <= rData;
				M1_req <= 1'b1;
				M1_wr <= 1'b1;
			end
			DONE:
			begin
				M1_address <= 8'b0;
				M1_dout <= 8'b0;
				M1_req <= 1'b0;
				M1_wr <= 1'b0;
			end
			default:
			begin
				M1_address <= 8'bx;
				M1_dout <= 8'bx;
				M1_req <= 1'bx;
				M1_wr <= 1'bx;
			end
		endcase
	end
	
	always@(state or count)
	begin
		case(state)
		IDLE:
			next_count<=count;
		EXEC:
			next_count<=count+2'b1;
		DONE:
			next_count<=count;
		default:
			next_count<=3'bx;
		endcase
	end
		
endmodule	