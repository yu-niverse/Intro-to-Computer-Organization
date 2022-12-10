//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl (funct_i, ALUOp_i, ALUCtrl_o);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;
output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
       
//Select exact operation
always @(*) begin
    case (ALUOp_i)
        // R-Type
        3'b000:
            case (funct_i)
                6'b100000: ALUCtrl_o <= 4'b0010;  // Add
                6'b100010: ALUCtrl_o <= 4'b0110;  // Subtract
                6'b100100: ALUCtrl_o <= 4'b0000;  // And
                6'b100101: ALUCtrl_o <= 4'b0001;  // Or
                6'b101010: ALUCtrl_o <= 4'b0111;  // Set Less Than
                default:   ALUCtrl_o <= 4'bxxxx;
            endcase
        3'b100:   ALUCtrl_o <= 4'b0010;  // Add for addi
        3'b010:   ALUCtrl_o <= 4'b0110;  // Subtract for beq
        3'b101:   ALUCtrl_o <= 4'b0111;  // Set Less Than for slti
        default:  ALUCtrl_o <= 4'bxxxx;
    endcase
end

endmodule     





                    
                    