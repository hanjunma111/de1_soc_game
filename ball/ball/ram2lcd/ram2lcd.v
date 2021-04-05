module ram2lcd(                  //this module read ram and write lcd_ctrl module
       input clk50M,
		 input rst_n,
		 input         pixelReady,  //lcd controller pixelReady
		 output [16:0] ram_rdaddr,  //dpram's read address
		 output [7:0]  xAddr,       //lcd controller xADDR
		 output [8:0]  yAddr        //lcd controller yADDR
);
reg [7:0]  x_cnt;
reg [8:0]  y_cnt;
reg [16:0] ram_rdaddr_r;
reg [7:0]  xAddr_r,xAddr_r0;
reg [8:0]  yAddr_r,yAddr_r0;
assign ram_rdaddr = ram_rdaddr_r;//(ram_rdaddr_r <= 17'd76798)?ram_rdaddr_r+17'd1:17'd0;
assign xAddr      = xAddr_r;
assign yAddr      = yAddr_r;
always@(posedge clk50M or negedge rst_n)
begin
if(rst_n == 1'b0)
    begin
	 x_cnt        <= 8'd0;
	 y_cnt        <= 9'd0;
	 ram_rdaddr_r <= 17'd0;
	 xAddr_r      <= 8'd0;
	 yAddr_r      <= 9'd0;
	 xAddr_r0     <= 8'd0;
	 yAddr_r0     <= 9'd0;
	 end
else
    begin
	 ram_rdaddr_r <= y_cnt*240+x_cnt;
	 xAddr_r0     <= x_cnt;
	 xAddr_r      <= xAddr_r0;
	 yAddr_r0     <= y_cnt;
	 yAddr_r      <= yAddr_r0;
	 if(pixelReady)
	     begin
		  x_cnt <= (x_cnt >= 8'd239)?8'd0:x_cnt+8'd1;
		  y_cnt <= (x_cnt >= 8'd239)?((y_cnt >= 9'd319)?9'd0:y_cnt+9'd1):y_cnt;
		  end
	 else
	     begin
		  x_cnt <= x_cnt;
		  y_cnt <= y_cnt;
		  end
	 end
end
endmodule 