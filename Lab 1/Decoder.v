//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      109550182
//----------------------------------------------
//Date:        2022/04/25
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder (instr_op_i, RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Main function
always @(*) begin
	case (instr_op_i)
		// R-Type operations
		6'b000000: { RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b1000010;
		// beq
		6'b000100: { RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0010001;
		// addi
		6'b001000: {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 7'b1100100;
		// slti
		6'b001010: {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 7'b1101100;
		// default
		default: {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o} <= 7'bxxxxxxx;
	endcase
end

endmodule





                    
                    