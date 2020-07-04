module fifo_ns(wr_en, rd_en, state, data_count, next_state);								//declare fifo_ns module

input wr_en, rd_en;																						//set wr_en, rd_end to input
input [2:0] state;																						//set state to input
input [3:0] data_count;																					//set data count to input
output [2:0] next_state;																				//set next state to output

reg [2:0] next_state;																					//set next state to reg

parameter INIT = 3'b000;																				//set 3'b000 to INIT
parameter WRITE = 3'b001;																				//set 3'b001 to WRITE
parameter READ = 3'b010;																				//set 3'b010 to READ
parameter WR_ERROR = 3'b011;																			//set 3'b011 to WR_ERROR
parameter RD_ERROR = 3'b100;																			//set 3'b100 to RD_ERROR
parameter NO_OP =	3'b101;																				//set 3'b100 to RD_ERROR

always@ (wr_en, rd_en, data_count, state)															//whenever wr_en, rd_en,data_count, state is changed...
begin	
case(state)																									//if state is...
	INIT:																												//INIT
		begin
			if((wr_en) && (!rd_en) && (data_count < 8)) next_state <= WRITE; 				//if wr_en = 1 rd_en = 0 data_count < 8, next_state = WRTIE
			else if((!wr_en) && (rd_en) && (data_count == 0)) next_state <= RD_ERROR;			//if wr_en = 0 rd_en = 1 data_count == 0, next_state = RD_ERROR
			else if((!wr_en)&&(!rd_en)) next_state <= NO_OP;							//if wr_en = 0 rd_en = 0 or wr_en = 1 rde_en = 1, next_state = NO_OP
			else next_state <= 3'bxxx;
		end
	READ:																												//READ
		begin
			if((wr_en) && (!rd_en) && (data_count < 8)) next_state <= WRITE; 				//if wr_en = 1 rd_en = 0 data_count < 8, next_state = WRITE
			else if((!wr_en) && (rd_en) && (data_count > 0)) next_state <= READ;					//if wr_en = 0 rd_en = 1 data_count > 0, next_state = READ
			else if((!wr_en) && (rd_en) && (data_count == 0)) next_state <= RD_ERROR;			//if wr_en = 0 rd_en = 1 data_count == 0,next_state = RD_ERROR
			else if((!wr_en)&&(!rd_en)) next_state <= NO_OP;							//if wr_en = 0 rd_en = 0 or wr_en = 1 rde_en = 1, next_state = NO_OP
			else next_state <= 3'bxxx;
		end
	RD_ERROR:																										//RD_ERROR
		begin	
			if((wr_en) && (!rd_en) && (data_count < 8)) next_state <= WRITE; 				//if wr_en = 1 rd_en = 0 data_count < 8, next_state = WRITE
			else if((!wr_en) && (rd_en) && (data_count == 0)) next_state <= RD_ERROR;			//if wr_en = 0 rd_en = 1 data_count == 0,next_state = RD_ERROR
			else if((!wr_en)&&(!rd_en)) next_state <= NO_OP;							//if wr_en = 0 rd_en = 0 or wr_en = 1 rde_en = 1, next_state = NO_OP
			else next_state <= 3'bxxx;
		end
	WR_ERROR:																										//WR_ERROR
		begin
			if((wr_en) && (!rd_en) && (data_count == 8)) next_state <= WR_ERROR;			//if wr_en = 1 rd_en = 0 data_count == 8, next_state > 0, WR_ERROR
			else if((!wr_en) && (rd_en) && (data_count > 0)) next_state <= READ;					//if wr_en = 0 rd_en = 1 data_count > 0, next_state = READ
			else if((!wr_en)&&(!rd_en)) next_state <= NO_OP;							//if wr_en = 0 rd_en = 0 or wr_en = 1 rde_en = 1, next_state = NO_OP
			else next_state <= 3'bxxx;
		end
	WRITE:																											//WRITE
		begin
			if((wr_en) && (!rd_en) && (data_count < 8)) next_state <= WRITE; 				//if wr_en = 1 rd_en = 0 data_count < 8, next_state = WRITE
			else if((wr_en) && (!rd_en) && (data_count == 8)) next_state <= WR_ERROR;			//if wr_en = 1 rd_en = 0 data_count == 8, next_state > 0, WR_ERROR
			else if((!wr_en) && (rd_en) && (data_count > 0)) next_state <= READ;					//if wr_en = 0 rd_en = 1 data_count > 0, next_state = READ
			else if((!wr_en)&&(!rd_en)) next_state <= NO_OP;							//if wr_en = 0 rd_en = 0 or wr_en = 1 rde_en = 1, next_state = NO_OP
			else next_state <= 3'bxxx;
		end
	NO_OP:																											//NO_OP
		begin
			if(wr_en==1 && rd_en==0 && data_count<8) next_state<=WRITE;	
			else if(wr_en==0 && rd_en==1 && data_count>0) next_state<=READ;
			else if(wr_en==1 && rd_en==0 && data_count==8) next_state<=WR_ERROR;
			else if(wr_en==0 && rd_en==1 && data_count==0) next_state<=RD_ERROR;
			else next_state<=NO_OP;
		end
	default: next_state <= 3'bxxx;
endcase
end
endmodule

