// 109550182

module Forwarding (RS_address_S3, RT_address_S3, RD_address_S4, RD_address_S5, RegWrite_S4, RegWrite_S5, ForwardA_o, ForwardB_o);

// I/O ports
input [5-1:0] RS_address_S3, RT_address_S3, RD_address_S4, RD_address_S5;
input RegWrite_S4, RegWrite_S5;
output reg [2-1:0] ForwardA_o, ForwardB_o;

always @(*) begin

    if (RegWrite_S4 && (RD_address_S4 != 0) && (RD_address_S4 == RS_address_S3))
        ForwardA_o = 2'b01;
    else if (RegWrite_S5 && (RD_address_S5 != 0) && (RD_address_S5 == RS_address_S3)) 
        ForwardA_o = 2'b10;
    else  
        ForwardA_o = 2'b00;

    if (RegWrite_S4 && (RD_address_S4 != 0) && (RD_address_S4 == RT_address_S3))
        ForwardB_o = 2'b01;
    else if (RegWrite_S5 && (RD_address_S5 != 0) && (RD_address_S5 == RT_address_S3)) 
        ForwardB_o = 2'b10;
    else  
        ForwardB_o = 2'b00;

end
endmodule