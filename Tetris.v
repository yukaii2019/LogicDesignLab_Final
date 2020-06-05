`timescale 1ns / 1ps
`include "C:\Users\ACER\Desktop\logic_design_lab\FINAL\FinalProjectRepo\global.v"
module Tetris(vgaRed,vgaGreen,vgaBlue,hsync,vsync,clk,rst,generate_block,led,PS2_DATA,PS2_CLK,gameStart);
input clk;
input rst;
input gameStart;
input generate_block;
output [3:0] vgaRed;
output [3:0] vgaGreen;
output [3:0] vgaBlue;
output hsync;
output vsync;

output [9:0]led;  //debug
wire clk_25MHz;
wire clk_22;
wire clkBlockDown;
wire clkBlockDown_fast;
wire clkBlockDown_slow;
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480

// input btn_L,btn_R,btn_U,btn_D;
// wire db_btn_L,db_btn_R,db_btn_U,db_btn_D;
// wire op_btn_L,op_btn_R,op_btn_U,op_btn_D;



// debounce db0 (.pb_debounced(db_btn_L),.pb(btn_L),.clk(clk));
// debounce db1 (.pb_debounced(db_btn_R),.pb(btn_R),.clk(clk));
// debounce db2 (.pb_debounced(db_btn_U),.pb(btn_U),.clk(clk));
// debounce db3 (.pb_debounced(db_btn_D),.pb(btn_D),.clk(clk));
// one_pulse op0 (.push_onepulse(op_btn_L),.rst(rst),.clk(clk),.push_debounced(db_btn_L));
// one_pulse op1 (.push_onepulse(op_btn_R),.rst(rst),.clk(clk),.push_debounced(db_btn_R));
// one_pulse op2 (.push_onepulse(op_btn_U),.rst(rst),.clk(clk),.push_debounced(db_btn_U));
// one_pulse op3 (.push_onepulse(op_btn_D),.rst(rst),.clk(clk),.push_debounced(db_btn_D));


inout  PS2_DATA;
inout  PS2_CLK;

wire space,op_space;
wire right,op_right;
wire left,op_left;
wire up,op_up;
wire down,op_down;
wire shift,op_shift;

one_pulse op0 (.push_onepulse(op_space),.rst(rst),.clk(clk),.push_debounced(space));
one_pulse op1 (.push_onepulse(op_right),.rst(rst),.clk(clk),.push_debounced(right));
one_pulse op2 (.push_onepulse(op_left),.rst(rst),.clk(clk),.push_debounced(left));
one_pulse op3 (.push_onepulse(op_up),.rst(rst),.clk(clk),.push_debounced(up));
one_pulse op4 (.push_onepulse(op_shift),.rst(rst),.clk(clk),.push_debounced(shift));
//one_pulse op4 (.push_onepulse(op_down),.rst(rst),.clk(clk),.push_debounced(down));


keyboardSignal ks (.shift(shift),.space(space),.right(right),.left(left),.up(up),.down(down),.clk(clk),.rst(rst),.PS2_DATA(PS2_DATA),.PS2_CLK(PS2_CLK));


wire [2879:0] color;
wire write_en;
wire [11:0] w_color;
wire [7:0]address;
wire [239:0]block_exist;
wire [11:0]read_addr_color;
wire [7:0]read_addr;

wire [1499:0]foresee;
wire write_foresee_en;
wire [4:0]reset_foresee;

wire reset_store;
wire write_store_en;
wire [299:0]store;
wire [9:0]score;
assign clkBlockDown =(down)?clkBlockDown_fast:clkBlockDown_slow;

clock_divisor clk_wiz_0_inst(.clk(clk),.clk1(clk_25MHz),.clk22(clk_22),.clkBlockDown_fast(clkBlockDown_fast),.clkBlockDown_slow(clkBlockDown_slow));
pixel_gen pg (.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.h_cnt(h_cnt),.v_cnt(v_cnt),.valid(valid),.color(color),.foresee(foresee),.store(store));
vga_controller vga_inst(.pclk(clk_25MHz),.reset(rst),.hsync(hsync),.vsync(vsync),.valid(valid),.h_cnt(h_cnt),.v_cnt(v_cnt));
BackGroundMemory bm (.read_addr_color(read_addr_color),.color(color),.clk(clk),.rst(rst),.write_en(write_en),.address(address),.w_color(w_color),
                     .block_exist(block_exist),.read_address(read_addr),.foresee(foresee),.write_foresee_en(write_foresee_en),.reset_foresee(reset_foresee),.store(store),
                     .reset_store(reset_store),.write_store_en(write_store_en));
putBlock pb (.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.generate_block(generate_block),
             .rst(rst),.clk(clk),.rotate_right(op_up),.rotate_left(op_down),
             .shift_left(op_left),.shift_right(op_right),.clkBlockDown(clkBlockDown),.led(led),
             .read_addr_color(read_addr_color),.read_addr(read_addr),.space(op_space),.gameStart(gameStart),.keyboard_shift(op_shift),
             .write_foresee_en(write_foresee_en),.reset_foresee(reset_foresee),.reset_store(reset_store),.write_store_en(write_store_en)
             ,.score(score));
endmodule

module putBlock(read_addr,write_en,address,w_color,block_exist,generate_block,rst,clk,space,rotate_right,rotate_left,shift_left,shift_right,clkBlockDown,led,read_addr_color,gameStart,write_foresee_en,reset_foresee,keyboard_shift,reset_store,write_store_en,score);
input generate_block;
input rst;
input clk;
input rotate_right,rotate_left;
input shift_right,shift_left;
input clkBlockDown;
input [11:0]read_addr_color;
input space;
input keyboard_shift;
input gameStart;
output reg write_foresee_en;
output reg [4:0]reset_foresee;
output reg write_store_en;
output reg reset_store;

output reg write_en;
output reg [7:0]address;
output reg [11:0]w_color;
output reg[239:0]block_exist;
output reg [7:0]read_addr;

output reg [9:0]score;

wire [11:0]last_w_color; // redundant
reg [3:0]state;
reg [2:0]block;
reg [1:0]status;
reg [4:0]pos_x,pos_y;
reg [4:0]last_pos_x,last_pos_y;
reg start_write;
reg [1:0]new_status;


reg [3:0]tmp_state;
reg [2:0]tmp_block;
reg [1:0]tmp_status;
reg [4:0]tmp_pos_x,tmp_pos_y;
reg [4:0]tmp_last_pos_x,tmp_last_pos_y;
reg tmp_start_write;
reg [1:0]tmp_new_status;

wire [7:0] color_pos1;
wire [7:0] color_pos2;
wire [7:0] color_pos3;
wire [7:0] color_pos4;

wire [7:0] last_pos1;
wire [7:0] last_pos2;
wire [7:0] last_pos3;
wire [7:0] last_pos4;



wire one_pulse_BlockDown;

wire left_en,right_en,down_en;

wire [15:0] rondom_num;
wire [11:0] block_color;



reg write_complete;                   
reg [8:0]write_state;

reg [239:0]tmp_block_exist;
reg [11:0] tmp_w_color;
reg [7:0]tmp_address;
reg [3:0]tmp_write_state;
reg tmp_write_en;
reg tmp_write_complete;


wire [4:0]er1,er2,er3,er4;
wire check_finish;
reg eraseROW_en;
reg tmp_eraseROW_en;

output [9:0]led; //debug

reg [2:0] foreseeBlock1;
reg [2:0] foreseeBlock2;
reg [2:0] foreseeBlock3;
reg [2:0] foreseeBlock4;
reg [2:0] foreseeBlock5;

reg [2:0] tmp_foreseeBlock1;
reg [2:0] tmp_foreseeBlock2;
reg [2:0] tmp_foreseeBlock3;
reg [2:0] tmp_foreseeBlock4;
reg [2:0] tmp_foreseeBlock5;

reg [2:0] foreseeBlock1_status;
reg [2:0] foreseeBlock2_status;
reg [2:0] foreseeBlock3_status;
reg [2:0] foreseeBlock4_status;
reg [2:0] foreseeBlock5_status;

reg [2:0] tmp_foreseeBlock1_status;
reg [2:0] tmp_foreseeBlock2_status;
reg [2:0] tmp_foreseeBlock3_status;
reg [2:0] tmp_foreseeBlock4_status;
reg [2:0] tmp_foreseeBlock5_status;

reg start_write_foreseeBlock;
reg tmp_start_write_foreseeBlock;

parameter [8:0] WAIT_WRITE = 9'b000000000;
parameter [8:0] WRITE_POS1 = 9'b000000001;
parameter [8:0] WRITE_POS2 = 9'b000000010;
parameter [8:0] WRITE_POS3 = 9'b000000011;
parameter [8:0] WRITE_POS4 = 9'b000000100;
parameter [8:0] WRITE_COMPLETE = 9'b000000101;
parameter [8:0] SET_BLOCK_EXIST1 = 9'b000000110;
//parameter [3:0] SET_BLOCK_EXIST2 = 4'b0111;

