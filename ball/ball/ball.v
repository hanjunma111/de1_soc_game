module ball(
       input       clk50M,
		 input [3:0] KEY,
		 input [9:0] SW,
		 // LT24 Interface
		 output             LT24Wr_n,
		 output             LT24Rd_n,
		 output             LT24CS_n,
		 output             LT24RS,
		 output             LT24Reset_n,
		 output [     15:0] LT24Data,
		 output             LT24LCDOn
		 
);
wire k1_w0,k2_w0,k3_w0;
chuchan u_chuchan_0(
       .clk50M(clk50M),
		 .rst_n(KEY[0]),
		 .k1(KEY[1]),
		 .k2(KEY[2]),
		 .k3(KEY[3]),
		 .k4(),
		 .k1_o(k1_w0),
		 .k2_o(k2_w0),
		 .k3_o(k3_w0),
		 .k4_o()
		 );
wire flg1,flg2,flg3;
down_edge_det u_down_edge_det_0
                    (.clk(clk50M),
                     .rst_n(KEY[0]),
							.key0(k1_w0),
							.key1(k2_w0),
							.key2(k3_w0),
							.key3(),
							.flag0(flg1),
							.flag1(flg2),
							.flag2(flg3),
							.flag3()
							);
							
fsm u_fsm_0(
       .clk50M(clk50M),
		 .rst_n(KEY[0]),
		 .flg1(flg1),
		 .flg2(flg2),
		 .flg3(flg3),
		 .x(x),
		 .y(y),
		 .write_en(write_en),
		 .color(color)
);

wire [7:0] x;
wire [8:0] y;
wire       write_en;
wire [2:0] color;
wire [16:0] ram_wraddr_w;
wire        ram_wren_w;
wire [2:0]  ram_data_w;
ram_wr u_ram_wr_0(         //decode x,y to address
       .clk50M(clk50M),
		 .rst_n(KEY[0]),
		 .x(x),
		 .y(y),
		 .write_en(write_en),
		 .color(color),
		 .ram_wren(ram_wren_w),
		 .ram_wraddr(ram_wraddr_w),
		 .ram_data(ram_data_w)
);
disp_dpram u_disp_dpram_0 (
	.address_a(ram_wraddr_w),
	.address_b(ram_rdaddr_w),
	.clock(clk50M),
	.data_a(ram_data_w),
	.data_b(),
	.rden_a(1'b0),
	.rden_b(1'b1),
	.wren_a(ram_wren_w),
	.wren_b(1'b0),
	.q_a(),
	.q_b(ram_q_b_w)
	);
wire [16:0] ram_rdaddr_w;
wire [2:0]  ram_q_b_w;
ram2lcd u_ram2lcd_0(                  //this module read ram and write lcd_ctrl module
       .clk50M(clk50M),
		 .rst_n(~resetApp),
		 .pixelReady(pixelReady),  //lcd controller pixelReady
		 .ram_rdaddr(ram_rdaddr_w),  //dpram's read address
		 .xAddr(xAddr),       //lcd controller xADDR
		 .yAddr(yAddr)        //lcd controller yADDR
);
// LT24ctrl Variables
wire [ 7:0]  xAddr;
wire [ 8:0]  yAddr;
wire  [15:0] pixelData;
wire        pixelReady;
wire 	      resetApp;
assign pixelData = {{5{ram_q_b_w[2]}},{6{ram_q_b_w[1]}},{5{ram_q_b_w[0]}}};
//assign pixelData = 16'hF800;
LT24Display  #(
    .WIDTH       (240  ),
    .HEIGHT      (320 ),
    .CLOCK_FREQ  (50000000   )
) Display (
    .clock       (clk50M      ),
    .globalReset (~KEY[0]),
    .resetApp    (resetApp   ),
    .xAddr       (xAddr      ),
    .yAddr       (yAddr      ),
    .pixelData   (pixelData  ),
    .pixelWrite  (1'b1       ),
    .pixelReady  (pixelReady ),
    .pixelRawMode(1'b0       ),
    .cmdData     (8'b0       ),
    .cmdWrite    (1'b0       ),
    .cmdDone     (1'b0       ),
    .cmdReady    (           ),
    .LT24Wr_n    (LT24Wr_n   ),
    .LT24Rd_n    (LT24Rd_n   ),
    .LT24CS_n    (LT24CS_n   ),
    .LT24RS      (LT24RS     ),
    .LT24Reset_n (LT24Reset_n),
    .LT24Data    (LT24Data   ),
    .LT24LCDOn   (LT24LCDOn  )
);	
endmodule 