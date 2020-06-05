module PRESS_SPACE_POS(bottom_y,block,status,pos_x,block_exist,clk,rst,cal_bottom_en,finish_cal_bottom);
input [239:0] block_exist;
input [2:0]block;
input [1:0]status;
input [4:0]pos_x;
output reg [4:0]bottom_y;
input rst,clk;
input cal_bottom_en;
output reg finish_cal_bottom;
reg [4:0] state;
reg [4:0] tmp_state;
reg [4:0] tmp_bottom_y;
reg tmp_finish_cal_bottom;
parameter [4:0] INIT = 5'b00000;
parameter [4:0] CHECKPOS1 = 5'b00001;
parameter [4:0] CHECKPOS2 = 5'b00010;
parameter [4:0] CHECKPOS3 = 5'b00011;
parameter [4:0] CHECKPOS4 = 5'b00100;
parameter [4:0] CHECKPOS5 = 5'b00101;
parameter [4:0] CHECKPOS6 = 5'b00110;
parameter [4:0] CHECKPOS7 = 5'b00111;
parameter [4:0] CHECKPOS8 = 5'b01000;
parameter [4:0] CHECKPOS9 = 5'b01001;
parameter [4:0] CHECKPOS10 = 5'b01010;
parameter [4:0] CHECKPOS11 = 5'b01011;
parameter [4:0] CHECKPOS12 = 5'b01100;
parameter [4:0] CHECKPOS13 = 5'b01101;
parameter [4:0] CHECKPOS14 = 5'b01110;
parameter [4:0] CHECKPOS15 = 5'b01111;
parameter [4:0] CHECKPOS16 = 5'b10000;
parameter [4:0] CHECKPOS17 = 5'b10001;
parameter [4:0] CHECKPOS18 = 5'b10010;
parameter [4:0] CHECKPOS19 = 5'b10011;
parameter [4:0] CHECKPOS20 = 5'b10100;
parameter [4:0] CAL_PRESS_SPACE_POS_FINISH = 5'b10101;

wire d_en,l_en,r_en;

judgeIFContinueShift j1(.left_en(l_en),.right_en(r_en),.down_en(d_en),.block(block),.status(status),.pos_x(pos_x),.pos_y(bottom_y),.block_exist(block_exist));
always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= INIT;
        bottom_y <= 0;
        finish_cal_bottom <= 0;
    end
    else begin
        state <= tmp_state;
        bottom_y <= tmp_bottom_y;
        finish_cal_bottom <= tmp_finish_cal_bottom;
    end
end
always@(*)begin
    tmp_state = state;
    tmp_bottom_y = bottom_y;
    tmp_finish_cal_bottom = finish_cal_bottom;
    case(state)
        INIT:begin
            tmp_state = (cal_bottom_en)?CHECKPOS20:INIT;
            tmp_bottom_y = (cal_bottom_en)?19:bottom_y;
            tmp_finish_cal_bottom = 0;
        end
        CHECKPOS20:begin
            tmp_state = (d_en == 1)?CHECKPOS19:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?18:bottom_y;
        end
        CHECKPOS19:begin
            tmp_state = (d_en == 1)?CHECKPOS18:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?17:bottom_y;
        end
        CHECKPOS18:begin
            tmp_state = (d_en == 1)?CHECKPOS17:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?16:bottom_y;
        end
        CHECKPOS17:begin
            tmp_state = (d_en == 1)?CHECKPOS16:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?15:bottom_y;
        end
        CHECKPOS16:begin
            tmp_state = (d_en == 1)?CHECKPOS15:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?14:bottom_y;
        end
        CHECKPOS15:begin
            tmp_state = (d_en == 1)?CHECKPOS14:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?13:bottom_y;
        end
        CHECKPOS14:begin
            tmp_state = (d_en == 1)?CHECKPOS13:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?12:bottom_y;
        end
        CHECKPOS13:begin
            tmp_state = (d_en == 1)?CHECKPOS12:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?11:bottom_y;
        end
        CHECKPOS12:begin
            tmp_state = (d_en == 1)?CHECKPOS11:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?10:bottom_y;
        end
        CHECKPOS11:begin
            tmp_state = (d_en == 1)?CHECKPOS10:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?9:bottom_y;
        end
        CHECKPOS10:begin
            tmp_state = (d_en == 1)?CHECKPOS9:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?8:bottom_y;
        end
        CHECKPOS9:begin
            tmp_state = (d_en == 1)?CHECKPOS8:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?7:bottom_y;
        end
        CHECKPOS8:begin
            tmp_state = (d_en == 1)?CHECKPOS7:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?6:bottom_y;
        end
        CHECKPOS7:begin
            tmp_state = (d_en == 1)?CHECKPOS6:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?5:bottom_y;
        end
        CHECKPOS6:begin
            tmp_state = (d_en == 1)?CHECKPOS5:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?4:bottom_y;
        end
        CHECKPOS5:begin
            tmp_state = (d_en == 1)?CHECKPOS4:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?3:bottom_y;
        end
        CHECKPOS4:begin
            tmp_state = (d_en == 1)?CHECKPOS3:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?2:bottom_y;
        end
        CHECKPOS3:begin
            tmp_state = (d_en == 1)?CHECKPOS2:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?1:bottom_y;
        end
        CHECKPOS2:begin
            tmp_state = (d_en == 1)?CHECKPOS1:CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = (d_en == 1)?0:bottom_y;
        end
        CHECKPOS1:begin
            tmp_state = CAL_PRESS_SPACE_POS_FINISH;
            tmp_bottom_y = bottom_y;
        end
        CAL_PRESS_SPACE_POS_FINISH:begin
            tmp_state = INIT;
            tmp_bottom_y = bottom_y;
            tmp_finish_cal_bottom = 1;
        end
    endcase
