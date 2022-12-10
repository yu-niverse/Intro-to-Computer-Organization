// 109550182

module Decoder (instr_op_i, ALUOp_o, ALUSrc_o, Branch_o, BranchType_o,
	MemToReg_o, MemRead_o, MemWrite_o, RegWrite_o, RegDst_o);

// I/O ports
input [6-1:0] instr_op_i;
output reg [2-1:0] ALUOp_o, BranchType_o;
output reg ALUSrc_o, RegDst_o, Branch_o, MemRead_o, MemWrite_o, RegWrite_o, MemToReg_o;

// Main Fuction

// ALUOp
always @(instr_op_i) begin
	casez (instr_op_i)
        6'b000000: ALUOp_o <= 2'b10;  // R Type
        6'b001000: ALUOp_o <= 2'b00;  // addi
        6'b10?011: ALUOp_o <= 2'b00;  // lw, sw
        6'b001010: ALUOp_o <= 2'b11;  // slti
		6'b000???: ALUOp_o <= 2'b01;  // beq, bne, bge, bgt
		default:   ALUOp_o <= 2'bxx;
	endcase
end

// ALUSrc
always @(instr_op_i) begin
	casez (instr_op_i)
		6'b0010?0: ALUSrc_o <= 1;  // addi, slti
		6'b10?011: ALUSrc_o <= 1;  // lw, sw
		default:   ALUSrc_o <= 0;
	endcase
end

// RegDst
always @(instr_op_i) begin
    RegDst_o <= instr_op_i == 6'b000000; // R Type
end

// MemRead & MemWrite & MemToReg
always @(instr_op_i) begin
	MemRead_o  <= instr_op_i == 6'b100011;  // lw
	MemWrite_o <= instr_op_i == 6'b101011;  // sw
    MemToReg_o <= instr_op_i == 6'b100011;  // lw
end

// RegWrite
always @(instr_op_i) begin
	casez (instr_op_i)
		6'b000000: RegWrite_o <= 1;  // R Type
		6'b0010?0: RegWrite_o <= 1;  // addi, slti
		6'b100011: RegWrite_o <= 1;  // lw
		default:   RegWrite_o <= 0;
	endcase
end

// Branch & BranchType
always @(instr_op_i) begin
    Branch_o <= instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111;
	casez (instr_op_i)
		6'b000100: BranchType_o <= 2'b00;  // beq
		6'b000111: BranchType_o <= 2'b01;  // bgt
		6'b000001: BranchType_o <= 2'b10;  // bge
		6'b000101: BranchType_o <= 2'b11;  // bne
		default: BranchType_o <= 2'b00;
	endcase
end

endmodule