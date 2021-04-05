/*
chuchan u_chuchan_0(
       .clk50M(),
		 .rst_n(),
		 .k1(),
		 .k2(),
		 .k3(),
		 .k4(),
		 .k1_o(),
		 .k2_o(),
		 .k3_o(),
		 .k4_o()
		 );
*/

module chuchan(clk50M,rst_n,k1,k2,k3,k4,k1_o,k2_o,k3_o,k4_o);
input clk50M,rst_n,k1,k2,k3,k4;
output k1_o,k2_o,k3_o,k4_o;
reg [19:0] cnt1,cnt2,cnt3,cnt4;//debounce counter
reg k1_o_r,k2_o_r,k3_o_r,k4_o_r;
assign k1_o=k1_o_r;
assign k2_o=k2_o_r;
assign k3_o=k3_o_r;
assign k4_o=k4_o_r;
always@(posedge clk50M or negedge rst_n)
begin
if(!rst_n)
begin
cnt1<=20'd0;
cnt2<=20'd0;
cnt3<=20'd0;
cnt4<=20'd0;
k1_o_r<=1'b1;
k2_o_r<=1'b1;
k3_o_r<=1'b1;
k4_o_r<=1'b1;
end
else
begin

if(k1==1'b0)
begin
if(cnt1<=20'd499999)
begin
cnt1<=cnt1+20'd1;
end
else
begin
cnt1<=cnt1;
k1_o_r<=1'b0;
end
end
else
begin
cnt1<=20'd0;
k1_o_r<=1'b1;
end

if(k2==1'b0)
begin
if(cnt2<=20'd499999)
begin
cnt2<=cnt2+20'd1;
end
else
begin
cnt2<=cnt2;
k2_o_r<=1'b0;
end
end
else
begin
cnt2<=20'd0;
k2_o_r<=1'b1;
end

if(k3==1'b0)
begin
if(cnt3<=20'd499999)
begin
cnt3<=cnt3+20'd1;
end
else
begin
cnt3<=cnt3;
k3_o_r<=1'b0;
end
end
else
begin
cnt3<=20'd0;
k3_o_r<=1'b1;
end

if(k4==1'b0)
begin
if(cnt4<=20'd499999)
begin
cnt4<=cnt4+20'd1;
end
else
begin
cnt4<=cnt4;
k4_o_r<=1'b0;
end
end
else
begin
cnt4<=20'd0;
k4_o_r<=1'b1;
end

end
end
endmodule 