parameter [8:0] TEST_STATE_1 = 9'b000001000;
parameter [8:0] TEST_STATE_2 = 9'b000001001;
parameter [8:0] TEST_STATE_3 = 9'b000001010;
parameter [8:0] TEST_STATE_4 = 9'b000001011;

parameter [8:0] ERASE_ROW1 = 9'b00000_1100;
parameter [8:0] ERASE_ROW2 = 9'b00000_1101;
parameter [8:0] ERASE_ROW3 = 9'b00000_1110;
parameter [8:0] ERASE_ROW4 = 9'b00000_1111;

parameter [8:0] DOWN_COMPLETE = 9'b110001100;
parameter [8:0] SETTING_BLOCKEXIST = 9'b110001101;
parameter [8:0] CHECK_COMPLETE = 9'b110001110;
parameter [8:0] SETTING_READ_ADDRESS = 9'b110001111;
parameter [8:0] DOWN_POS = 9'b110010000;
parameter [8:0] ERASE_PREVIOUS_FORESEE = 9'b110010001;

parameter [8:0] WRITE_FORESEE_BLOCK_POS1 = 9'b110010010;
parameter [8:0] WRITE_FORESEE_BLOCK_POS2 = 9'b110010011;
parameter [8:0] WRITE_FORESEE_BLOCK_POS3 = 9'b110010100;
parameter [8:0] WRITE_FORESEE_BLOCK_POS4 = 9'b110010101;
parameter [8:0] SETTING_WRITE_FORESEE_BLOCK = 9'b110010110;
parameter [8:0] FORESEE_BLOCK_WRITE_COMPLETE = 9'b110010111;

parameter [8:0] ERASE_NOW_DOWN_BLOCK = 9'b110011000;
parameter [8:0] WRITESTORE = 9'b110011001;
parameter [8:0] WRITESTORE_POS1 = 9'b110011010;
parameter [8:0] WRITESTORE_POS2 = 9'b110011011;
parameter [8:0] WRITESTORE_POS3 = 9'b110011100;
parameter [8:0] WRITESTORE_POS4 = 9'b110011101;
parameter [8:0] WRITESTORE_COMPLETE = 9'b110011110;

parameter [8:0] ERASE_ROW5 = 9'b110011111;

wire exceed1,exceed2; // redundant
wire [4:0]init_pos_x,init_pos_y;
wire [4:0]init_pos_x_last,init_pos_y_last; //redundant
shape s_now  (.init_pos_x(init_pos_x),.init_pos_y(init_pos_y),.exceed(exceed1),.w_color(block_color),.color_pos1(color_pos1),.color_pos2(color_pos2),.color_pos3(color_pos3),
              .color_pos4(color_pos4),.block(block),.status(new_status),.pos_x(pos_x),.pos_y(pos_y));
shape s_last (.init_pos_x(init_pos_x_last),.init_pos_y(init_pos_y_last),.exceed(exceed2),.w_color(last_w_color),.color_pos1(last_pos1),.color_pos2(last_pos2),.color_pos3(last_pos3),
              .color_pos4(last_pos4),.block(block),.status(status),.pos_x(last_pos_x),.pos_y(last_pos_y));

// wire [11:0]foresee_c1,foresee_c2,foresee_c3,foresee_c4,foresee_c5;
// wire [7:0] block1_pos_1,block1_pos_2,block1_pos_3,block1_pos_4;
// wire [7:0] block2_pos_1,block2_pos_2,block2_pos_3,block2_pos_4;
// wire [7:0] block3_pos_1,block3_pos_2,block3_pos_3,block3_pos_4;
// wire [7:0] block4_pos_1,block4_pos_2,block4_pos_3,block4_pos_4;
// wire [7:0] block5_pos_1,block5_pos_2,block5_pos_3,block5_pos_4;
wire [11:0] foresee_color;
wire [7:0] foresee_block_pos_1,foresee_block_pos_2,foresee_block_pos_3,foresee_block_pos_4;
reg [2:0]now_writing_foresee_block;
reg [1:0]now_writing_foresee_block_status;
reg [4:0]now_writing_foresee_pos_x,now_writing_foresee_pos_y;
reg [2:0]write_foreseeCount;
shape_for_foresee foresee1(.w_color(foresee_color),.color_pos1(foresee_block_pos_1),.color_pos2(foresee_block_pos_2),.color_pos3(foresee_block_pos_3),
                           .color_pos4(foresee_block_pos_4),.block(now_writing_foresee_block),.status(now_writing_foresee_block_status),
                           .pos_x(now_writing_foresee_pos_x),.pos_y(now_writing_foresee_pos_y));

wire [11:0] store_color;
wire [7:0] store_block_pos1,store_block_pos2,store_block_pos3,store_block_pos4;
reg [2:0] now_writing_store_block;
reg [1:0]now_writing_store_block_status;

reg start_store_block;
reg tmp_start_store_block;

reg [2:0] tmp_now_writing_store_block;
reg [1:0] tmp_now_writing_store_block_status;

reg store_block_flg;
reg tmp_store_block_flg;
reg not_first_time_store_block;
reg tmp_not_first_time_store_block;

reg [2:0]last_store_block;
reg [1:0]tmp_last_store_block;
reg [2:0]last_store_block_status;
reg [1:0]tmp_last_store_block_status;

reg back_from_store_state;
reg tmp_back_from_store_state;
shape_for_foresee store(.w_color(store_color),.color_pos1(store_block_pos1),.color_pos2(store_block_pos2),.color_pos3(store_block_pos3),
                           .color_pos4(store_block_pos4),.block(now_writing_store_block),.status(now_writing_store_block_status),
                           .pos_x(2),.pos_y(2));

// shape_for_foresee foresee2(.w_color(foresee_c2),.color_pos1(block2_pos_1),.color_pos2(block2_pos_2),.color_pos3(block2_pos_3),
//                            .color_pos4(block2_pos_4),.block(foreseeBlock2),.status(foreseeBlock2_status),.pos_x(2),.pos_y(7));
// shape_for_foresee foresee3(.w_color(foresee_c3),.color_pos1(block3_pos_1),.color_pos2(block3_pos_2),.color_pos3(block3_pos_3),
//                            .color_pos4(block3_pos_4),.block(foreseeBlock3),.status(foreseeBlock3_status),.pos_x(2),.pos_y(12));
// shape_for_foresee foresee4(.w_color(foresee_c4),.color_pos1(block4_pos_1),.color_pos2(block4_pos_2),.color_pos3(block4_pos_3),
//                            .color_pos4(block4_pos_4),.block(foreseeBlock4),.status(foreseeBlock4_status),.pos_x(2),.pos_y(17));
// shape_for_foresee foresee5(.w_color(foresee_c5),.color_pos1(block5_pos_1),.color_pos2(block5_pos_2),.color_pos3(block5_pos_3),
//                            .color_pos4(block5_pos_4),.block(foreseeBlock5),.status(foreseeBlock5_status),.pos_x(2),.pos_y(22));
one_pulse op1 (.push_onepulse(one_pulse_BlockDown),.rst(rst),.clk(clk),.push_debounced(clkBlockDown));

judgeIFContinueShift jich (.left_en(left_en),.right_en(right_en),.down_en(down_en),.block(block),.status(status),
                           .pos_x(pos_x),.pos_y(pos_y),.block_exist(block_exist));
                           
random_num_generator rng (.q(rondom_num),.clk(clk),.rst(rst));

eraseROW er(.row1(er1),.row2(er2),.row3(er3),.row4(er4),.check_finish(check_finish),.eraseROW_en(eraseROW_en),.block_exist(block_exist),.clk(clk),.rst(rst));

assign led[9:5] = er1;
assign led [4:0] = er2;
wire [239:0]b1,b2,b3,b4;
wire CALfinish;
reg blockDownCAL_en;
reg tmp_blockDownCAL_en;
blockDownCAL bdc (.b1(b1),.b2(b2),.b3(b3),.b4(b4),.CALfinish(CALfinish),.clk(clk),.rst(rst),.row1(er1),.row2(er2),.row3(er3),.row4(er4),.blockDownCAL_en(blockDownCAL_en));

reg start_eraseROW;
reg tmp_start_eraseROW;
reg [25:0]erase_row_count;


wire [7:0]p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39;

erased_row_block_pos erbp(.p0(p0),.p1(p1),.p2(p2),.p3(p3),.p4(p4),.p5(p5),.p6(p6),.p7(p7),.p8(p8),.p9(p9),.p10(p10),.p11(p11),.p12(p12),
                          .p13(p13),.p14(p14),.p15(p15),.p16(p16),.p17(p17),.p18(p18),.p19(p19),.p20(p20),.p21(p21),.p22(p22),.p23(p23),
                          .p24(p24),.p25(p25),.p26(p26),.p27(p27),.p28(p28),.p29(p29),.p30(p30),.p31(p31),.p32(p32),.p33(p33),.p34(p34),
                          .p35(p35),.p36(p36),.p37(p37),.p38(p38),.p39(p39),.row1(er1),.row2(er2),.row3(er3),.row4(er4));

reg [7:0]downCount;
wire [7:0]down_addr;
assign down_addr = read_addr-(b1[read_addr]+b2[read_addr]+b3[read_addr]+b4[read_addr])*10;

