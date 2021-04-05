/*
down_edge_det u_down_edge_det_0
                    (.clk(),
                     .rst_n(),
							.key0(),
							.key1(),
							.key2(),
							.key3(),
							.flag0(),
							.flag1(),
							.flag2(),
							.flag3()
							);
*/

module down_edge_det(input clk,
                     input rst_n,
							input key0,
							input key1,
							input key2,
							input key3,
							output flag0,
							output flag1,
							output flag2,
							output flag3
							);

reg key0_r1,key0_r2;
reg key1_r1,key1_r2;
reg key2_r1,key2_r2;
reg key3_r1,key3_r2;
assign flag0 = (key0_r1 == 1'b0) && key0_r2;
assign flag1 = (key1_r1 == 1'b0) && key1_r2;
assign flag2 = (key2_r1 == 1'b0) && key2_r2;
assign flag3 = (key3_r1 == 1'b0) && key3_r2;
always@(posedge clk or negedge rst_n)
begin
if(rst_n == 1'b0)
    begin
	 key0_r1 <= 1'b1;
	 key0_r2 <= 1'b1;
	 key1_r1 <= 1'b1;
	 key1_r2 <= 1'b1;
	 key2_r1 <= 1'b1;
	 key2_r2 <= 1'b1;
	 key3_r1 <= 1'b1;
	 key3_r2 <= 1'b1;
	 end
else
    begin
	 key0_r1 <= key0;
	 key0_r2 <= key0_r1;
	 key1_r1 <= key1;
	 key1_r2 <= key1_r1;
	 key2_r1 <= key2;
	 key2_r2 <= key2_r1;
	 key3_r1 <= key3;
	 key3_r2 <= key3_r1;
	 end
end
endmodule 