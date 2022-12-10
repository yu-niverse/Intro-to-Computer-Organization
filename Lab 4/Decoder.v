// 109550182

module Decoder (instr_op_i, ALUOp_o, ALUSrc_o, RegDst_o, Branch_o, MemRead_o, MemWrite_o, RegWrite_o, MemToReg_o);
     
// I/O ports
input  [6-1:0] instr_op_i;
// EX
output reg [2-1:0] ALUOp_o;
output reg         ALUSrc_o, RegDst_o;
// MEM
output reg 		   Branch_o, MemRead_o, MemWrite_o;
// WB
output reg         RegWrite_o;
output reg         MemToReg_o;


// Main Function
always @(*) begin
	case(instr_op_i)
		// R-Type Instructions : add, sub, and, or, slt
        6'b000000: begin
			ALUOp_o <= 2'b10;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'b1;    // write to RD
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;   // don't care
			MemWrite_o <= 1'b0;  // don't care
			RegWrite_o <= 1'b1;
			MemToReg_o <= 1'b0;  // no need to write memory data to reg
		end

        // addi
        6'b001000: begin
			ALUOp_o <= 2'b00;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;    // write to RT
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;   // don't care
			MemWrite_o <= 1'b0;  // don't care
			RegWrite_o <= 1'b1;
			MemToReg_o <= 1'b0;  // no need to write memory data to reg
		end

		// slti
        6'b001010: begin 
			ALUOp_o <= 2'b11;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;    // write to RT
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;   // don't care
			MemWrite_o <= 1'b0;  // don't care
			RegWrite_o <= 1'b1;
			MemToReg_o <= 1'b0;  // no need to write memory data to reg
		end

		// lw
		6'b100011: begin
			ALUOp_o <= 2'b00;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'b0;    // write to RT
			Branch_o <= 1'b0;
			MemRead_o <= 1'b1;
			MemWrite_o <= 1'b0;
			RegWrite_o <= 1'b1;
			MemToReg_o <= 1'b1;  // need to load memory data to reg
		end

		// sw
		6'b101011: begin
			ALUOp_o <= 2'b00;
			ALUSrc_o <= 1'b1;
			RegDst_o <= 1'bx;    // don't care
			Branch_o <= 1'b0;
			MemRead_o <= 1'b0;
			MemWrite_o <= 1'b1;
			RegWrite_o <= 1'b0;  // no need to write
			MemToReg_o <= 1'bx;  // don't care
		end

		// beq
        6'b000100: begin
			ALUOp_o <= 2'b01;
			ALUSrc_o <= 1'b0;
			RegDst_o <= 1'bx;    // don't care
			Branch_o <= 1'b1;
			MemRead_o <= 1'b0;   // don't care
			MemWrite_o <= 1'b0;  // don't care
			RegWrite_o <= 1'b0;  // no need to write
			MemToReg_o <= 1'bx;  // don't care
		end

        // default
        default: begin
			ALUOp_o <= 2'bxx;
			ALUSrc_o <= 1'bx;
			RegDst_o <= 1'bx;
			Branch_o <= 1'bx;
			MemRead_o <= 1'bx;
			MemWrite_o <= 1'bx;
			RegWrite_o <= 1'bx;
			MemToReg_o <= 1'bx;
		end
	endcase
end

endmodule





                    
                    