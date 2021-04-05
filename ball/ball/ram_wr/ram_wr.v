module ram_wr(         //decode x,y to address
       input         clk50M,
		 input         rst_n,
		 input [7:0]   x,
		 input [8:0]   y,
		 input         write_en,
		 input [2:0]   color,
		 output        ram_wren,
		 output [16:0] ram_wraddr,
		 output [2:0]  ram_data
);
reg ram_wren_r;
reg [2:0] ram_data_r;
reg [16:0] ram_wraddr_r;
assign ram_wren   = ram_wren_r;
assign ram_data   = ram_data_r;
assign ram_wraddr = ram_wraddr_r;
always@(posedge clk50M or negedge rst_n)
begin
if(rst_n == 1'b0)
    begin
	 ram_wren_r   <= 1'b0;
	 ram_data_r   <= 3'b000;
	 ram_wraddr_r <= 17'd0;
	 end
else
    begin
	 ram_wraddr_r <= y*240+x;
	 ram_wren_r   <= write_en;
	 ram_data_r   <= color;
	 end
end
endmodule 