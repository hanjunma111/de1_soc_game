module fsm(
       input        clk50M,
		 input        rst_n,
		 input        flg1,
		 input        flg2,
		 input        flg3,
		 output [7:0] x,
		 output [8:0] y,
		 output       write_en,
		 output [2:0] color
);
parameter clear_s = 3'd0;//clear screen state
parameter game_s  = 3'd1;//play game state
parameter over_s  = 3'd2;//game over state

parameter right  = 1'b0;
parameter left   = 1'b1;
parameter down   = 1'b0;
parameter up     = 1'b1;

parameter x_step = 8'd1;
parameter y_step = 9'd2;
parameter brd_step = 8'd8;
reg [7:0] x_cnt,x_r;
reg [8:0] y_cnt,y_r;
reg [2:0] state;
reg       left_right;
reg       up_down;
reg [7:0] x_ball,x_brd;
reg [8:0] y_ball,y_brd;
reg       write_en_r;
reg [2:0] color_r;
reg [2:0] color_ball;//板和球的颜色，可通过flg3改变
reg [31:0] speed_cnt;//ball move speed counter
assign x        = x_r;
assign y        = y_r;
assign write_en = write_en_r;
assign color    = color_r;
always@(posedge clk50M or negedge rst_n)
begin
if(rst_n == 1'b0)
    begin
	 x_cnt <= 8'd0;
	 y_cnt <= 9'd0;
	 write_en_r <= 1'b0;
	 color_r    <= 3'b000;
	 color_ball <= 3'b100;
	 x_brd      <= 8'd120-8'd16;
	 y_brd      <= 9'd316;
	 x_ball     <= 8'd120-8'd2;
	 y_ball     <= 9'd312;
	 state      <= clear_s;
	 speed_cnt  <= 0;
    left_right <= right;
	 up_down    <= up;
	 end
else
    begin
	 x_cnt <= (x_cnt >= 8'd239)?8'd0:x_cnt+8'd1;
	 y_cnt <= (x_cnt >= 8'd239)?((y_cnt >= 9'd319)?9'd0:y_cnt+9'd1):y_cnt;
	 x_r   <= x_cnt;
	 y_r   <= y_cnt;
	 write_en_r <= 1'b1;
	 color_ball <= flg3?((color_ball >= 3'b110)?3'b000:color_ball+1'b1):color_ball;//不可为白色即3'b111.因为背景是白色
	 case(state)
	 clear_s:begin
	     color_r <= 3'b111;
		  if((x_cnt >= 8'd239) && (y_cnt >= 9'd319))
		      state <= game_s;
		  else
		      state <= state;
	 end
	 game_s:begin
	     if((x_cnt >= x_brd) && (x_cnt <= x_brd+8'd31) && (y_cnt >= y_brd) && (y_cnt <= y_brd+9'd3))
		      color_r <= color_ball;
		  else if((x_cnt >= x_ball) && (x_cnt <= x_ball+8'd3) && (y_cnt >= y_ball) && (y_cnt <= y_ball+9'd3))
		      color_r <= color_ball;
		  else
		      color_r <= 3'b111;
		  speed_cnt <= (speed_cnt >= 2500000)?0:speed_cnt+1;
		  case(left_right)
		  left:begin
		      if(speed_cnt >= 2500000)
				    begin
					 if(x_ball >= 8'd0+x_step)
					     x_ball <= x_ball-x_step;
					 else
					     left_right <= right;
					 end
				else
				    x_ball <= x_ball;
		  end
		  right:begin
		      if(speed_cnt >= 2500000)
				    begin
					 if(x_ball <= 8'd236-x_step)
					     x_ball <= x_ball+x_step;
					 else
					     left_right <= left;
					 end
				else
				    begin
					 x_ball <= x_ball;
					 end
		  end
		  endcase
		  case(up_down)
		  up:begin
		      if(speed_cnt >= 2500000)
				    begin
					 if(y_ball >= 9'd0+y_step)
					     y_ball <= y_ball-y_step;
					 else
					     up_down <= down;
					 end
				else
				    y_ball <= y_ball;
		  end
		  down:begin
		      if(speed_cnt >= 2500000)
				    begin
					 if(y_ball <= 9'd312-y_step)
					     y_ball <= y_ball+y_step;
					 else if(x_ball >= x_brd && x_ball <= x_brd+8'd31)
					     up_down <= up;
					 else
					     state <= over_s;
					 end
				else
				    y_ball <= y_ball;
		  end
		  endcase
		  x_brd <= flg1?((x_brd <= 8'd239-8'd31-brd_step)?x_brd+brd_step:x_brd):(flg2?((x_brd >= 8'd0+brd_step)?x_brd-brd_step:x_brd):x_brd);
	 end
	 over_s:begin
	     color_r <= 3'b001;
	 end
	 default:;
	 endcase
	 end
end

endmodule 