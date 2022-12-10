//109550182

module Decoder (instr_op_i, function_i, RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, 
	    Branch_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] function_i; // to determine jr instruction

output reg         RegWrite_o;
output reg [2-1:0] ALU_op_o;
output reg         ALUSrc_o;
output reg [2-1:0] RegDst_o;
output reg         Branch_o;
output reg 		   MemRead_o, MemWrite_o;
output reg [2-1:0] Jump_o, MemtoReg_o, BranchType_o;

//Main function
always @(*) begin
	case(instr_op_i)
		// R-Type Instructions : add, sub, and, or, slt, jr
        6'b000000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b1010010;
			case(function_i)
				6'b001000: { Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b10001100; //jr
				default: { Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01001100;
			endcase
		end
        // addi
        6'b001000: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0011000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01001100;
		end
        // beq
        6'b000100: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0100011;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01001100; //
		end
        // slti
        6'b001010: begin 
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b1111000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01001101;
		end
		// lw
		6'b100011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0011000;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01101001;
		end
		// sw
		6'b101011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0001010;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b01011101;
		end
		// jump
		6'b000010: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0000010; 
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b00001101; 
		end
		// jal
		6'b000011: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'b0010100; // RegDst ?
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'b00010001; //
		end
        // default
        default: begin
			{ ALU_op_o, RegWrite_o, ALUSrc_o, RegDst_o, Branch_o } <= 7'bxxxxxxx;
			{ Jump_o, MemRead_o, MemWrite_o, MemtoReg_o, BranchType_o } <= 8'bxxxxxxxx;
		end
	endcase
end

endmodule





                    
                    