wire cal_rotate_complete;
wire [7:0]rotate_addr;
wire [1:0]rotate_status;
reg cal_rotate_en;
reg tmp_cal_rotate_en;
reg left_or_right;
reg tmp_left_or_right;

reg [239:0]block_exist_exclude;  //exclude the rotate block
reg [239:0]tmp_block_exist_exclude;
rotate rt (.cal_rotate_complete(cal_rotate_complete),.final_addr(rotate_addr),.final_status(rotate_status),.block(block),.status(status),
           .left_OR_right(left_or_right),.block_exist(block_exist_exclude),.clk(clk),.rst(rst),.pos_x(pos_x),.pos_y(pos_y),.cal_rotate_en(cal_rotate_en));

wire [4:0]bottom_y;

reg space_is_press;
reg tmp_space_is_press;
PRESS_SPACE_POS psp (.bottom_y(bottom_y),.block(block),.status(status),.pos_x(pos_x),.pos_y(pos_y),.block_exist(block_exist_exclude));
always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= `WAIT_GAME_START;
        block <= 0;
        status <= 0;
        pos_x <= 0;
        pos_y <= 0;
        start_write <=0;
        last_pos_x <=0;
        last_pos_y <=0;
        eraseROW_en <= 0;
        blockDownCAL_en <=0;
        start_eraseROW <= 0;
        cal_rotate_en <= 0;
        left_or_right <= 0;
        new_status <= 0; 
        block_exist_exclude <= 0;
        space_is_press <=0;

        foreseeBlock1 <= 0;
        foreseeBlock2 <= 0;
        foreseeBlock3 <= 0;
        foreseeBlock4 <= 0;
        foreseeBlock5 <= 0;

        foreseeBlock1_status <= 0;
        foreseeBlock2_status <= 0;
        foreseeBlock3_status <= 0;
        foreseeBlock4_status <= 0;
        foreseeBlock5_status <= 0;
        start_write_foreseeBlock <= 0;
        start_store_block <= 0;
        now_writing_store_block_status <= 0;
        now_writing_store_block <= 0;
        store_block_flg <= 0;
        not_first_time_store_block <= 0;
        last_store_block <= 0;
        last_store_block_status <= 0;
        back_from_store_state <= 0;
    end
    else begin
        state <= tmp_state;
        block <= tmp_block;
        status <= tmp_status;
        pos_x <= tmp_pos_x;
        pos_y <= tmp_pos_y;
        start_write <= tmp_start_write;
        last_pos_x <= tmp_last_pos_x;
        last_pos_y <= tmp_last_pos_y;
        eraseROW_en <= tmp_eraseROW_en;
        blockDownCAL_en <= tmp_blockDownCAL_en;
        start_eraseROW <= tmp_start_eraseROW;
        cal_rotate_en <= tmp_cal_rotate_en;
        left_or_right <= tmp_left_or_right;
        new_status <= tmp_new_status;
        block_exist_exclude <=tmp_block_exist_exclude;
        space_is_press <= tmp_space_is_press;

        foreseeBlock1 <= tmp_foreseeBlock1;
        foreseeBlock2 <= tmp_foreseeBlock2;
        foreseeBlock3 <= tmp_foreseeBlock3;
        foreseeBlock4 <= tmp_foreseeBlock4;
        foreseeBlock5 <= tmp_foreseeBlock5;

        foreseeBlock1_status <= tmp_foreseeBlock1_status;
        foreseeBlock2_status <= tmp_foreseeBlock2_status;
        foreseeBlock3_status <= tmp_foreseeBlock3_status;
        foreseeBlock4_status <= tmp_foreseeBlock4_status;
        foreseeBlock5_status <= tmp_foreseeBlock5_status;

        start_write_foreseeBlock <= tmp_start_write_foreseeBlock;
        start_store_block <= tmp_start_store_block;

        now_writing_store_block_status <= tmp_now_writing_store_block_status;
        now_writing_store_block <= tmp_now_writing_store_block;

        store_block_flg <= tmp_store_block_flg;
        not_first_time_store_block <= tmp_not_first_time_store_block;

        last_store_block <= tmp_last_store_block;
        last_store_block_status <= tmp_last_store_block_status; 
        back_from_store_state <= tmp_back_from_store_state;
    end
end

always@(*)begin
    tmp_state = state;
    tmp_block = block;
    tmp_status = status;
    tmp_pos_x = pos_x;
    tmp_pos_y = pos_y;
    tmp_start_write = start_write;
    tmp_last_pos_x = last_pos_x;
    tmp_last_pos_y = last_pos_y;
    tmp_eraseROW_en = eraseROW_en;
    tmp_blockDownCAL_en = blockDownCAL_en;
    tmp_start_eraseROW = start_eraseROW;
    tmp_cal_rotate_en = cal_rotate_en;
    tmp_left_or_right = left_or_right;
    tmp_new_status = new_status;
    tmp_block_exist_exclude = block_exist_exclude;
    tmp_space_is_press = space_is_press;
    
    tmp_foreseeBlock1 = foreseeBlock1;
    tmp_foreseeBlock2 = foreseeBlock2;
    tmp_foreseeBlock3 = foreseeBlock3;
    tmp_foreseeBlock4 = foreseeBlock4;
    tmp_foreseeBlock5 = foreseeBlock5;

    tmp_foreseeBlock1_status = foreseeBlock1_status;
    tmp_foreseeBlock2_status = foreseeBlock2_status;
    tmp_foreseeBlock3_status = foreseeBlock3_status;
    tmp_foreseeBlock4_status = foreseeBlock4_status;
    tmp_foreseeBlock5_status = foreseeBlock5_status;

    tmp_start_write_foreseeBlock = start_write_foreseeBlock;
    tmp_start_store_block = start_store_block;

    tmp_now_writing_store_block_status = now_writing_store_block_status;
    tmp_now_writing_store_block = now_writing_store_block;
    tmp_store_block_flg = store_block_flg;

    tmp_not_first_time_store_block = not_first_time_store_block;

    tmp_last_store_block = last_store_block;
    tmp_last_store_block_status = last_store_block_status;

    tmp_back_from_store_state = back_from_store_state;

    case(state)
        `WAIT_GAME_START:begin
            tmp_state = (gameStart)?`WAIT_BLOCK_EN:`WAIT_GAME_START;
            tmp_foreseeBlock1 = (gameStart)?(rondom_num+ 0)%7:foreseeBlock1;
            tmp_foreseeBlock2 = (gameStart)?(rondom_num+10)%7:foreseeBlock2;
            tmp_foreseeBlock3 = (gameStart)?(rondom_num+20)%7:foreseeBlock3;
            tmp_foreseeBlock4 = (gameStart)?(rondom_num+30)%7:foreseeBlock4;
            tmp_foreseeBlock5 = (gameStart)?(rondom_num+40)%7:foreseeBlock5;
            tmp_foreseeBlock1_status = (gameStart)?(rondom_num+ 0)%4:foreseeBlock1_status;
            tmp_foreseeBlock2_status = (gameStart)?(rondom_num+ 15)%4:foreseeBlock2_status;
            tmp_foreseeBlock3_status = (gameStart)?(rondom_num+ 25)%4:foreseeBlock3_status;
            tmp_foreseeBlock4_status = (gameStart)?(rondom_num+ 35)%4:foreseeBlock4_status;
            tmp_foreseeBlock5_status = (gameStart)?(rondom_num+ 45)%4:foreseeBlock5_status;
            tmp_not_first_time_store_block = 0;
        end
        `WAIT_BLOCK_EN:begin
            //tmp_state = (generate_block)?`BLOCK_DOWN:state;
            tmp_state = (generate_block)?`WRITE_FORESEE_BLOCK:state;
            tmp_block = (generate_block)?(back_from_store_state&&not_first_time_store_block)?last_store_block:foreseeBlock1:block;
            tmp_status = (generate_block)?(back_from_store_state&&not_first_time_store_block)?last_store_block_status:foreseeBlock1_status:status;
            tmp_new_status = (generate_block)?(back_from_store_state&&not_first_time_store_block)?last_store_block_status:foreseeBlock1_status:new_status;
            //tmp_pos_x = (generate_block)?4:pos_x;
            //tmp_pos_y = (generate_block)?17:pos_y;
            //tmp_start_write = (generate_block)?1:0;
            tmp_start_write = 0;
            // tmp_last_pos_x = (generate_block)?pos_x:last_pos_x;
            // tmp_last_pos_y = (generate_block)?pos_y:last_pos_y;
            tmp_eraseROW_en = 0;
            tmp_blockDownCAL_en = 0;
            tmp_start_eraseROW = 0;
            tmp_cal_rotate_en = 0;
            tmp_left_or_right = 0;
            tmp_space_is_press = 0;
            tmp_block_exist_exclude = block_exist;

            tmp_start_write_foreseeBlock = (generate_block)?1:0;
            tmp_start_store_block = 0;

            tmp_back_from_store_state = 0;

            if(!(back_from_store_state&&not_first_time_store_block))begin
                tmp_foreseeBlock1 = (generate_block)?foreseeBlock2:foreseeBlock1;
                tmp_foreseeBlock2 = (generate_block)?foreseeBlock3:foreseeBlock2;
                tmp_foreseeBlock3 = (generate_block)?foreseeBlock4:foreseeBlock3;
                tmp_foreseeBlock4 = (generate_block)?foreseeBlock5:foreseeBlock4;
                tmp_foreseeBlock5 = (generate_block)?(rondom_num+50)%7:foreseeBlock5;

                tmp_foreseeBlock1_status = (generate_block)?foreseeBlock2_status:foreseeBlock1_status;
                tmp_foreseeBlock2_status = (generate_block)?foreseeBlock3_status:foreseeBlock2_status;
                tmp_foreseeBlock3_status = (generate_block)?foreseeBlock4_status:foreseeBlock3_status;
                tmp_foreseeBlock4_status = (generate_block)?foreseeBlock5_status:foreseeBlock4_status;
                tmp_foreseeBlock5_status = (generate_block)?(rondom_num+55)%4:foreseeBlock5_status;
            end
            
/*
            if(back_from_store_state)begin
                if(!not_first_time_store_block)begin
                    tmp_not_first_time_store_block = 1;
                    tmp_block = (generate_block)?foreseeBlock1:block;
                    tmp_status = (generate_block)?foreseeBlock1_status:status;
                    tmp_new_status = (generate_block)?foreseeBlock1_status:new_status;

                    tmp_foreseeBlock1 = (generate_block)?foreseeBlock2:foreseeBlock1;
                    tmp_foreseeBlock2 = (generate_block)?foreseeBlock3:foreseeBlock2;
                    tmp_foreseeBlock3 = (generate_block)?foreseeBlock4:foreseeBlock3;
                    tmp_foreseeBlock4 = (generate_block)?foreseeBlock5:foreseeBlock4;
                    tmp_foreseeBlock5 = (generate_block)?(rondom_num+50)%7:foreseeBlock5;
        
                    tmp_foreseeBlock1_status = (generate_block)?foreseeBlock2_status:foreseeBlock1_status;
                    tmp_foreseeBlock2_status = (generate_block)?foreseeBlock3_status:foreseeBlock2_status;
                    tmp_foreseeBlock3_status = (generate_block)?foreseeBlock4_status:foreseeBlock3_status;
                    tmp_foreseeBlock4_status = (generate_block)?foreseeBlock5_status:foreseeBlock4_status;
                    tmp_foreseeBlock5_status = (generate_block)?(rondom_num+55)%4:foreseeBlock5_status;
                end
                else begin
                    tmp_block = (generate_block)?last_store_block:block;
                    tmp_status = (generate_block)?last_store_block_status:status;
                    tmp_new_status = (generate_block)?last_store_block_status:new_status;
                end
            end
            else begin
                tmp_block = (generate_block)?foreseeBlock1:block;
                tmp_status = (generate_block)?foreseeBlock1_status:status;
                tmp_new_status = (generate_block)?foreseeBlock1_status:new_status;
                tmp_foreseeBlock1 = (generate_block)?foreseeBlock2:foreseeBlock1;
                tmp_foreseeBlock2 = (generate_block)?foreseeBlock3:foreseeBlock2;
                tmp_foreseeBlock3 = (generate_block)?foreseeBlock4:foreseeBlock3;
                tmp_foreseeBlock4 = (generate_block)?foreseeBlock5:foreseeBlock4;
                tmp_foreseeBlock5 = (generate_block)?(rondom_num+50)%7:foreseeBlock5;
        
                tmp_foreseeBlock1_status = (generate_block)?foreseeBlock2_status:foreseeBlock1_status;
                tmp_foreseeBlock2_status = (generate_block)?foreseeBlock3_status:foreseeBlock2_status;
                tmp_foreseeBlock3_status = (generate_block)?foreseeBlock4_status:foreseeBlock3_status;
                tmp_foreseeBlock4_status = (generate_block)?foreseeBlock5_status:foreseeBlock4_status;
                tmp_foreseeBlock5_status = (generate_block)?(rondom_num+55)%4:foreseeBlock5_status;
            end
            */
        end
        `WRITE_FORESEE_BLOCK:begin
            tmp_state = (write_complete)?`SET_INIT_XY:`WRITE_FORESEE_BLOCK;
            tmp_start_write_foreseeBlock = 0;
        end
        `SET_INIT_XY:begin
            tmp_state = `BLOCK_DOWN;
            tmp_pos_x = init_pos_x;
            tmp_pos_y = init_pos_y;
            tmp_last_pos_x = pos_x;
            tmp_last_pos_y = pos_y;
            tmp_start_write = 1;
        end
        `BLOCK_DOWN:begin
            if(one_pulse_BlockDown)begin
                tmp_state = (down_en)?`SET_START_WRITE0:`BLOCK_SETTLE;
                tmp_pos_y = (down_en)?pos_y-1:pos_y;                
                tmp_start_write = (down_en)?1:0;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_eraseROW_en = (down_en)?0:1; 
            end
            else if(shift_right)begin
                tmp_state = `SET_START_WRITE0;
                tmp_pos_x = (right_en)?pos_x+1:pos_x;               
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;    
            end
            else if(shift_left)begin
                tmp_state = `SET_START_WRITE0;
                tmp_pos_x = (left_en)?pos_x-1:pos_x;
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
            end
            else if(rotate_right)begin
                tmp_state = `DET_ROTATE;
                tmp_cal_rotate_en = 1;
                tmp_left_or_right = 1;
                tmp_block_exist_exclude[color_pos1] = 0;
                tmp_block_exist_exclude[color_pos2] = 0;
                tmp_block_exist_exclude[color_pos3] = 0;
                tmp_block_exist_exclude[color_pos4] = 0;
            end
            else if(rotate_left)begin
                tmp_state = `DET_ROTATE;
                tmp_cal_rotate_en = 1;
                tmp_left_or_right = 0;
                tmp_block_exist_exclude[color_pos1] = 0;
                tmp_block_exist_exclude[color_pos2] = 0;
                tmp_block_exist_exclude[color_pos3] = 0;
                tmp_block_exist_exclude[color_pos4] = 0;
            end
            else if(space)begin
                tmp_state = `WRITE_SPACE;
                tmp_block_exist_exclude[color_pos1] = 0;
                tmp_block_exist_exclude[color_pos2] = 0;
                tmp_block_exist_exclude[color_pos3] = 0;
                tmp_block_exist_exclude[color_pos4] = 0;
            end
            else if(keyboard_shift)begin
                tmp_state = (store_block_flg == 0)?`SET_START_STORE_BLOCK:`BLOCK_DOWN;
            end
            else begin
                tmp_start_write = 0;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_block_exist_exclude = block_exist;
            end
        end
        `SET_START_STORE_BLOCK:begin
            //tmp_state = `STORE_BLOCK;
            tmp_start_store_block = 1;
            tmp_now_writing_store_block_status = status;
            tmp_now_writing_store_block = block;
            tmp_last_store_block = now_writing_store_block;
            tmp_last_store_block_status = now_writing_store_block_status;
        end
        `STORE_BLOCK:begin
            tmp_state = (write_complete)?`WAIT_BLOCK_EN:`STORE_BLOCK;
            tmp_start_store_block = 0;
            tmp_store_block_flg = 1;
            tmp_back_from_store_state = 1;
        end
        `WRITE_SPACE:begin
                tmp_state = `SET_START_WRITE0;
                tmp_pos_y = bottom_y;
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_space_is_press = 1;
        end
        `DET_ROTATE:begin
            tmp_state = (cal_rotate_complete)?`SET_START_WRITE0:state;
            tmp_start_write = (cal_rotate_complete)?1:0;
            tmp_pos_x = (cal_rotate_complete)?rotate_addr%10:pos_x;
            tmp_pos_y = (cal_rotate_complete)?rotate_addr/10:pos_y;
            tmp_last_pos_x = (cal_rotate_complete)?pos_x:tmp_last_pos_x;
            tmp_last_pos_y = (cal_rotate_complete)?pos_y:tmp_last_pos_y;
            tmp_cal_rotate_en = 0;
            tmp_new_status = (cal_rotate_complete)?rotate_status:new_status;
        end
        `SET_START_WRITE0:begin
            tmp_state = (write_complete&&space_is_press)?`BLOCK_SETTLE:(write_complete)?`BLOCK_DOWN:state;
            tmp_status = (write_complete)?new_status:status;
            tmp_start_write = 0;
            tmp_eraseROW_en = (write_complete&&space_is_press)?1:0;
        end
        `BLOCK_SETTLE:begin
            tmp_state = (check_finish)?`CAL_BLOCKDOWN:`BLOCK_SETTLE;
            tmp_blockDownCAL_en = (check_finish)?1:0;
            tmp_eraseROW_en = 0; 
            tmp_store_block_flg = 0;
        end
        `CAL_BLOCKDOWN:begin
            tmp_state = (CALfinish)?`ERASE_STATE:`CAL_BLOCKDOWN;
            tmp_start_eraseROW = (CALfinish)?1:0;
            tmp_blockDownCAL_en = 0;
        end
        `ERASE_STATE:begin
            tmp_state = (write_complete)?`WAIT_BLOCK_EN:`ERASE_STATE;
            tmp_start_eraseROW = 0;
        end
        default:begin
        end
    endcase
end
always@(posedge clk or posedge rst)begin
    if(rst)begin
        write_state <= WAIT_WRITE;                    
        write_en <= 0;
        address <= 0;
        block_exist <= 0;
        w_color <= 0;
        write_complete<=0;
        //change_en <= 0;
        downCount <=0;
        read_addr <= 0;
        
        write_foresee_en <= 0;
        reset_foresee <= 0;
        now_writing_foresee_block <= 0;
        now_writing_foresee_block_status <= 0;
        now_writing_foresee_pos_x <= 0;
        now_writing_foresee_pos_y <= 0;
        write_foreseeCount <= 0;
        write_store_en <= 0;
        reset_store <= 0;
        erase_row_count <= 0;
    end
    else begin
        write_state <= write_state;
        write_en <= write_en;
        address <= address;
        block_exist <= block_exist;
        w_color <= w_color;
        write_complete <= write_complete;
      //  change_en <= change_en;
        downCount <= downCount;
        read_addr <= read_addr;
        write_foresee_en <= write_foresee_en;
        reset_foresee <= reset_foresee;
        now_writing_foresee_block <= now_writing_foresee_block;
        now_writing_foresee_block_status <= now_writing_foresee_block_status;
        now_writing_foresee_pos_x <= now_writing_foresee_pos_x;
        now_writing_foresee_pos_y <= now_writing_foresee_pos_y;
        write_foreseeCount <= write_foreseeCount;

        write_store_en <= write_store_en;
        reset_store <= reset_store;
        erase_row_count <= erase_row_count;
        case(write_state)
            WAIT_WRITE:begin
                write_en <= 0;
                address <= 0;
                w_color <= 0;
                write_complete <= 0;
                if(start_write)begin
                    write_state <= SET_BLOCK_EXIST1;
                end
                else if (start_eraseROW)begin
                    write_state <= ERASE_ROW1;
                    downCount <=0;
                    erase_row_count <= 0;
                end
                else if(start_write_foreseeBlock)begin
                    write_state <= ERASE_PREVIOUS_FORESEE;
                    write_foreseeCount <= 0;
                end
                else if (start_store_block)begin
                    write_state <= ERASE_NOW_DOWN_BLOCK;
                end
                else begin
                    write_state <= WAIT_WRITE;
                end      
            end
            ERASE_NOW_DOWN_BLOCK:begin
                write_state <= WRITESTORE;
                block_exist[color_pos1] <=  0;
                block_exist[color_pos2] <=  0;
                block_exist[color_pos3] <=  0;
                block_exist[color_pos4] <=  0;
                reset_store <= 1;
            end
            WRITESTORE:begin
                write_state <= WRITESTORE_POS1;
                reset_store <= 0;
            end
            WRITESTORE_POS1:begin
                write_state <= WRITESTORE_POS2;
                write_store_en <= 1;
                w_color <= store_color;
                address <= store_block_pos1;
            end
            WRITESTORE_POS2:begin
                write_state <= WRITESTORE_POS3;
                write_store_en <= 1;
                w_color <= store_color;
                address <= store_block_pos2;
            end
            WRITESTORE_POS3:begin
                write_state <= WRITESTORE_POS4;
                write_store_en <= 1;
                w_color <= store_color;
                address <= store_block_pos3;
            end
            WRITESTORE_POS4:begin
                write_state <= WRITESTORE_COMPLETE;
                write_store_en <= 1;
                w_color <= store_color;
                address <= store_block_pos4;
            end
            WRITESTORE_COMPLETE:begin
                write_state <= WAIT_WRITE;
                write_complete <= 1;
                write_store_en <= 0;
            end

            ERASE_PREVIOUS_FORESEE:begin
                write_state <= SETTING_WRITE_FORESEE_BLOCK;
                reset_foresee[0] <= 1;
                reset_foresee[1] <= 1;
                reset_foresee[2] <= 1;
                reset_foresee[3] <= 1;
                reset_foresee[4] <= 1;
            end
            SETTING_WRITE_FORESEE_BLOCK:begin
                write_state <= WRITE_FORESEE_BLOCK_POS1;
                reset_foresee[0] <= 0;
                reset_foresee[1] <= 0;
                reset_foresee[2] <= 0;
                reset_foresee[3] <= 0;
                reset_foresee[4] <= 0;
                write_foresee_en <= 0;
                case(write_foreseeCount)
                    0:begin
                        now_writing_foresee_block <= foreseeBlock1;
                        now_writing_foresee_block_status <= foreseeBlock1_status;
                        now_writing_foresee_pos_x <= 2;
                        now_writing_foresee_pos_y <= 22;
                    end
                    1:begin
                        now_writing_foresee_block <= foreseeBlock2;
                        now_writing_foresee_block_status <= foreseeBlock2_status;
                        now_writing_foresee_pos_x <= 2;
                        now_writing_foresee_pos_y <= 17;
                    end
                    2:begin
                        now_writing_foresee_block <= foreseeBlock3;
                        now_writing_foresee_block_status <= foreseeBlock3_status;
                        now_writing_foresee_pos_x <= 2;
                        now_writing_foresee_pos_y <= 12;
                    end
                    3:begin
                        now_writing_foresee_block <= foreseeBlock4;
                        now_writing_foresee_block_status <= foreseeBlock4_status;
                        now_writing_foresee_pos_x <= 2;
                        now_writing_foresee_pos_y <= 7;
                    end
                    4:begin
                        now_writing_foresee_block <= foreseeBlock5;
                        now_writing_foresee_block_status <= foreseeBlock5_status;
                        now_writing_foresee_pos_x <= 2;
                        now_writing_foresee_pos_y <= 2;
                    end
                    default:begin end
                endcase
            end
            WRITE_FORESEE_BLOCK_POS1:begin
                write_foreseeCount <= write_foreseeCount+1;
                write_state <= WRITE_FORESEE_BLOCK_POS2;
                write_foresee_en <= 1;
                w_color <= foresee_color;
                address <= foresee_block_pos_1;
            end
            WRITE_FORESEE_BLOCK_POS2:begin
                write_state <= WRITE_FORESEE_BLOCK_POS3;
                write_foresee_en <= 1;
                w_color <= foresee_color;
                address <= foresee_block_pos_2;
            end
            WRITE_FORESEE_BLOCK_POS3:begin
                write_state <= WRITE_FORESEE_BLOCK_POS4;
                write_foresee_en <= 1;
                w_color <= foresee_color;
                address <= foresee_block_pos_3;
            end
            WRITE_FORESEE_BLOCK_POS4:begin
                write_state <= (write_foreseeCount == 5)?FORESEE_BLOCK_WRITE_COMPLETE:SETTING_WRITE_FORESEE_BLOCK;
                write_foresee_en <= 1;
                w_color <= foresee_color;
                address <= foresee_block_pos_4;
            end
            FORESEE_BLOCK_WRITE_COMPLETE:begin
                write_state <= WAIT_WRITE;
                write_foresee_en <= 0;
                write_complete <= 1;
            end
            SET_BLOCK_EXIST1:begin
                write_state <= WRITE_POS1;
                block_exist[last_pos1] <=  0;
                block_exist[last_pos2] <=  0;
                block_exist[last_pos3] <=  0;
                block_exist[last_pos4] <=  0;
                block_exist[color_pos1] <= 1;
                block_exist[color_pos2] <= 1;
                block_exist[color_pos3] <= 1;
                block_exist[color_pos4] <= 1;
            end
            /*
            TEST_STATE_1:begin
                write_state <= WRITE_POS1;
                write_en<=0;
                change_en[color_pos1] <= 1;
                address <= color_pos1;
            end
            */
            WRITE_POS1:begin
                write_state <= WRITE_POS2;
                write_en <= 1;
                w_color <= block_color;
                address <= color_pos1;
            end
            /*
            TEST_STATE_2:begin
                write_state <= WRITE_POS2;
                write_en<=0;
                change_en[color_pos1] <= 0;
                change_en[color_pos2] <= 1;
                address <= color_pos2;
            end
            */
            WRITE_POS2:begin
                write_state <= WRITE_POS3;
                write_en <= 1;
                w_color <=block_color;
                address <= color_pos2;
            end
            /*
            TEST_STATE_3:begin
                write_state <= WRITE_POS3;
                write_en<=0;
                change_en[color_pos2] <= 0;
                change_en[color_pos3] <= 1;
                address <= color_pos3;
            end
            */
            WRITE_POS3:begin
                write_state <= WRITE_POS4;
                write_en <= 1;
                w_color <=block_color;
                address <= color_pos3;
            end
            /*
            TEST_STATE_4:begin
                write_state <= WRITE_POS4;
                write_en<=0;
                change_en[color_pos3] <= 0;
                change_en[color_pos4] <= 1;
                address <= color_pos4;
            end
            */
            WRITE_POS4:begin
                write_state <= WRITE_COMPLETE;
                write_en <= 1;
                w_color <=block_color;
                address <= color_pos4;
            end
            WRITE_COMPLETE:begin
                //change_en[color_pos4] <= 0;
                write_state <= WAIT_WRITE;
                write_en <= 0;
                write_complete<=1;
            end
            /*
            ERASE_ROW1:begin
                write_state <= ERASE_ROW2;
                if(er1!=25)begin
                    block_exist[p0] <= 0;
                    block_exist[p1] <= 0;
                    block_exist[p2] <= 0;
                    block_exist[p3] <= 0;
                    block_exist[p4] <= 0;
                    block_exist[p5] <= 0;
                    block_exist[p6] <= 0;
                    block_exist[p7] <= 0;
                    block_exist[p8] <= 0;
                    block_exist[p9] <= 0;
                end
            end
            ERASE_ROW2:begin
                write_state <= ERASE_ROW3;
                if(er2!=25)begin
                    block_exist[p10] <= 0;
                    block_exist[p11] <= 0;
                    block_exist[p12] <= 0;
                    block_exist[p13] <= 0;
                    block_exist[p14] <= 0;
                    block_exist[p15] <= 0;
                    block_exist[p16] <= 0;
                    block_exist[p17] <= 0;
                    block_exist[p18] <= 0;
                    block_exist[p19] <= 0;
                end
            end
            ERASE_ROW3:begin
                write_state <= ERASE_ROW4;
                if(er3!=25)begin
                    block_exist[p20] <= 0;
                    block_exist[p21] <= 0;
                    block_exist[p22] <= 0;
                    block_exist[p23] <= 0;
                    block_exist[p24] <= 0;
                    block_exist[p25] <= 0;
                    block_exist[p26] <= 0;
                    block_exist[p27] <= 0;
                    block_exist[p28] <= 0;
                    block_exist[p29] <= 0;
                end
            end
            ERASE_ROW4:begin
                write_state <= SETTING_READ_ADDRESS;
                if(er4!=25)begin
                    block_exist[p30] <= 0;
                    block_exist[p31] <= 0;
                    block_exist[p32] <= 0;
                    block_exist[p33] <= 0;
                    block_exist[p34] <= 0;
                    block_exist[p35] <= 0;
                    block_exist[p36] <= 0;
                    block_exist[p37] <= 0;
                    block_exist[p38] <= 0;
                    block_exist[p39] <= 0;
                end
            end
            */
            ERASE_ROW1:begin
                write_state <= (erase_row_count == 5000000)?ERASE_ROW2:ERASE_ROW1;
                if(er1!=25)begin
                    block_exist[p4] <= 0;
                    block_exist[p5] <= 0;
                end
                if(er2!=25)begin
                    block_exist[p14] <= 0;
                    block_exist[p15] <= 0;
                end
                if(er3!=25)begin
                    block_exist[p24] <= 0;
                    block_exist[p25] <= 0;
                end
                if(er4!=25)begin
                    block_exist[p34] <= 0;
                    block_exist[p35] <= 0;
                end
                erase_row_count <= erase_row_count+1;
            end
            ERASE_ROW2:begin
                write_state <= (erase_row_count == 10000000)?ERASE_ROW3:ERASE_ROW2;
                if(er1!=25)begin
                    block_exist[p3] <= 0;
                    block_exist[p6] <= 0;
                end
                if(er2!=25)begin
                    block_exist[p13] <= 0;
                    block_exist[p16] <= 0;
                end
                if(er3!=25)begin
                    block_exist[p23] <= 0;
                    block_exist[p26] <= 0;
                end
                if(er4!=25)begin
                    block_exist[p33] <= 0;
                    block_exist[p36] <= 0;
                end
                erase_row_count <= erase_row_count+1;
            end
            ERASE_ROW3:begin
                write_state <= (erase_row_count == 15000000)?ERASE_ROW4:ERASE_ROW3;
                if(er1!=25)begin
                    block_exist[p2] <= 0;
                    block_exist[p7] <= 0;
                end
                if(er2!=25)begin
                    block_exist[p12] <= 0;
                    block_exist[p17] <= 0;
                end
                if(er3!=25)begin
                    block_exist[p22] <= 0;
                    block_exist[p27] <= 0;
                end
                if(er4!=25)begin
                    block_exist[p32] <= 0;
                    block_exist[p37] <= 0;
                end
                erase_row_count <= erase_row_count+1;
            end
            ERASE_ROW4:begin
                write_state <= (erase_row_count == 20000000)?ERASE_ROW5:ERASE_ROW4;
                if(er1!=25)begin
                    block_exist[p1] <= 0;
                    block_exist[p8] <= 0;
                end
                if(er2!=25)begin
                    block_exist[p11] <= 0;
                    block_exist[p18] <= 0;
                end
                if(er3!=25)begin
                    block_exist[p21] <= 0;
                    block_exist[p28] <= 0;
                end
                if(er4!=25)begin
                    block_exist[p31] <= 0;
                    block_exist[p38] <= 0;
                end
                erase_row_count <= erase_row_count+1;
            end
            ERASE_ROW5:begin
                write_state <= (erase_row_count == 25000000)?SETTING_READ_ADDRESS:ERASE_ROW5;
                if(er1!=25)begin
                    block_exist[p0] <= 0;
                    block_exist[p9] <= 0;
                end
                if(er2!=25)begin
                    block_exist[p10] <= 0;
                    block_exist[p19] <= 0;
                end
                if(er3!=25)begin
                    block_exist[p20] <= 0;
                    block_exist[p29] <= 0;
                end
                if(er4!=25)begin
                    block_exist[p30] <= 0;
                    block_exist[p39] <= 0;
                end
                erase_row_count <= erase_row_count+1;
            end
            SETTING_READ_ADDRESS:begin
                write_state <= SETTING_BLOCKEXIST;
                write_en<=0;
                read_addr <= downCount+10;          
            end
            SETTING_BLOCKEXIST:begin
                write_state <= DOWN_POS;
                //change_en[down_addr] <= 1;
                block_exist[down_addr] <= (block_exist[read_addr])?1:0;
            end
            DOWN_POS:begin
                write_state <= CHECK_COMPLETE;
                write_en <= (block_exist[read_addr])?1:0;
                address <= down_addr;
                w_color <= read_addr_color;
                downCount <= downCount+1;
            end
            CHECK_COMPLETE:begin
                write_state <= (read_addr==239)?DOWN_COMPLETE:SETTING_READ_ADDRESS;
                write_en<=0;
                //change_en[down_addr] <= 0;
            end   
            DOWN_COMPLETE:begin
                write_state <= WAIT_WRITE;
                write_complete<=1;
            end

            default:begin end
        endcase
    end
end
endmodule

module rotate(cal_rotate_complete,final_addr,final_status,block,status,left_OR_right,block_exist,clk,rst,pos_x,pos_y,cal_rotate_en);
output reg[7:0] final_addr;
output reg[1:0]final_status;
output reg cal_rotate_complete;
input [2:0]block;
input [1:0]status;
input left_OR_right;
input [239:0]block_exist;
input clk;
input rst;
input [4:0]pos_x;
input [4:0]pos_y;
input cal_rotate_en;
reg tmp_cal_rotate_complete;
reg [7:0] tmp_final_addr;
reg [1:0] tmp_final_status;

wire[7:0]point1,point2,point3,point4;

reg [5:0] state;
reg [5:0] tmp_state;
parameter [5:0] INIT = 6'b000000;
parameter [5:0] CHECK_OFFSET_JLSTZ_1 = 6'b000001;
parameter [5:0] CHECK_OFFSET_JLSTZ_2 = 6'b000010;
parameter [5:0] CHECK_OFFSET_JLSTZ_3 = 6'b000011;
parameter [5:0] CHECK_OFFSET_JLSTZ_4 = 6'b000100;
parameter [5:0] CHECK_OFFSET_JLSTZ_5 = 6'b000101;
parameter [5:0] CHECK_OFFSET_I_1 = 6'b000110;
parameter [5:0] CHECK_OFFSET_I_2 = 6'b000111;
parameter [5:0] CHECK_OFFSET_I_3 = 6'b001000;
parameter [5:0] CHECK_OFFSET_I_4 = 6'b001001;
parameter [5:0] CHECK_OFFSET_I_5 = 6'b001010;
parameter [5:0] CHECK_OFFSET_O_1 = 6'b001011;
parameter [5:0] COMPLETE_SUCCESS = 6'b001100;

parameter [5:0] SET_OFFSET_JLSTZ_1 = 6'b001101;
parameter [5:0] SET_OFFSET_JLSTZ_2 = 6'b001110;
parameter [5:0] SET_OFFSET_JLSTZ_3 = 6'b001111;
parameter [5:0] SET_OFFSET_JLSTZ_4 = 6'b010000;
parameter [5:0] SET_OFFSET_JLSTZ_5 = 6'b010001;
parameter [5:0] COMPLETE_FAIL = 6'b010010;

parameter [5:0] SET_OFFSET_I_1 = 6'b010011;
parameter [5:0] SET_OFFSET_I_2 = 6'b010100;
parameter [5:0] SET_OFFSET_I_3 = 6'b010101;
parameter [5:0] SET_OFFSET_I_4 = 6'b010110;
parameter [5:0] SET_OFFSET_I_5 = 6'b010111;

parameter [5:0] SET_OFFSET_O_1 = 6'b011000;


wire [11:0] w_color; // redundant
reg [4:0]check_pos_x,tmp_check_pos_x;
reg [4:0]check_pos_y,tmp_check_pos_y;
reg signed[5:0]signed_check_pos_x,tmp_signed_check_pos_x;
reg signed[5:0]signed_check_pos_y,tmp_signed_check_pos_y;
reg [1:0]check_status;

reg [4:0]offset_data_x_1,offset_data_x_2,offset_data_x_3,offset_data_x_4,offset_data_x_5;
reg [4:0]offset_data_y_1,offset_data_y_2,offset_data_y_3,offset_data_y_4,offset_data_y_5;

wire exceed;
always@(*)begin
    if(block == `BLOCK_I)begin
        case(status)
            `BLOCK_STATUS_0:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_R:`BLOCK_STATUS_L; //1 is right
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 = -2;offset_data_x_3 =  1;offset_data_x_4 = -2;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 = -1;offset_data_y_5 =  2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 =  2;offset_data_x_3 = -1;offset_data_x_4 =  2;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 =  1;offset_data_y_5 = -2;
                end
            end
            `BLOCK_STATUS_R:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_2:`BLOCK_STATUS_0;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 =  2;offset_data_x_4 = -1;offset_data_x_5 =  2;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 =  2;offset_data_y_5 = -1;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 = -2;offset_data_x_4 =  1;offset_data_x_5 = -2;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 = -2;offset_data_y_5 =  1;
                end
            end
            `BLOCK_STATUS_2:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_L:`BLOCK_STATUS_R;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 =  2;offset_data_x_3 = -1;offset_data_x_4 =  2;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 =  1;offset_data_y_5 = -2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 = -2;offset_data_x_3 =  1;offset_data_x_4 = -2;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 = -1;offset_data_y_5 =  2;
                end
            end
            `BLOCK_STATUS_L:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_0:`BLOCK_STATUS_2;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 = -2;offset_data_x_4 =  1;offset_data_x_5 = -2;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 = -2;offset_data_y_5 =  1;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 =  2;offset_data_x_4 = -1;offset_data_x_5 =  2;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  0;offset_data_y_4 =  2;offset_data_y_5 = -1;
                end
            end
            default:begin
            end
        endcase
    end
    else if (block == `BLOCK_O)begin
        case(status)
            `BLOCK_STATUS_0:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_R:`BLOCK_STATUS_L; //1 is right
                if(left_OR_right)begin
                    offset_data_x_1 =  0;
                    offset_data_y_1 =  1;
                end
                else begin
                    offset_data_x_1 =  0;
                    offset_data_y_1 = -1;
                end
            end
            `BLOCK_STATUS_R:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_2:`BLOCK_STATUS_0;
                if(left_OR_right)begin
                    offset_data_x_1 =  1;
                    offset_data_y_1 =  0;
                end
                else begin
                    offset_data_x_1 = -1;
                    offset_data_y_1 =  0;
                end
            end
            `BLOCK_STATUS_2:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_L:`BLOCK_STATUS_R;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;
                    offset_data_y_1 = -1;
                end
                else begin
                    offset_data_x_1 =  0;
                    offset_data_y_1 =  1;
                end
            end
            `BLOCK_STATUS_L:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_0:`BLOCK_STATUS_2;
                if(left_OR_right)begin
                    offset_data_x_1 = -1;
                    offset_data_y_1 =  0;
                end
                else begin
                    offset_data_x_1 =  1;
                    offset_data_y_1 =  0;
                end
            end
            default:begin
            end
        endcase
    end
    else begin
        case(status)
            `BLOCK_STATUS_0:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_R:`BLOCK_STATUS_L; //1 is right
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 = -1;offset_data_x_4 =  0;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  1;offset_data_y_4 = -2;offset_data_y_5 = -2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 =  1;offset_data_x_4 =  0;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 = -1;offset_data_y_4 =  2;offset_data_y_5 =  2;
                end
            end
            `BLOCK_STATUS_R:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_2:`BLOCK_STATUS_0;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 =  1;offset_data_x_4 =  0;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 = -1;offset_data_y_4 =  2;offset_data_y_5 =  2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 = -1;offset_data_x_4 =  0;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  1;offset_data_y_4 = -2;offset_data_y_5 = -2;
                end
            end
            `BLOCK_STATUS_2:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_L:`BLOCK_STATUS_R;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 =  1;offset_data_x_4 =  0;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  1;offset_data_y_4 = -2;offset_data_y_5 = -2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 = -1;offset_data_x_4 =  0;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 = -1;offset_data_y_4 =  2;offset_data_y_5 =  2;
                end
            end
            `BLOCK_STATUS_L:begin
                check_status = (left_OR_right)?`BLOCK_STATUS_0:`BLOCK_STATUS_2;
                if(left_OR_right)begin
                    offset_data_x_1 =  0;offset_data_x_2 = -1;offset_data_x_3 = -1;offset_data_x_4 =  0;offset_data_x_5 = -1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 = -1;offset_data_y_4 =  2;offset_data_y_5 =  2;
                end
                else begin
                    offset_data_x_1 =  0;offset_data_x_2 =  1;offset_data_x_3 =  1;offset_data_x_4 =  0;offset_data_x_5 =  1;
                    offset_data_y_1 =  0;offset_data_y_2 =  0;offset_data_y_3 =  1;offset_data_y_4 = -2;offset_data_y_5 = -2;
                end
            end
            default:begin
            end
        endcase
    end
end
wire [4:0] init_pos_x,init_pos_y;
shape s(.init_pos_x(init_pos_x),.init_pos_y(init_pos_y),.exceed(exceed),.w_color(w_color),.color_pos1(point1),.color_pos2(point2),.color_pos3(point3),.color_pos4(point4),.block(block),.status(check_status),.pos_x(check_pos_x),.pos_y(check_pos_y));

always@(posedge clk or posedge rst)begin
    if(rst)begin
        final_addr <= 0;
        final_status <= 0;
        state <= INIT;
        check_pos_x <= 0;
        check_pos_y <= 0;
        cal_rotate_complete <=0;
        signed_check_pos_x <= 0;
        signed_check_pos_y <=0;
    end
    else begin
        final_addr <= tmp_final_addr;
        final_status <= tmp_final_status;
        state <= tmp_state;
        check_pos_x <= tmp_check_pos_x;
        check_pos_y <= tmp_check_pos_y;
        cal_rotate_complete <= tmp_cal_rotate_complete;
        signed_check_pos_x <= tmp_signed_check_pos_x;
        signed_check_pos_y <= tmp_signed_check_pos_y;
    end
end
always@(*)begin
    tmp_final_addr = final_addr;
    tmp_final_status = final_status;
    tmp_state = state;
    tmp_check_pos_x = check_pos_x;
    tmp_check_pos_y = check_pos_y;
    tmp_cal_rotate_complete = cal_rotate_complete;
    tmp_signed_check_pos_x = signed_check_pos_x;
    tmp_signed_check_pos_y = signed_check_pos_y;
    case(state)
        INIT:begin
            tmp_final_status = (cal_rotate_en)?0:final_status;
            tmp_final_addr = (cal_rotate_en)? 0 :final_addr;
            tmp_cal_rotate_complete = 0;
            if(cal_rotate_en)begin
                if(block == `BLOCK_I)begin
                    tmp_state = SET_OFFSET_I_1;
                end
                else if (block == `BLOCK_O)begin
                    tmp_state = SET_OFFSET_O_1;
                end
                else begin
                    tmp_state = SET_OFFSET_JLSTZ_1;
                end
            end
        end
        SET_OFFSET_JLSTZ_1:begin
            tmp_state = CHECK_OFFSET_JLSTZ_1;
            tmp_check_pos_x = pos_x + offset_data_x_1;
            tmp_check_pos_y = pos_y + offset_data_y_1;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_JLSTZ_1:begin
            //if((pos_x+offset_data_x_1)<0 ||(pos_x+offset_data_x_1)>9||(pos_y+offset_data_y_1)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_JLSTZ_2;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_JLSTZ_2;
                end
            end
        end

        SET_OFFSET_JLSTZ_2:begin
            tmp_state = CHECK_OFFSET_JLSTZ_2;
            tmp_check_pos_x = pos_x + offset_data_x_2;
            tmp_check_pos_y = pos_y + offset_data_y_2;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_JLSTZ_2:begin
            //if((pos_x+offset_data_x_2)<0 ||(pos_x+offset_data_x_2)>9||(pos_y+offset_data_y_2)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_JLSTZ_3;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_JLSTZ_3;
                end
            end
        end

        SET_OFFSET_JLSTZ_3:begin
            tmp_state = CHECK_OFFSET_JLSTZ_3;
            tmp_check_pos_x = pos_x + offset_data_x_3;
            tmp_check_pos_y = pos_y + offset_data_y_3;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_JLSTZ_3:begin
            //if((pos_x+offset_data_x_3)<0 ||(pos_x+offset_data_x_3)>9||(pos_y+offset_data_y_3)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_JLSTZ_4;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_JLSTZ_4;
                end
            end
        end

        SET_OFFSET_JLSTZ_4:begin
            tmp_state = CHECK_OFFSET_JLSTZ_4;
            tmp_check_pos_x = pos_x + offset_data_x_4;
            tmp_check_pos_y = pos_y + offset_data_y_4;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_JLSTZ_4:begin
            //if((pos_x+offset_data_x_4)<0 ||(pos_x+offset_data_x_4)>9||(pos_y+offset_data_y_4)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_JLSTZ_5;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_JLSTZ_5;
                end
            end
        end

        SET_OFFSET_JLSTZ_5:begin
            tmp_state = CHECK_OFFSET_JLSTZ_5;
            tmp_check_pos_x = pos_x + offset_data_x_5;
            tmp_check_pos_y = pos_y + offset_data_y_5;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_JLSTZ_5:begin
            //if((pos_x+offset_data_x_5)<0 ||(pos_x+offset_data_x_5)>9||(pos_y+offset_data_y_5)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = COMPLETE_FAIL;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = COMPLETE_FAIL;
                end
            end
        end

        SET_OFFSET_I_1:begin
            tmp_state = CHECK_OFFSET_I_1;
            tmp_check_pos_x = pos_x + offset_data_x_1;
            tmp_check_pos_y = pos_y + offset_data_y_1;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_I_1:begin
            //if((pos_x+offset_data_x_1)<0 ||(pos_x+offset_data_x_1)>9||(pos_y+offset_data_y_1)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_I_2;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_I_2;
                end
            end
        end

        SET_OFFSET_I_2:begin
            tmp_state = CHECK_OFFSET_I_2;
            tmp_check_pos_x = pos_x + offset_data_x_2;
            tmp_check_pos_y = pos_y + offset_data_y_2;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_I_2:begin
            //if((pos_x+offset_data_x_2)<0 ||(pos_x+offset_data_x_2)>9||(pos_y+offset_data_y_2)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_I_3;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_I_3;
                end
            end
        end

        SET_OFFSET_I_3:begin
            tmp_state = CHECK_OFFSET_I_3;
            tmp_check_pos_x = pos_x + offset_data_x_3;
            tmp_check_pos_y = pos_y + offset_data_y_3;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_I_3:begin
            //if((pos_x+offset_data_x_3)<0 ||(pos_x+offset_data_x_3)>9||(pos_y+offset_data_y_3)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_I_4;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_I_4;
                end
            end
        end

        SET_OFFSET_I_4:begin
            tmp_state = CHECK_OFFSET_I_4;
            tmp_check_pos_x = pos_x + offset_data_x_4;
            tmp_check_pos_y = pos_y + offset_data_y_4;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_I_4:begin
            //if((pos_x+offset_data_x_4)<0 ||(pos_x+offset_data_x_4)>9||(pos_y+offset_data_y_4)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = SET_OFFSET_I_5;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = SET_OFFSET_I_5;
                end
            end
        end

        SET_OFFSET_I_5:begin
            tmp_state = CHECK_OFFSET_I_5;
            tmp_check_pos_x = pos_x + offset_data_x_5;
            tmp_check_pos_y = pos_y + offset_data_y_5;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_I_5:begin
            //if((pos_x+offset_data_x_5)<0 ||(pos_x+offset_data_x_5)>9||(pos_y+offset_data_y_5)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = COMPLETE_FAIL;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = COMPLETE_FAIL;
                end
            end
        end

        SET_OFFSET_O_1:begin
            tmp_state = CHECK_OFFSET_O_1;
            tmp_check_pos_x = pos_x + offset_data_x_1;
            tmp_check_pos_y = pos_y + offset_data_y_1;
            tmp_signed_check_pos_x = pos_x + offset_data_x_1;
            tmp_signed_check_pos_y = pos_y + offset_data_y_1;
        end
        CHECK_OFFSET_O_1:begin
            //if((pos_x+offset_data_x_1)<0 ||(pos_x+offset_data_x_1)>9||(pos_y+offset_data_y_1)<0||exceed == 1)begin
            if(signed_check_pos_x<0 ||signed_check_pos_x>9||signed_check_pos_y<0||exceed == 1)begin
                tmp_state = COMPLETE_FAIL;
            end
            else begin
                if(block_exist[point1] == 0 && block_exist[point2] == 0 && block_exist[point3] == 0 && block_exist[point4] == 0)begin
                    tmp_state = COMPLETE_SUCCESS;
                end
                else begin
                    tmp_state = COMPLETE_FAIL;
                end
            end
        end
        COMPLETE_SUCCESS:begin
            tmp_state = INIT;
            tmp_final_addr = check_pos_x + check_pos_y*10;
            tmp_final_status = check_status;
            tmp_cal_rotate_complete = 1;
        end
        COMPLETE_FAIL:begin
            tmp_state = INIT;
            tmp_final_addr = pos_x + pos_y*10;
            tmp_final_status = status;
            tmp_cal_rotate_complete = 1;
        end
        default:begin
            
        end 
    endcase
end
endmodule

module PRESS_SPACE_POS(bottom_y,block,status,pos_x,pos_y,block_exist);
input [239:0] block_exist;
input [2:0]block;
input [1:0]status;
input [4:0]pos_x;
input [4:0]pos_y;
output [4:0]bottom_y;

wire l_en1,l_en2,l_en3,l_en4,l_en5,l_en6,l_en7,l_en8,l_en9,l_en10,l_en11,l_en12,l_en13,l_en14,l_en15,l_en16,l_en17,l_en18,l_en19,l_en20;
wire r_en1,r_en2,r_en3,r_en4,r_en5,r_en6,r_en7,r_en8,r_en9,r_en10,r_en11,r_en12,r_en13,r_en14,r_en15,r_en16,r_en17,r_en18,r_en19,r_en20;
wire d_en1,d_en2,d_en3,d_en4,d_en5,d_en6,d_en7,d_en8,d_en9,d_en10,d_en11,d_en12,d_en13,d_en14,d_en15,d_en16,d_en17,d_en18,d_en19,d_en20;

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
endmodule

module shape_for_foresee (w_color,color_pos1,color_pos2,color_pos3,color_pos4,block,status,pos_x,pos_y);
input [2:0] block;
input [1:0] status;
input [4:0] pos_x;
input [4:0] pos_y;
output reg [11:0] w_color;
output reg[7:0] color_pos1,color_pos2,color_pos3,color_pos4;
always@(*)begin
    case(block)
        `BLOCK_J:begin
            w_color = `COLOR_J;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x-1; 
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y+1)*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-1;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y-1)*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
            endcase
        end
        `BLOCK_L:begin
            w_color = `COLOR_L;
            case(status)
                `BLOCK_STATUS_0:begin
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x+1; 
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y-1)*5+pos_x  ;
                    color_pos4 = (pos_y-1)*5+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-1;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x-1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x-1;
                    color_pos3 = (pos_y+1)*5+pos_x  ;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
            endcase
        end
        `BLOCK_S:begin
            w_color = `COLOR_S;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x  ; 
                    color_pos3 = (pos_y+1)*5+pos_x+1;
                    color_pos4 = (pos_y  )*5+pos_x-1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x+1;
                    color_pos3 = (pos_y-1)*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x-1;
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
            endcase
        end
        `BLOCK_T:begin
            w_color = `COLOR_T;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x  ; 
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-1;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
            endcase
        end
        `BLOCK_Z:begin
            w_color = `COLOR_Z;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x-1; 
                    color_pos3 = (pos_y+1)*5+pos_x  ;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x+1;
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-1;
                    color_pos3 = (pos_y-1)*5+pos_x  ;
                    color_pos4 = (pos_y-1)*5+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x-1;
                end
            endcase
        end
        `BLOCK_I:begin
            w_color = `COLOR_I;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y  )*5+pos_x-1; 
                    color_pos3 = (pos_y  )*5+pos_x+1;
                    color_pos4 = (pos_y  )*5+pos_x+2;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x  ;
                    color_pos3 = (pos_y-1)*5+pos_x  ;
                    color_pos4 = (pos_y-2)*5+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-2;
                    color_pos3 = (pos_y  )*5+pos_x-1;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+2)*5+pos_x  ;
                    color_pos3 = (pos_y+1)*5+pos_x  ;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
            endcase
        end
        `BLOCK_O:begin
            w_color = `COLOR_O;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*5+pos_x  ; 
                    color_pos3 = (pos_y+1)*5+pos_x+1;
                    color_pos4 = (pos_y  )*5+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x+1;
                    color_pos3 = (pos_y-1)*5+pos_x  ;
                    color_pos4 = (pos_y-1)*5+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y  )*5+pos_x-1;
                    color_pos3 = (pos_y-1)*5+pos_x-1;
                    color_pos4 = (pos_y-1)*5+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*5+pos_x  ;
                    color_pos2 = (pos_y+1)*5+pos_x-1;
                    color_pos3 = (pos_y+1)*5+pos_x  ;
                    color_pos4 = (pos_y  )*5+pos_x-1;
                end
            endcase
        end
        default:begin end
    endcase
end
endmodule
