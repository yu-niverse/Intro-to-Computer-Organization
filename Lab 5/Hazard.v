// 109550182

module Hazard (MemRead_S3, RT_address_S2, RT_address_S3, RS_address_S2, branch, 
	PCWrite_o, IFID_Write_o, IF_Flush, ID_Flush, EX_Flush);

input          MemRead_S3, branch;
input [5-1:0]  RT_address_S2, RT_address_S3, RS_address_S2;
output reg     PCWrite_o, IFID_Write_o, IF_Flush, ID_Flush, EX_Flush;

// Main Function
always @(*) begin

	PCWrite_o <= 0;
	IFID_Write_o <= 0;
	IF_Flush <= 0;
	ID_Flush <= 0;
	EX_Flush <= 0;

	// load use data hazard
	if (MemRead_S3 && ((RT_address_S3 == RS_address_S2) || (RT_address_S3 == RT_address_S2))) begin
		PCWrite_o <= 1;
		IFID_Write_o <= 1;
		ID_Flush <= 1;
	end

	// branch hazard       
	if (branch == 1) begin
		IF_Flush <= 1;
		ID_Flush <= 1;
		EX_Flush <= 1;
	end                    
end

endmodule