// 109550182

module ALU_Ctrl (funct_i, ALUOp_i, ALUCtrl_o);
          
//I/O ports 
input  [6-1:0] funct_i;
input  [2-1:0] ALUOp_i;
output reg  [4-1:0] ALUCtrl_o;    

//Select exact operation
always @(*) begin
    case (ALUOp_i)
        // R-Type
        2'b10:
            case (funct_i)
                6'b100000: ALUCtrl_o <= 4'b0010;  // Add
                6'b100010: ALUCtrl_o <= 4'b0110;  // Subtract
                6'b100100: ALUCtrl_o <= 4'b0000;  // And
                6'b100101: ALUCtrl_o <= 4'b0001;  // Or
                6'b101010: ALUCtrl_o <= 4'b0111;  // Set Less Than
                6'b001100: ALUCtrl_o <= 4'b1101;  // Mult
                default:   ALUCtrl_o <= 4'bxxxx;
            endcase
        2'b00:    ALUCtrl_o <= 4'b0010;  // Add for addi, lw, sw
        2'b01:    ALUCtrl_o <= 4'b0110;  // Subtract for beq
        2'b11:    ALUCtrl_o <= 4'b0111;  // Set Less Than for slti
        default:  ALUCtrl_o <= 4'bxxxx;
    endcase
end

endmodule     





                    
                    