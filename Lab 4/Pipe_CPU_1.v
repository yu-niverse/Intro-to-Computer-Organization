// 109550182
`timescale 1ns / 1ps

module Pipe_CPU_1(clk_i, rst_i);

// I/O ports
input clk_i, rst_i;

// Internal signals
wire [32-1:0] PC_in, PC_out, Instr, Instr_S2, Instr_S3, DM_out, DM_out_S5;
wire [32-1:0] Adder1_out, Adder1_out_S2, Adder1_out_S3, Adder2_out, Adder2_out_S4;
wire [32-1:0] RS, RS_S3, RT, RT_S3, RT_S4, RD;
wire [32-1:0] ALU_out, ALU_out_S4, ALU_out_S5, SE_out, SE_out_S3, ALU_src2, SL_out;
wire [5-1:0] RD_address, RD_address_S4, RD_address_S5;

// Control Signals
wire [2-1:0] ALUOp, ALUOp_S3;
wire         ALUSrc, ALUSrc_S3, RegDst, RegDst_S3;
wire [4-1:0] ALUCtrl;
wire         Zero, Zero_S4;
wire         Branch, Branch_S3, Branch_S4, MemRead, MemRead_S3, MemRead_S4, MemWrite, MemWrite_S3, MemWrite_S4;
wire         RegWrite, RegWrite_S3, RegWrite_S4, RegWrite_S5, MemToReg, MemToReg_S3, MemToReg_S4, MemToReg_S5;


// Instruction Fetch IF Stage
MUX_2to1 #(.size(32)) MUX_PC (
	.data0_i(Adder1_out),
	.data1_i(Adder2_out_S4),
	.select_i(Branch_S4 & Zero_S4),
	.data_o(PC_in)
);

ProgramCounter PC (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_in_i(PC_in),
	.pc_out_o(PC_out)
);

Instruction_Memory IM (
	.addr_i(PC_out),
	.instr_o(Instr)
);

Adder Adder1 (
	.src1_i(PC_out),
	.src2_i(32'd4),
	.sum_o(Adder1_out)
);


// Instruction Decode ID Stage
Sign_Extend Sign_Extend (
	.data_i(Instr_S2[15:0]),
	.data_o(SE_out)
);

Reg_File RF (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RSaddr_i(Instr_S2[25:21]),
	.RTaddr_i(Instr_S2[20:16]),
	.RDaddr_i(RD_address_S5),
	.RDdata_i(RD),
	.RegWrite_i(RegWrite_S5),
	.RSdata_o(RS),
	.RTdata_o(RT)
);

Decoder Decoder (
    .instr_op_i(Instr_S2[31:26]), 
    .ALUOp_o(ALUOp), 
    .ALUSrc_o(ALUSrc), 
    .RegDst_o(RegDst), 
    .Branch_o(Branch), 
    .MemRead_o(MemRead), 
    .MemWrite_o(MemWrite), 
    .RegWrite_o(RegWrite), 
    .MemToReg_o(MemToReg)
);


// Execute EX Stage
MUX_2to1 #(.size(5)) MUX_RegDst (
	.data0_i(Instr_S3[20:16]),
	.data1_i(Instr_S3[15:11]),
	.select_i(RegDst_S3),
	.data_o(RD_address)
);

ALU_Ctrl ALU_Ctrl (
	.funct_i(SE_out_S3[5:0]),
	.ALUOp_i(ALUOp_S3),
	.ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) MUX_ALUSrc (
	.data0_i(RT_S3),
	.data1_i(SE_out_S3),
	.select_i(ALUSrc_S3),
	.data_o(ALU_src2)
);

ALU ALU (
	.src1_i(RS_S3),
	.src2_i(ALU_src2),
	.ctrl_i(ALUCtrl),
	.result_o(ALU_out),
	.zero_o(Zero)
);

Shift_Left_Two_32 Shifter (
	.data_i(SE_out_S3),
	.data_o(SL_out)
);

Adder Adder2 (
	.src1_i(Adder1_out_S3),
	.src2_i(SL_out),
	.sum_o(Adder2_out)
);


// Memory MEM Stage
Data_Memory DM (
	.clk_i(clk_i),
	.addr_i(ALU_out_S4),
	.data_i(RT_S4),
	.MemRead_i(MemRead_S4),
	.MemWrite_i(MemWrite_S4),
	.data_o(DM_out)
);

// Write Back WB Stage
MUX_2to1 #(.size(32)) MUX_MemToReg (
	.data0_i(ALU_out_S5),
	.data1_i(DM_out_S5),
	.select_i(MemToReg_S5),
	.data_o(RD)
);

// Signal Assignment (Pipelines)
Pipe_Reg #(.size(32 * 2)) IF_ID (
	.clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({ Adder1_out, Instr }),
    .data_o({ Adder1_out_S2, Instr_S2 })
);

Pipe_Reg #(.size(2 * 1 + 1 * 7 + 32 * 5)) ID_EX (
	.clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({ RegWrite, MemToReg, Branch, MemRead, MemWrite, RegDst, ALUOp, ALUSrc, Adder1_out_S2, RS, RT, SE_out, Instr_S2 }),
    .data_o({ RegWrite_S3, MemToReg_S3, Branch_S3, MemRead_S3, MemWrite_S3, RegDst_S3, ALUOp_S3, ALUSrc_S3, Adder1_out_S3, RS_S3, RT_S3, SE_out_S3, Instr_S3 })
);

Pipe_Reg #(.size(1 * 6 + 32 * 3 + 5 * 1)) EX_MEM (
	.clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({ RegWrite_S3, MemToReg_S3, Branch_S3, MemRead_S3, MemWrite_S3, Zero, Adder2_out, ALU_out, RT_S3, RD_address }),
    .data_o({ RegWrite_S4, MemToReg_S4, Branch_S4, MemRead_S4, MemWrite_S4, Zero_S4, Adder2_out_S4, ALU_out_S4, RT_S4, RD_address_S4 })
);

Pipe_Reg #(.size(1 * 2 + 32 * 2 + 5 * 1)) MEM_WB (
	.clk_i(clk_i),
	.rst_i(rst_i),
    .data_i({ RegWrite_S4, MemToReg_S4, DM_out, ALU_out_S4, RD_address_S4 }),
    .data_o({ RegWrite_S5, MemToReg_S5, DM_out_S5, ALU_out_S5, RD_address_S5 })
);

endmodule