end
/*
judgeIFContinueShift j1(.left_en(l_en1),.right_en(r_en1),.down_en(d_en1),.block(block),.status(status),.pos_x(pos_x),.pos_y(0),.block_exist(block_exist));
judgeIFContinueShift j2(.left_en(l_en2),.right_en(r_en2),.down_en(d_en2),.block(block),.status(status),.pos_x(pos_x),.pos_y(1),.block_exist(block_exist));
judgeIFContinueShift j3(.left_en(l_en3),.right_en(r_en3),.down_en(d_en3),.block(block),.status(status),.pos_x(pos_x),.pos_y(2),.block_exist(block_exist));
judgeIFContinueShift j4(.left_en(l_en4),.right_en(r_en4),.down_en(d_en4),.block(block),.status(status),.pos_x(pos_x),.pos_y(3),.block_exist(block_exist));
judgeIFContinueShift j5(.left_en(l_en5),.right_en(r_en5),.down_en(d_en5),.block(block),.status(status),.pos_x(pos_x),.pos_y(4),.block_exist(block_exist));
judgeIFContinueShift j6(.left_en(l_en6),.right_en(r_en6),.down_en(d_en6),.block(block),.status(status),.pos_x(pos_x),.pos_y(5),.block_exist(block_exist));
judgeIFContinueShift j7(.left_en(l_en7),.right_en(r_en7),.down_en(d_en7),.block(block),.status(status),.pos_x(pos_x),.pos_y(6),.block_exist(block_exist));
judgeIFContinueShift j8(.left_en(l_en8),.right_en(r_en8),.down_en(d_en8),.block(block),.status(status),.pos_x(pos_x),.pos_y(7),.block_exist(block_exist));
judgeIFContinueShift j9(.left_en(l_en9),.right_en(r_en9),.down_en(d_en9),.block(block),.status(status),.pos_x(pos_x),.pos_y(8),.block_exist(block_exist));
judgeIFContinueShift j10(.left_en(l_en10),.right_en(r_en10),.down_en(d_en10),.block(block),.status(status),.pos_x(pos_x),.pos_y(9),.block_exist(block_exist));
judgeIFContinueShift j11(.left_en(l_en11),.right_en(r_en11),.down_en(d_en11),.block(block),.status(status),.pos_x(pos_x),.pos_y(10),.block_exist(block_exist));
judgeIFContinueShift j12(.left_en(l_en12),.right_en(r_en12),.down_en(d_en12),.block(block),.status(status),.pos_x(pos_x),.pos_y(11),.block_exist(block_exist));
judgeIFContinueShift j13(.left_en(l_en13),.right_en(r_en13),.down_en(d_en13),.block(block),.status(status),.pos_x(pos_x),.pos_y(12),.block_exist(block_exist));
judgeIFContinueShift j14(.left_en(l_en14),.right_en(r_en14),.down_en(d_en14),.block(block),.status(status),.pos_x(pos_x),.pos_y(13),.block_exist(block_exist));
judgeIFContinueShift j15(.left_en(l_en15),.right_en(r_en15),.down_en(d_en15),.block(block),.status(status),.pos_x(pos_x),.pos_y(14),.block_exist(block_exist));
judgeIFContinueShift j16(.left_en(l_en16),.right_en(r_en16),.down_en(d_en16),.block(block),.status(status),.pos_x(pos_x),.pos_y(15),.block_exist(block_exist));
judgeIFContinueShift j17(.left_en(l_en17),.right_en(r_en17),.down_en(d_en17),.block(block),.status(status),.pos_x(pos_x),.pos_y(16),.block_exist(block_exist));
judgeIFContinueShift j18(.left_en(l_en18),.right_en(r_en18),.down_en(d_en18),.block(block),.status(status),.pos_x(pos_x),.pos_y(17),.block_exist(block_exist));
judgeIFContinueShift j19(.left_en(l_en19),.right_en(r_en19),.down_en(d_en19),.block(block),.status(status),.pos_x(pos_x),.pos_y(18),.block_exist(block_exist));
judgeIFContinueShift j20(.left_en(l_en20),.right_en(r_en20),.down_en(d_en20),.block(block),.status(status),.pos_x(pos_x),.pos_y(19),.block_exist(block_exist));

assign bottom_y = (d_en20==0)?19:
                  (d_en19==0)?18:
                  (d_en18==0)?17:
                  (d_en17==0)?16:
                  (d_en16==0)?15:
                  (d_en15==0)?14:
                  (d_en14==0)?13:
                  (d_en13==0)?12:
                  (d_en12==0)?11:
                  (d_en11==0)?10:
                  (d_en10==0)?9:
                  (d_en9==0)?8:
                  (d_en8==0)?7:
                  (d_en7==0)?6:
                  (d_en6==0)?5:
                  (d_en5==0)?4:
                  (d_en4==0)?3:
                  (d_en3==0)?2:
                  (d_en2==0)?1:
                  (d_en1==0)?0:0;
*/
                  
endmodule