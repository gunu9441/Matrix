module bus_arbit(M0_request, M1_request, M0_grant, M1_grant, clk, reset_n);			//module start
	input M0_request, M1_request, clk, reset_n;													//declare input
	output reg M0_grant, M1_grant;																	//declare output
	reg state, next_state;																				//declare reg
	
	parameter M0_STATE = 1'b0;
	parameter M1_STATE = 1'b1;
	
	always@(posedge clk or negedge reset_n)begin													//register
		if(reset_n==1'b0) state <= M0_STATE;
		else if(reset_n==1'b1) state <= next_state;
		else state <= 1'bx;
	end
	
	always@ (M0_request or M1_request or state)begin											//ns logic
		case(state)																							//case start
		M0_STATE: begin																					//M0_state
		if(M0_request==1)
			next_state = M0_STATE;
		else if((M0_request==0)&&(M1_request==1))
			next_state = M1_STATE;
		else if((M0_request==0)&&(M1_request==0))
			next_state = M0_STATE;
		else
			next_state <= 1'bx;
		end
		
		M1_STATE: begin																					//M1_state
		if(M1_request==1)
			next_state = M1_STATE;
		else if (M1_request==0)
			next_state = M0_STATE;
		else
			next_state = 1'bx;
		end
		
		default: next_state = 1'bx;
		endcase																								//endcase
	end
	
	always @(state)begin																					//always at changing state
		case(state)																							//case start
		M0_STATE:begin																						//M0_STATE
			M0_grant=1'b1;
			M1_grant=1'b0;
		end
		M1_STATE:begin																						//M1_STATE
			M0_grant=1'b0;
			M1_grant=1'b1;
		end
		default:begin
			M0_grant=1'bx;
			M1_grant=1'bx;
		end
		endcase																								//endcase
	end
	endmodule																								//endmodule
	