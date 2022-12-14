// 109550182

module ALU (src1_i, src2_i, ctrl_i, result_o, zero_o);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output reg  [32-1:0] result_o;
output wire          zero_o;

//Main function 
assign zero_o = (result_o == 0);
always @(ctrl_i, src1_i, src2_i) begin
    case (ctrl_i)
        4'b0000: result_o <= src1_i & src2_i;
        4'b0001: result_o <= src1_i | src2_i;
        4'b0010: result_o <= src1_i + src2_i;
        4'b0110: result_o <= src1_i - src2_i;
        4'b0111: result_o <= (src1_i < src2_i) ? 1 : 0;
        4'b1100: result_o <= ~(src1_i | src2_i);
        4'b1101: result_o <= src1_i * src2_i;
        default: result_o <= 0;
    endcase
end

endmodule





                    
                    