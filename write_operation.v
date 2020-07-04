module write_operation(Addr, we,to_reg);									//declare write_operation module
	input we;																		//set input
	input [2:0] Addr;																//set input
	output [7:0] to_reg;															//set output
				
	wire [7:0] write_wire;														//set wire
	
	_3_to_8_decoder U0_3_to_8_decoder(.d(Addr),.q(write_wire));					//instance 3_to_8_decoder
	_and2 U1_and2(.a(we),.b(write_wire[0]),.y(to_reg[0]));						//instance and2
	_and2 U2_and2(.a(we),.b(write_wire[1]),.y(to_reg[1]));						//instance and2
	_and2 U3_and2(.a(we),.b(write_wire[2]),.y(to_reg[2]));						//instance and2
	_and2 U4_and2(.a(we),.b(write_wire[3]),.y(to_reg[3]));						//instance and2
	_and2 U5_and2(.a(we),.b(write_wire[4]),.y(to_reg[4]));						//instance and2
	_and2 U6_and2(.a(we),.b(write_wire[5]),.y(to_reg[5]));						//instance and2
	_and2 U7_and2(.a(we),.b(write_wire[6]),.y(to_reg[6]));						//instance and2
	_and2 U8_and2(.a(we),.b(write_wire[7]),.y(to_reg[7]));						//instance and2
	
	endmodule																					//end
		
