// 109550182

module Simple_Single_CPU (clk_i, rst_i,
        pc_out, pc_in, next_pc,
        next_pc_1,
        instr,
        WriteReg,
        rs, rt,
        RegWrite, Branch, ALUsrc, MemRead, MemWrite,
        MemtoReg, BranchType, Jump, RegDst,
        ALUop,
        signExtended, leftShifted,
        ALUctrl, MUX_ALUsrc, ALUresult,
        zero, ReadData, WriteData, jump_out, MUX4_o
        );
		
//I/O port
input  clk_i, rst_i;

//Internal Signals

// Program Counter
output wire [32-1:0] pc_in, pc_out, next_pc, next_pc_1;
// Instruction Memory
output wire [32-1:0] instr;
// Register File
output wire [5-1:0] WriteReg;
output wire [32-1:0] rs, rt;
wire [32-1:0] WriteData;
// Decoder
output wire RegWrite, Branch, ALUsrc, MemRead, MemWrite;
output wire [2-1:0] MemtoReg, BranchType, Jump, RegDst;
output wire [2-1:0] ALUop;
// sign extension
output wire [32-1:0] signExtended;
// shift left
output wire [32-1:0] leftShifted;
// ALU control
output wire [4-1:0] ALUctrl;
// ALU
output wire [32-1:0] MUX_ALUsrc, ALUresult;
output wire zero;
// Data Memory 
output wire [32-1:0] ReadData;
// MUX for register
output wire [32-1:0] WriteData;
// MUX for jump
output wire [32-1:0] jump_out;
// 4 MUX for branch
output wire MUX4_o;

//Create components
ProgramCounter PC (
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_in),   
        .pc_out_o(pc_out) 
);
	
Adder Adder1 (
        .src1_i(pc_out),     
        .src2_i(32'd4),     
        .sum_o(next_pc)    
);

	
Instr_Memory IM (
        .pc_addr_i(pc_out),  
        .instr_o(instr)    
);

// MUX for Write Register
MUX_3to1 #(.size(5)) Mux_Write_Reg (
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
        .select_i(RegDst),
        .data_o(WriteReg)
);	
		
Reg_File Registers (
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(WriteReg),
        .RDdata_i(WriteData), 
        .RegWrite_i(RegWrite),
        .RSdata_o(rs), 
        .RTdata_o(rt)     
);
	
Decoder Decoder (
        .instr_op_i(instr[31:26]), 
        .function_i(instr[5:0]),
        .RegWrite_o(RegWrite), 
        .ALU_op_o(ALUop),   
        .ALUSrc_o(ALUsrc),   
        .RegDst_o(RegDst),   
        .Branch_o(Branch),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg),
        .BranchType_o(BranchType)
);

ALU_Ctrl AC (
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUop),   
        .ALUCtrl_o(ALUctrl) 
);
	
Sign_Extend SE (
        .data_i(instr[15:0]),
        .data_o(signExtended)
);

// MUX for ALU input
MUX_2to1 #(.size(32)) Mux_ALUSrc (
        .data0_i(rt),
        .data1_i(signExtended),
        .select_i(ALUsrc),
        .data_o(MUX_ALUsrc)
);	
		
ALU ALU (
        .src1_i(rs),
        .src2_i(MUX_ALUsrc),
        .ctrl_i(ALUctrl),
        .result_o(ALUresult),
        .zero_o(zero)
);
	
Data_Memory Data_Memory (
	.clk_i(clk_i),
	.addr_i(ALUresult),
	.data_i(rt),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(ReadData)
);

// address adder for pc
Adder Adder2 (
        .src1_i(next_pc),     
        .src2_i(leftShifted),     
        .sum_o(next_pc_1)      
);
		
Shift_Left_Two_32 Shifter(
        .data_i(signExtended),
        .data_o(leftShifted)
); 		
		
MUX_3to1 #(.size(32)) Mux_PC_Source(
        .data0_i({next_pc[31:28], instr[25:0], 2'b00}),
        .data1_i(jump_out),
        .data2_i(rs),
        .select_i(Jump),
        .data_o(pc_in)
);	

MUX_4to1 #(.size(32)) MUX_reg (
        .data0_i(next_pc),
        .data1_i(signExtended),
        .data2_i(ReadData),
        .data3_i(ALUresult),
        .select_i(MemtoReg),
        .data_o(WriteData)
);

MUX_2to1 #(.size(32)) MUX_jump (
        .data0_i(next_pc),
        .data1_i(next_pc_1),
        .select_i(Branch & MUX4_o),
        .data_o(jump_out)
);

MUX_4to1 #(.size(1)) MUX_4 (
        .data0_i(zero),
        .data1_i(~(ALUresult[31] | zero)),
        .data2_i(~ALUresult[31]),
        .data3_i(~zero),
        .select_i(BranchType),
        .data_o(MUX4_o)
);

endmodule