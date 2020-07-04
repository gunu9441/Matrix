module fifo_cal(state, head, tail, data_count, we, re, next_head, next_tail, next_data_count);				//declare fifo_cal module
input [2:0] state, head, tail;																//set state,head,tail to input
input [3:0] data_count;																			//set data_count to input

output we, re;																						//set we, re to output
output [2:0] next_head, next_tail;															//set next head tail to output
output [3:0] next_data_count;																	//set next data count to output

reg [2:0] next_head, next_tail;																//set register
reg [3:0] next_data_count;																		//set register
reg we,re;																							//set register

parameter INIT = 3'b000;																		//set 3'b000 to INIT
parameter WRITE = 3'b001;																		//set 3'b001 to WRITE
parameter READ = 3'b010;																		//set 3'b010 to READ
parameter WR_ERROR = 3'b011;																	//set 3'b011 to WR_ERROR
parameter RD_ERROR = 3'b100;																	//set 3'b100 to RD_ERROR
parameter NO_OP = 3'b101;

always@(state, head, tail, data_count)														//whenever state, head, tail, data_count is changed..
begin
case (state)																						//if state is..

INIT://initial state
begin
next_head<=head;
next_tail<=tail;
next_data_count<=data_count;
we<=1'b0;
re<=1'b0;
end

WRITE://write state
begin
next_head<=head;
next_tail<=tail+3'b001;
next_data_count<=data_count+4'b0001;
we<=1'b1;
re<=1'b0;
end

READ://read state
begin
next_head<=head+3'b001;
next_tail<=tail;
next_data_count<=data_count-4'b0001;
we<=1'b0;
re<=1'b1;
end

WR_ERROR://write error state
begin
next_head<=head;
next_tail<=tail;
next_data_count<=data_count;
we<=1'b0;
re<=1'b0;	
end

RD_ERROR://read error state
begin
next_head<=head;
next_tail<=tail;
next_data_count<=data_count;
we<=1'b0;
re<=1'b0;	
end

NO_OP://no operation
begin
next_head<=head;
next_tail<=tail;
next_data_count<=data_count;
we<=1'b0;
re<=1'b0;
end

default :	//default
begin
next_head<=3'bxxx;
next_tail<=3'bxxx;
next_data_count<=4'bxxxx;
we<=1'bx;
re<=1'bx;
end

endcase
end
endmodule
