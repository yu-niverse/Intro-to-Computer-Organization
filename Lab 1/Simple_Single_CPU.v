//Subject:     CO project 2 - Simple Single CPU
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
module Simple_Single_CPU (clk_i, rst_i);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] pc_in, pc_out, next_pc, instr, rs, rt, WriteData;
wire [32-1:0] MUX_ALUSrc_out, offset, shifted_offset, jumped_pc;

//Instructions
wire [5-1:0] WriteReg_1;
wire [4-1:0] ALU_ctrl;

//Control signals
wire RegDst, RegWrite, ALU_src, branch, zero;
wire [3-1:0] ALU_op;

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

MUX_2to1 #(.size(5)) Mux_Write_Reg (
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(WriteReg_1)
);	
		
Reg_File RF (
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(WriteReg_1),  
        .RDdata_i(WriteData), 
        .RegWrite_i(RegWrite),
        .RSdata_o(rs),  
        .RTdata_o(rt)   
);
	
Decoder Decoder (
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
        .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALU_src),   
	    .RegDst_o(RegDst),   
        .Branch_o(branch)   
);

ALU_Ctrl AC (
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_ctrl) 
);
	
Sign_Extend SE (
        .data_i(instr[15:0]),
        .data_o(offset)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc (
        .data0_i(rt),
        .data1_i(offset),
        .select_i(ALU_src),
        .data_o(MUX_ALUSrc_out)
);	
		
ALU ALU (
        .src1_i(rs),
	    .src2_i(MUX_ALUSrc_out),
	    .ctrl_i(ALU_ctrl),
	    .result_o(WriteData),
        .zero_o(zero)
);
		
Adder Adder2 (
       .src1_i(shifted_offset),     
	   .src2_i(next_pc),     
	   .sum_o(jumped_pc)      
);
		
Shift_Left_Two_32 Shifter (
        .data_i(offset),
        .data_o(shifted_offset)
); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source (
        .data0_i(next_pc),
        .data1_i(jumped_pc),
        .select_i(branch & zero),
        .data_o(pc_in)
);	

endmodule
		  


