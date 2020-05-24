`timescale 1ns / 1ps
`define BLOCK_J 3'b000
`define BLOCK_L 3'b001
`define BLOCK_S 3'b010
`define BLOCK_T 3'b011
`define BLOCK_Z 3'b100
`define BLOCK_I 3'b101
`define BLOCK_O 3'b110

`define BLOCK_STATUS_0 2'b00
`define BLOCK_STATUS_R 2'b01
`define BLOCK_STATUS_2 2'b10
`define BLOCK_STATUS_L 2'b11

`define WAIT_BLOCK_EN 3'b000
`define BLOCK_DOWN 3'b001
`define BLOCK_SETTLE 3'b010
`define SET_START_WRITE0 3'b011
`define ERASE_STATE 3'b100
`define CAL_BLOCKDOWN 3'b101

`define COLOR_J 12'h00f
`define COLOR_L 12'hf60
`define COLOR_S 12'h0f0
`define COLOR_T 12'hd7d
`define COLOR_Z 12'hf00
`define COLOR_I 12'h0ff
`define COLOR_O 12'hff0

module Tetris(vgaRed,vgaGreen,vgaBlue,hsync,vsync,clk,rst,btn_L,btn_R,btn_U,btn_D,generate_block,led);
input clk;
input rst;
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
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480

input btn_L,btn_R,btn_U,btn_D;
wire db_btn_L,db_btn_R,db_btn_U,db_btn_D;
wire op_btn_L,op_btn_R,op_btn_U,op_btn_D;

debounce db0 (.pb_debounced(db_btn_L),.pb(btn_L),.clk(clk));
debounce db1 (.pb_debounced(db_btn_R),.pb(btn_R),.clk(clk));
debounce db2 (.pb_debounced(db_btn_U),.pb(btn_U),.clk(clk));
debounce db3 (.pb_debounced(db_btn_D),.pb(btn_D),.clk(clk));
one_pulse op0 (.push_onepulse(op_btn_L),.rst(rst),.clk(clk),.push_debounced(db_btn_L));
one_pulse op1 (.push_onepulse(op_btn_R),.rst(rst),.clk(clk),.push_debounced(db_btn_R));
one_pulse op2 (.push_onepulse(op_btn_U),.rst(rst),.clk(clk),.push_debounced(db_btn_U));
one_pulse op3 (.push_onepulse(op_btn_D),.rst(rst),.clk(clk),.push_debounced(db_btn_D));



wire [2399:0] color;
wire write_en;
wire [11:0] w_color;
wire [7:0]address;
wire [199:0]block_exist;
wire [199:0]change_en;


clock_divisor clk_wiz_0_inst(.clk(clk),.clk1(clk_25MHz),.clk22(clk_22),.clkBlockDown(clkBlockDown));
pixel_gen pg (.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.h_cnt(h_cnt),.v_cnt(v_cnt),.valid(valid),.color(color));
vga_controller vga_inst(.pclk(clk_25MHz),.reset(rst),.hsync(hsync),.vsync(vsync),.valid(valid),.h_cnt(h_cnt),.v_cnt(v_cnt));
BackGroundMemory bm (.color(color),.clk(clk),.rst(rst),.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.change_en(change_en));
putBlock pb (.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.generate_block(generate_block),
             .block_type(`BLOCK_J),.block_status(`BLOCK_STATUS_0),.rst(rst),.clk(clk),.turn_right(op_btn_U),.turn_left(op_btn_D),
             .shift_left(op_btn_L),.shift_right(op_btn_R),.clkBlockDown(clkBlockDown),.change_en(change_en),.color(color),.led(led));
//putblock pb (.outBackground(),.blockType(),.R_rotate(),.L_rotate(),.blockState(),.rst(),.clk(),.background(),.clkBlockDown(),.start_position());

endmodule
module setting_touch_point(d1,d2,d3,d4,l1,l2,l3,l4,r1,r2,r3,r4,block,status,pos_x,pos_y);
input [2:0]block;
input [1:0]status;
input [4:0]pos_x,pos_y;
output reg [7:0]d1,d2,d3,d4,l1,l2,l3,l4,r1,r2,r3,r4;
always@(*)begin
    case(block)
        `BLOCK_J:begin
            case(status)
                `BLOCK_STATUS_0:begin
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;//redundant
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y+1)*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y+1)*10+pos_x  ;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y  )*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-1;
                    l2 = (pos_y+1)*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+2;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-1)*10+pos_x  ;
                    d2 = (pos_y-1)*10+pos_x-1;
                    d3 = (pos_y-2)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y-1)*10+pos_x  ;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y-1)*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y-2)*10+pos_x-1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-1;
                    l2 = (pos_y-1)*10+pos_x-2;
                    l3 = (pos_y+1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        `BLOCK_L:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x  ;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+2;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y-2)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+2;
                    r4 = 255;
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-2)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y-1)*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y-1)*10+pos_x  ;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y  )*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-2;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        `BLOCK_S:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y  )*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+2;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-1)*10+pos_x  ;
                    d2 = (pos_y-2)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x  ;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = (pos_y-1)*10+pos_x+2;
                    r4 = 255;
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-2)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-1;
                    l2 = (pos_y-1)*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y-1)*10+pos_x+1;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-2;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x  ;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        `BLOCK_T:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y-1)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255; 
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y-1)*10+pos_x-1;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y-1)*10+pos_x+1;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        `BLOCK_Z:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y  )*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-2;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y-1)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x  ;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+2;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = 255;
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = (pos_y-2)*10+pos_x+1;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y-1)*10+pos_x-1;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+1;
                    r2 = (pos_y-1)*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-2)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = (pos_y-1)*10+pos_x-2;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x  ;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        `BLOCK_I:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = (pos_y-1)*10+pos_x+1;
                    d4 = (pos_y-1)*10+pos_x+2;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = 255;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+3;
                    r2 = 255;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-3)*10+pos_x  ;
                    d2 = 255;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = (pos_y-1)*10+pos_x-1;
                    l4 = (pos_y-2)*10+pos_x-1;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = (pos_y-1)*10+pos_x+1;
                    r4 = (pos_y-2)*10+pos_x+1;
                end
                `BLOCK_STATUS_2:begin
                    d1 = (pos_y-1)*10+pos_x-2;
                    d2 = (pos_y-1)*10+pos_x-1;
                    d3 = (pos_y-1)*10+pos_x  ;
                    d4 = (pos_y-1)*10+pos_x+1;
                    l1 = (pos_y  )*10+pos_x-3;
                    l2 = 255;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = 255;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = 255;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+2)*10+pos_x-1;
                    l2 = (pos_y+1)*10+pos_x-1;
                    l3 = (pos_y  )*10+pos_x-1;
                    l4 = (pos_y-1)*10+pos_x-1;
                    r1 = (pos_y+2)*10+pos_x+1;
                    r2 = (pos_y+1)*10+pos_x+1;
                    r3 = (pos_y  )*10+pos_x+1;
                    r4 = (pos_y-1)*10+pos_x+1;
                end
                default:begin end
            endcase
        end
        `BLOCK_O:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    d1 = (pos_y-1)*10+pos_x  ;
                    d2 = (pos_y-1)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-1;
                    l2 = (pos_y  )*10+pos_x-1;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+2;
                    r2 = (pos_y  )*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end 
                `BLOCK_STATUS_R:begin 
                    d1 = (pos_y-2)*10+pos_x  ;
                    d2 = (pos_y-2)*10+pos_x+1;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-1;
                    l2 = (pos_y-1)*10+pos_x-1;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+2;
                    r2 = (pos_y-1)*10+pos_x+2;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_2:begin 
                    d1 = (pos_y-2)*10+pos_x-1;
                    d2 = (pos_y-2)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y  )*10+pos_x-2;
                    l2 = (pos_y-1)*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y  )*10+pos_x+1;
                    r2 = (pos_y-1)*10+pos_x+1;
                    r3 = 255;
                    r4 = 255;
                end
                `BLOCK_STATUS_L:begin 
                    d1 = (pos_y-1)*10+pos_x-1;
                    d2 = (pos_y-1)*10+pos_x  ;
                    d3 = 255;
                    d4 = 255;
                    l1 = (pos_y+1)*10+pos_x-2;
                    l2 = (pos_y  )*10+pos_x-2;
                    l3 = 255;
                    l4 = 255;
                    r1 = (pos_y+1)*10+pos_x+1;
                    r2 = (pos_y  )*10+pos_x+1;
                    r3 = 255;
                    r4 = 255;
                end
                default:begin end
            endcase
        end
        default:begin end
    endcase
end

endmodule
module judgeIFContinueShift(left_en,right_en,down_en,block,status,pos_x,pos_y,block_exist);
input [2:0]block;
input [1:0]status;
input [4:0]pos_x,pos_y;
input [199:0]block_exist;
output reg down_en;
output reg left_en;
output reg right_en;
wire [7:0] d1,d2,d3,d4,l1,l2,l3,l4,r1,r2,r3,r4;
setting_touch_point stp (.d1(d1),.d2(d2),.d3(d3),.d4(d4),.l1(l1),.l2(l2),.l3(l3),.l4(l4),
                         .r1(r1),.r2(r2),.r3(r3),.r4(r4),.block(block),.status(status),.pos_x(pos_x),.pos_y(pos_y));
always@(*)begin
    case(block)
        `BLOCK_I:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    down_en = (pos_y == 0)?0:(!block_exist[d1]&&!block_exist[d2]&&!block_exist[d3]&&!block_exist[d4])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1])?1:0;
                    right_en = (pos_x == 7)?0:(!block_exist[r1])?1:0;
                end 
                `BLOCK_STATUS_R:begin 
                    down_en = (pos_y == 2)?0:(!block_exist[d1])?1:0;
                    left_en = (pos_x == 0)?0:(!block_exist[l1]&&!block_exist[l2]&&!block_exist[l3]&&!block_exist[l4])?1:0;
                    right_en = (pos_x == 9)?0:(!block_exist[r1]&&!block_exist[r2]&&!block_exist[r3]&&!block_exist[r4])?1:0;
                end
                `BLOCK_STATUS_2:begin
                    down_en = (pos_y == 0)?0:(!block_exist[d1]&&!block_exist[d2]&&!block_exist[d3]&&!block_exist[d4])?1:0;
                    left_en = (pos_x == 2)?0:(!block_exist[l1])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1])?1:0; 
                end
                `BLOCK_STATUS_L:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1])?1:0;
                    left_en = (pos_x == 0)?0:(!block_exist[l1]&&!block_exist[l2]&&!block_exist[l3]&&!block_exist[l4])?1:0;
                    right_en = (pos_x == 9)?0:(!block_exist[r1]&&!block_exist[r2]&&!block_exist[r3]&&!block_exist[r4])?1:0;
                end
                default :begin end
            endcase
        end
        `BLOCK_O:begin
            case(status)
                `BLOCK_STATUS_0:begin 
                    down_en = (pos_y == 0)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 0)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end 
                `BLOCK_STATUS_R:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 0)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end
                `BLOCK_STATUS_2:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 9)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end
                `BLOCK_STATUS_L:begin 
                    down_en = (pos_y == 0)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 9)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end
                default :begin end
            endcase
        end
        default:begin 
            case(status)
                `BLOCK_STATUS_0:begin
                    down_en = (pos_y == 0)?0:(!block_exist[d1]&&!block_exist[d2]&&!block_exist[d3])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end 
                `BLOCK_STATUS_R:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 0)?0:(!block_exist[l1]&&!block_exist[l2]&&!block_exist[l3])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1]&&!block_exist[r2]&&!block_exist[r3])?1:0;
                end
                `BLOCK_STATUS_2:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1]&&!block_exist[d2]&&!block_exist[d3])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1]&&!block_exist[l2])?1:0;
                    right_en = (pos_x == 8)?0:(!block_exist[r1]&&!block_exist[r2])?1:0;
                end
                `BLOCK_STATUS_L:begin 
                    down_en = (pos_y == 1)?0:(!block_exist[d1]&&!block_exist[d2])?1:0;
                    left_en = (pos_x == 1)?0:(!block_exist[l1]&&!block_exist[l2]&&!block_exist[l3])?1:0;
                    right_en = (pos_x == 9)?0:(!block_exist[r1]&&!block_exist[r2]&&!block_exist[r3])?1:0;
                end
                default :begin end
            endcase     
        end
    endcase
end

endmodule
module find_rows_should_be_earsed(row,block_exist);
output reg [19:0]row;
input [199:0]block_exist;
always@(*)begin
    row[0] = block_exist[0]&&block_exist[1]&&block_exist[2]&&block_exist[3]&&block_exist[4]&&block_exist[5]&&block_exist[6]&&block_exist[7]&&block_exist[8]&&block_exist[9];
    row[1] = block_exist[10]&&block_exist[11]&&block_exist[12]&&block_exist[13]&&block_exist[14]&&block_exist[15]&&block_exist[16]&&block_exist[17]&&block_exist[18]&&block_exist[19];
    row[2] = block_exist[20]&&block_exist[21]&&block_exist[22]&&block_exist[23]&&block_exist[24]&&block_exist[25]&&block_exist[26]&&block_exist[27]&&block_exist[28]&&block_exist[29];
    row[3] = block_exist[30]&&block_exist[31]&&block_exist[32]&&block_exist[33]&&block_exist[34]&&block_exist[35]&&block_exist[36]&&block_exist[37]&&block_exist[38]&&block_exist[39];
    row[4] = block_exist[40]&&block_exist[41]&&block_exist[42]&&block_exist[43]&&block_exist[44]&&block_exist[45]&&block_exist[46]&&block_exist[47]&&block_exist[48]&&block_exist[49];
    row[5] = block_exist[50]&&block_exist[51]&&block_exist[52]&&block_exist[53]&&block_exist[54]&&block_exist[55]&&block_exist[56]&&block_exist[57]&&block_exist[58]&&block_exist[59];
    row[6] = block_exist[60]&&block_exist[61]&&block_exist[62]&&block_exist[63]&&block_exist[64]&&block_exist[65]&&block_exist[66]&&block_exist[67]&&block_exist[68]&&block_exist[69];
    row[7] = block_exist[70]&&block_exist[71]&&block_exist[72]&&block_exist[73]&&block_exist[74]&&block_exist[75]&&block_exist[76]&&block_exist[77]&&block_exist[78]&&block_exist[79];
    row[8] = block_exist[80]&&block_exist[81]&&block_exist[82]&&block_exist[83]&&block_exist[84]&&block_exist[85]&&block_exist[86]&&block_exist[87]&&block_exist[88]&&block_exist[89];
    row[9] = block_exist[90]&&block_exist[91]&&block_exist[92]&&block_exist[93]&&block_exist[94]&&block_exist[95]&&block_exist[96]&&block_exist[97]&&block_exist[98]&&block_exist[99];
    row[10] = block_exist[100]&&block_exist[101]&&block_exist[102]&&block_exist[103]&&block_exist[104]&&block_exist[105]&&block_exist[106]&&block_exist[107]&&block_exist[108]&&block_exist[109];
    row[11] = block_exist[110]&&block_exist[111]&&block_exist[112]&&block_exist[113]&&block_exist[114]&&block_exist[115]&&block_exist[116]&&block_exist[117]&&block_exist[118]&&block_exist[119];
    row[12] = block_exist[120]&&block_exist[121]&&block_exist[122]&&block_exist[123]&&block_exist[124]&&block_exist[125]&&block_exist[126]&&block_exist[127]&&block_exist[128]&&block_exist[129];
    row[13] = block_exist[130]&&block_exist[131]&&block_exist[132]&&block_exist[133]&&block_exist[134]&&block_exist[135]&&block_exist[136]&&block_exist[137]&&block_exist[138]&&block_exist[139];
    row[14] = block_exist[140]&&block_exist[141]&&block_exist[142]&&block_exist[143]&&block_exist[144]&&block_exist[145]&&block_exist[146]&&block_exist[147]&&block_exist[148]&&block_exist[149];
    row[15] = block_exist[150]&&block_exist[151]&&block_exist[152]&&block_exist[153]&&block_exist[154]&&block_exist[155]&&block_exist[156]&&block_exist[157]&&block_exist[158]&&block_exist[159];
    row[16] = block_exist[160]&&block_exist[161]&&block_exist[162]&&block_exist[163]&&block_exist[164]&&block_exist[165]&&block_exist[166]&&block_exist[167]&&block_exist[168]&&block_exist[169];
    row[17] = block_exist[170]&&block_exist[171]&&block_exist[172]&&block_exist[173]&&block_exist[174]&&block_exist[175]&&block_exist[176]&&block_exist[177]&&block_exist[178]&&block_exist[179];
    row[18] = block_exist[180]&&block_exist[181]&&block_exist[182]&&block_exist[183]&&block_exist[184]&&block_exist[185]&&block_exist[186]&&block_exist[187]&&block_exist[188]&&block_exist[189];
    row[19] = block_exist[190]&&block_exist[191]&&block_exist[192]&&block_exist[193]&&block_exist[194]&&block_exist[195]&&block_exist[196]&&block_exist[197]&&block_exist[198]&&block_exist[199];
end
endmodule

module eraseROW(row1,row2,row3,row4,check_finish,eraseROW_en,block_exist,clk,rst);
input rst;
input clk;
input [199:0]block_exist;
input eraseROW_en;
output reg [4:0]row1,row2,row3,row4;
wire [19:0] row;

reg [4:0]state;
reg [2:0]count;
output reg check_finish;

reg [4:0] tmp_state;
reg [2:0] tmp_count;
reg [4:0] tmp_row1,tmp_row2,tmp_row3,tmp_row4;
reg tmp_check_finish;
parameter [4:0] CHECK_ROW1 = 5'b00000;
parameter [4:0] CHECK_ROW2 = 5'b00001;
parameter [4:0] CHECK_ROW3 = 5'b00010;
parameter [4:0] CHECK_ROW4 = 5'b00011;
parameter [4:0] CHECK_ROW5 = 5'b00100;
parameter [4:0] CHECK_ROW6 = 5'b00101;
parameter [4:0] CHECK_ROW7 = 5'b00110;
parameter [4:0] CHECK_ROW8 = 5'b00111;
parameter [4:0] CHECK_ROW9 = 5'b01000;
parameter [4:0] CHECK_ROW10 = 5'b01001;
parameter [4:0] CHECK_ROW11 = 5'b01010;
parameter [4:0] CHECK_ROW12 = 5'b01011;
parameter [4:0] CHECK_ROW13 = 5'b01100;
parameter [4:0] CHECK_ROW14 = 5'b01101;
parameter [4:0] CHECK_ROW15 = 5'b01110;
parameter [4:0] CHECK_ROW16 = 5'b01111;
parameter [4:0] CHECK_ROW17 = 5'b10000;
parameter [4:0] CHECK_ROW18 = 5'b10001;
parameter [4:0] CHECK_ROW19 = 5'b10010;
parameter [4:0] CHECK_ROW20 = 5'b10011;
parameter [4:0] INIT = 5'b10100; 
parameter [4:0] FINISH = 5'b10101;

find_rows_should_be_earsed frsbe (.row(row),.block_exist(block_exist));

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= INIT;
        count <= 0;
        row1 <= 20;
        row2 <= 20;
        row3 <= 20;
        row4 <= 20;
        check_finish <= 0;
    end
    else begin
        state <= tmp_state;
        count <= tmp_count;
        row1 <= tmp_row1;
        row2 <= tmp_row2;
        row3 <= tmp_row3;
        row4 <= tmp_row4;
        check_finish <= tmp_check_finish;
    end
end
always@(*)begin
    tmp_state = state;
    tmp_count = count;
    tmp_row1 = row1;
    tmp_row2 = row2;
    tmp_row3 = row3;
    tmp_row4 = row4;
    tmp_check_finish = check_finish;
    case(state)
        INIT:begin
            tmp_state = (eraseROW_en)?CHECK_ROW1:INIT;
            tmp_count = (eraseROW_en)?0:count;
            tmp_row1 = (eraseROW_en)?20:row1;
            tmp_row2 = (eraseROW_en)?20:row2;
            tmp_row3 = (eraseROW_en)?20:row3;
            tmp_row4 = (eraseROW_en)?20:row4;
            tmp_check_finish = 0;
        end
        CHECK_ROW1:begin
            tmp_state = CHECK_ROW2;
            tmp_count = (row[0]==1)?count+1:count;
            if(row[0]==1)begin
                case(count)
                    0:tmp_row1 = 0;
                    1:tmp_row2 = 0;
                    2:tmp_row3 = 0;
                    3:tmp_row4 = 0;
                    default: begin end
                endcase
            end
        end
        CHECK_ROW2:begin
            tmp_state = CHECK_ROW3;
            tmp_count = (row[1]==1)?count+1:count;
            if(row[1]==1)begin
                case(count)
                    0:tmp_row1 = 1;
                    1:tmp_row2 = 1;
                    2:tmp_row3 = 1;
                    3:tmp_row4 = 1;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW3:begin
            tmp_state = CHECK_ROW4;
            tmp_count = (row[2]==1)?count+1:count;
            if(row[2]==1)begin
                case(count)
                    0:tmp_row1 = 2;
                    1:tmp_row2 = 2;
                    2:tmp_row3 = 2;
                    3:tmp_row4 = 2;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW4:begin
            tmp_state = CHECK_ROW5;
            tmp_count = (row[3]==1)?count+1:count;
            if(row[3]==1)begin
                case(count)
                    0:tmp_row1 = 3;
                    1:tmp_row2 = 3;
                    2:tmp_row3 = 3;
                    3:tmp_row4 = 3;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW5:begin
            tmp_state = CHECK_ROW6;
            tmp_count = (row[4]==1)?count+1:count;
            if(row[4]==1)begin
                case(count)
                    0:tmp_row1 = 4;
                    1:tmp_row2 = 4;
                    2:tmp_row3 = 4;
                    3:tmp_row4 = 4;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW6:begin
            tmp_state = CHECK_ROW7;
            tmp_count = (row[5]==1)?count+1:count;
            if(row[5]==1)begin
                case(count)
                    0:tmp_row1 = 5;
                    1:tmp_row2 = 5;
                    2:tmp_row3 = 5;
                    3:tmp_row4 = 5;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW7:begin
            tmp_state = CHECK_ROW8;
            tmp_count = (row[6]==1)?count+1:count;
            if(row[6]==1)begin
                case(count)
                    0:tmp_row1 = 6;
                    1:tmp_row2 = 6;
                    2:tmp_row3 = 6;
                    3:tmp_row4 = 6;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW8:begin
            tmp_state = CHECK_ROW9;
            tmp_count = (row[7]==1)?count+1:count;
            if(row[7]==1)begin
                case(count)
                    0:tmp_row1 = 7;
                    1:tmp_row2 = 7;
                    2:tmp_row3 = 7;
                    3:tmp_row4 = 7;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW9:begin
            tmp_state = CHECK_ROW10;
            tmp_count = (row[8]==1)?count+1:count;
            if(row[8]==1)begin
                case(count)
                    0:tmp_row1 = 8;
                    1:tmp_row2 = 8;
                    2:tmp_row3 = 8;
                    3:tmp_row4 = 8;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW10:begin
            tmp_state = CHECK_ROW11;
            tmp_count = (row[9]==1)?count+1:count;
            if(row[9]==1)begin
                case(count)
                    0:tmp_row1 = 9;
                    1:tmp_row2 = 9;
                    2:tmp_row3 = 9;
                    3:tmp_row4 = 9;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW11:begin
            tmp_state = CHECK_ROW12;
            tmp_count = (row[10]==1)?count+1:count;
            if(row[10]==1)begin
                case(count)
                    0:tmp_row1 = 10;
                    1:tmp_row2 = 10;
                    2:tmp_row3 = 10;
                    3:tmp_row4 = 10;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW12:begin
            tmp_state = CHECK_ROW13;
            tmp_count = (row[11]==1)?count+1:count;
            if(row[11]==1)begin
                case(count)
                    0:tmp_row1 = 11;
                    1:tmp_row2 = 11;
                    2:tmp_row3 = 11;
                    3:tmp_row4 = 11;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW13:begin
            tmp_state = CHECK_ROW14;
            tmp_count = (row[12]==1)?count+1:count;
            if(row[12]==1)begin
                case(count)
                    0:tmp_row1 = 12;
                    1:tmp_row2 = 12;
                    2:tmp_row3 = 12;
                    3:tmp_row4 = 12;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW14:begin
            tmp_state = CHECK_ROW15;
            tmp_count = (row[13]==1)?count+1:count;
            if(row[13]==1)begin
                case(count)
                    0:tmp_row1 = 13;
                    1:tmp_row2 = 13;
                    2:tmp_row3 = 13;
                    3:tmp_row4 = 13;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW15:begin
            tmp_state = CHECK_ROW16;
            tmp_count = (row[14]==1)?count+1:count;
            if(row[14]==1)begin
                case(count)
                    0:tmp_row1 = 14;
                    1:tmp_row2 = 14;
                    2:tmp_row3 = 14;
                    3:tmp_row4 = 14;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW16:begin
            tmp_state = CHECK_ROW17;
            tmp_count = (row[15]==1)?count+1:count;
            if(row[15]==1)begin
                case(count)
                    0:tmp_row1 = 15;
                    1:tmp_row2 = 15;
                    2:tmp_row3 = 15;
                    3:tmp_row4 = 15;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW17:begin
            tmp_state = CHECK_ROW18;
            tmp_count = (row[16]==1)?count+1:count;
            if(row[16]==1)begin
                case(count)
                    0:tmp_row1 = 16;
                    1:tmp_row2 = 16;
                    2:tmp_row3 = 16;
                    3:tmp_row4 = 16;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW18:begin
            tmp_state = CHECK_ROW19;
            tmp_count = (row[17]==1)?count+1:count;
            if(row[17]==1)begin
                case(count)
                    0:tmp_row1 = 17;
                    1:tmp_row2 = 17;
                    2:tmp_row3 = 17;
                    3:tmp_row4 = 17;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW19:begin
            tmp_state = CHECK_ROW20;
            tmp_count = (row[18]==1)?count+1:count;
            if(row[18]==1)begin
                case(count)
                    0:tmp_row1 = 18;
                    1:tmp_row2 = 18;
                    2:tmp_row3 = 18;
                    3:tmp_row4 = 18;
                    default:begin end
                endcase
            end
        end
        CHECK_ROW20:begin
            tmp_state = FINISH;
            tmp_count = (row[19]==1)?count+1:count;
            if(row[19]==1)begin
                case(count)
                    0:tmp_row1 = 19;
                    1:tmp_row2 = 19;
                    2:tmp_row3 = 19;
                    3:tmp_row4 = 19;
                    default:begin end
                endcase
            end
        end
        FINISH:begin
            tmp_state = INIT;
            tmp_check_finish = 1;
        end
        default: begin end
    endcase
end
endmodule

/*module blockDownCAL(b1,b2,b3,b4,CALfinish,clk,rst,row1,row2,row3,row4,blockDownCAL_en);
output reg[199:0]b1,b2,b3,b4;
output reg CALfinish;
input clk,rst;
input [4:0]row1,row2,row3,row4;
input blockDownCAL_en;

reg [2:0]state;
reg [2:0]tmp_state;
reg [199:0]tmp_b1,tmp_b2,tmp_b3,tmp_b4;
reg tmp_CALfinish;

parameter [2:0] INIT = 3'b000;
parameter [2:0] ROW1 = 3'b001;
parameter [2:0] ROW2 = 3'b010;
parameter [2:0] ROW3 = 3'b011;
parameter [2:0] ROW4 = 3'b100;
parameter [2:0] FINISH = 3'b101;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= INIT;
        b1 <= 0;
        b2 <= 0;
        b3 <= 0;
        b4 <= 0;
        CALfinish <=0;
    end
    else begin
        state <= tmp_state;
        b1 <= tmp_b1;
        b2 <= tmp_b2;
        b3 <= tmp_b3;
        b4 <= tmp_b4;
        CALfinish <= tmp_CALfinish;
    end
end
always@(*)begin
    tmp_state = state;
    tmp_b1 = b1;
    tmp_b2 = b2;
    tmp_b3 = b3;
    tmp_b4 = b4;
    tmp_CALfinish = CALfinish;
    case(state)
        INIT:begin
            tmp_state = (blockDownCAL_en)?ROW1:INIT;
            tmp_b1 = (blockDownCAL_en)?0:b1;
            tmp_b2 = (blockDownCAL_en)?0:b2;
            tmp_b3 = (blockDownCAL_en)?0:b3;
            tmp_b4 = (blockDownCAL_en)?0:b4;
            tmp_CALfinish = 0;
        end
        ROW1:begin
            tmp_state = ROW2;
            case(row1)
                0:begin
                    tmp_b1[199:10] = 190'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                1:begin
                    tmp_b1[199:20] = 180'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                2:begin
                    tmp_b1[199:30] = 170'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                3:begin
                    tmp_b1[199:40] = 160'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                4:begin
                    tmp_b1[199:50] = 150'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                5:begin
                    tmp_b1[199:60] = 140'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                6:begin
                    tmp_b1[199:70] = 130'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                7:begin
                    tmp_b1[199:80] = 120'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                8:begin
                    tmp_b1[199:90] = 110'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                9:begin
                    tmp_b1[199:100] = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                10:begin
                    tmp_b1[199:110] = 90'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                11:begin
                    tmp_b1[199:120] = 80'b11111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                12:begin
                    tmp_b1[199:130] = 70'b1111111111111111111111111111111111111111111111111111111111111111111111;
                end
                13:begin
                    tmp_b1[199:140] = 60'b111111111111111111111111111111111111111111111111111111111111;
                end
                14:begin
                    tmp_b1[199:150] = 50'b11111111111111111111111111111111111111111111111111;
                end
                15:begin
                    tmp_b1[199:160] = 40'b1111111111111111111111111111111111111111;
                end
                16:begin
                    tmp_b1[199:170] = 30'b111111111111111111111111111111;
                end
                17:begin
                    tmp_b1[199:180] = 20'b11111111111111111111;
                end
                18:begin
                    tmp_b1[199:190] = 10'b1111111111;
                end
                default:begin         
                end
            endcase
        end
        ROW2:begin
            tmp_state = ROW3;
            case(row2)
                0:begin
                    tmp_b2[199:10] = 190'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                1:begin
                    tmp_b2[199:20] = 180'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                2:begin
                    tmp_b2[199:30] = 170'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                3:begin
                    tmp_b2[199:40] = 160'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                4:begin
                    tmp_b2[199:50] = 150'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                5:begin
                    tmp_b2[199:60] = 140'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                6:begin
                    tmp_b2[199:70] = 130'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                7:begin
                    tmp_b2[199:80] = 120'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                8:begin
                    tmp_b2[199:90] = 110'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                9:begin
                    tmp_b2[199:100] = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                10:begin
                    tmp_b2[199:110] = 90'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                11:begin
                    tmp_b2[199:120] = 80'b11111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                12:begin
                    tmp_b2[199:130] = 70'b1111111111111111111111111111111111111111111111111111111111111111111111;
                end
                13:begin
                    tmp_b2[199:140] = 60'b111111111111111111111111111111111111111111111111111111111111;
                end
                14:begin
                    tmp_b2[199:150] = 50'b11111111111111111111111111111111111111111111111111;
                end
                15:begin
                    tmp_b2[199:160] = 40'b1111111111111111111111111111111111111111;
                end
                16:begin
                    tmp_b2[199:170] = 30'b111111111111111111111111111111;
                end
                17:begin
                    tmp_b2[199:180] = 20'b11111111111111111111;
                end
                18:begin
                    tmp_b2[199:190] = 10'b1111111111;
                end
                default:begin
                    
                end
            endcase
        end
        ROW3:begin
            tmp_state = ROW4;
            case(row3)
                0:begin
                    tmp_b3[199:10] = 190'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                1:begin
                    tmp_b3[199:20] = 180'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                2:begin
                    tmp_b3[199:30] = 170'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                3:begin
                    tmp_b3[199:40] = 160'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                4:begin
                    tmp_b3[199:50] = 150'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                5:begin
                    tmp_b3[199:60] = 140'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                6:begin
                    tmp_b3[199:70] = 130'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                7:begin
                    tmp_b3[199:80] = 120'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                8:begin
                    tmp_b3[199:90] = 110'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                9:begin
                    tmp_b3[199:100] = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                10:begin
                    tmp_b3[199:110] = 90'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                11:begin
                    tmp_b3[199:120] = 80'b11111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                12:begin
                    tmp_b3[199:130] = 70'b1111111111111111111111111111111111111111111111111111111111111111111111;
                end
                13:begin
                    tmp_b3[199:140] = 60'b111111111111111111111111111111111111111111111111111111111111;
                end
                14:begin
                    tmp_b3[199:150] = 50'b11111111111111111111111111111111111111111111111111;
                end
                15:begin
                    tmp_b3[199:160] = 40'b1111111111111111111111111111111111111111;
                end
                16:begin
                    tmp_b3[199:170] = 30'b111111111111111111111111111111;
                end
                17:begin
                    tmp_b3[199:180] = 20'b11111111111111111111;
                end
                18:begin
                    tmp_b3[199:190] = 10'b1111111111;
                end
            endcase
        end
        ROW4:begin
            tmp_state = FINISH;
            case(row4)
                0:begin
                    tmp_b4[199:10] = 190'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                1:begin
                    tmp_b4[199:20] = 180'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                2:begin
                    tmp_b4[199:30] = 170'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                3:begin
                    tmp_b4[199:40] = 160'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                4:begin
                    tmp_b4[199:50] = 150'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                5:begin
                    tmp_b4[199:60] = 140'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                6:begin
                    tmp_b4[199:70] = 130'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                7:begin
                    tmp_b4[199:80] = 120'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                8:begin
                    tmp_b4[199:90] = 110'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                9:begin
                    tmp_b4[199:100] = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                10:begin
                    tmp_b4[199:110] = 90'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                11:begin
                    tmp_b4[199:120] = 80'b11111111111111111111111111111111111111111111111111111111111111111111111111111111;
                end
                12:begin
                    tmp_b4[199:130] = 70'b1111111111111111111111111111111111111111111111111111111111111111111111;
                end
                13:begin
                    tmp_b4[199:140] = 60'b111111111111111111111111111111111111111111111111111111111111;
                end
                14:begin
                    tmp_b4[199:150] = 50'b11111111111111111111111111111111111111111111111111;
                end
                15:begin
                    tmp_b4[199:160] = 40'b1111111111111111111111111111111111111111;
                end
                16:begin
                    tmp_b4[199:170] = 30'b111111111111111111111111111111;
                end
                17:begin
                    tmp_b4[199:180] = 20'b11111111111111111111;
                end
                18:begin
                    tmp_b4[199:190] = 10'b1111111111;
                end
            endcase
        end
        FINISH:begin
            tmp_state = INIT;
            tmp_CALfinish = 1;
        end
        default:begin      
        end
    endcase
end
endmodule
module erased_row_block_pos(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39,row1,row2,row3,row4);

output [7:0]p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39;
input [4:0]row1,row2,row3,row4;
assign p0 = (row1 == 20)?row1*10+0:200;
assign p1 = (row1 == 20)?row1*10+1:200;
assign p2 = (row1 == 20)?row1*10+2:200;
assign p3 = (row1 == 20)?row1*10+3:200;
assign p4 = (row1 == 20)?row1*10+4:200;
assign p5 = (row1 == 20)?row1*10+5:200;
assign p6 = (row1 == 20)?row1*10+6:200;
assign p7 = (row1 == 20)?row1*10+7:200;
assign p8 = (row1 == 20)?row1*10+8:200;
assign p9 = (row1 == 20)?row1*10+9:200;
assign p10 = (row2 == 20)?row2*10+0:200;
assign p11 = (row2 == 20)?row2*10+1:200;
assign p12 = (row2 == 20)?row2*10+2:200;
assign p13 = (row2 == 20)?row2*10+3:200;
assign p14 = (row2 == 20)?row2*10+4:200;
assign p15 = (row2 == 20)?row2*10+5:200;
assign p16 = (row2 == 20)?row2*10+6:200;
assign p17 = (row2 == 20)?row2*10+7:200;
assign p18 = (row2 == 20)?row2*10+8:200;
assign p19 = (row2 == 20)?row2*10+9:200;
assign p20 = (row3 == 20)?row3*10+0:200;
assign p21 = (row3 == 20)?row3*10+1:200;
assign p22 = (row3 == 20)?row3*10+2:200;
assign p23 = (row3 == 20)?row3*10+3:200;
assign p24 = (row3 == 20)?row3*10+4:200;
assign p25 = (row3 == 20)?row3*10+5:200;
assign p26 = (row3 == 20)?row3*10+6:200;
assign p27 = (row3 == 20)?row3*10+7:200;
assign p28 = (row3 == 20)?row3*10+8:200;
assign p29 = (row3 == 20)?row3*10+9:200;
assign p30 = (row4 == 20)?row4*10+0:200;
assign p31 = (row4 == 20)?row4*10+1:200;
assign p32 = (row4 == 20)?row4*10+2:200;
assign p33 = (row4 == 20)?row4*10+3:200;
assign p34 = (row4 == 20)?row4*10+4:200;
assign p35 = (row4 == 20)?row4*10+5:200;
assign p36 = (row4 == 20)?row4*10+6:200;
assign p37 = (row4 == 20)?row4*10+7:200;
assign p38 = (row4 == 20)?row4*10+8:200;
assign p39 = (row4 == 20)?row4*10+9:200;
endmodule

module cal_down_new_position(
np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,
np20,np21,np22,np23,np24,np25,np26,np27,np28,np29,np30,np31,np32,np33,np34,np35,np36,np37,np38,np39,
np40,np41,np42,np43,np44,np45,np46,np47,np48,np49,np50,np51,np52,np53,np54,np55,np56,np57,np58,np59,
np60,np61,np62,np63,np64,np65,np66,np67,np68,np69,np70,np71,np72,np73,np74,np75,np76,np77,np78,np79,
np80,np81,np82,np83,np84,np85,np86,np87,np88,np89,np90,np91,np92,np93,np94,np95,np96,np97,np98,np99,
np100,np101,np102,np103,np104,np105,np106,np107,np108,np109,np110,np111,np112,np113,np114,np115,np116,np117,np118,np119,
np120,np121,np122,np123,np124,np125,np126,np127,np128,np129,np130,np131,np132,np133,np134,np135,np136,np137,np138,np139,
np140,np141,np142,np143,np144,np145,np146,np147,np148,np149,np150,np151,np152,np153,np154,np155,np156,np157,np158,np159,
np160,np161,np162,np163,np164,np165,np166,np167,np168,np169,np170,np171,np172,np173,np174,np175,np176,np177,np178,np179,
np180,np181,np182,np183,np184,np185,np186,np187,np188,np189,np190,np191,np192,np193,np194,np195,np196,np197,np198,np199,
b1,b2,b3,b4);

input [199:0]b1,b2,b3,b4;

output [7:0]np10,np11,np12,np13,np14,np15,np16,np17,np18,np19;
output [7:0]np20,np21,np22,np23,np24,np25,np26,np27,np28,np29,np30,np31,np32,np33,np34,np35,np36,np37,np38,np39;
output [7:0]np40,np41,np42,np43,np44,np45,np46,np47,np48,np49,np50,np51,np52,np53,np54,np55,np56,np57,np58,np59;
output [7:0]np60,np61,np62,np63,np64,np65,np66,np67,np68,np69,np70,np71,np72,np73,np74,np75,np76,np77,np78,np79;
output [7:0]np80,np81,np82,np83,np84,np85,np86,np87,np88,np89,np90,np91,np92,np93,np94,np95,np96,np97,np98,np99;
output [7:0]np100,np101,np102,np103,np104,np105,np106,np107,np108,np109,np110,np111,np112,np113,np114,np115,np116,np117,np118,np119;
output [7:0]np120,np121,np122,np123,np124,np125,np126,np127,np128,np129,np130,np131,np132,np133,np134,np135,np136,np137,np138,np139;
output [7:0]np140,np141,np142,np143,np144,np145,np146,np147,np148,np149,np150,np151,np152,np153,np154,np155,np156,np157,np158,np159;
output [7:0]np160,np161,np162,np163,np164,np165,np166,np167,np168,np169,np170,np171,np172,np173,np174,np175,np176,np177,np178,np179;
output [7:0]np180,np181,np182,np183,np184,np185,np186,np187,np188,np189,np190,np191,np192,np193,np194,np195,np196,np197,np198,np199;

assign np10 = 10-(b1[10]+b2[10]+b3[10]+b4[10])*10;
assign np11 = 11-(b1[11]+b2[11]+b3[11]+b4[11])*10;
assign np12 = 12-(b1[12]+b2[12]+b3[12]+b4[12])*10;
assign np13 = 13-(b1[13]+b2[13]+b3[13]+b4[13])*10;
assign np14 = 14-(b1[14]+b2[14]+b3[14]+b4[14])*10;
assign np15 = 15-(b1[15]+b2[15]+b3[15]+b4[15])*10;
assign np16 = 16-(b1[16]+b2[16]+b3[16]+b4[16])*10;
assign np17 = 17-(b1[17]+b2[17]+b3[17]+b4[17])*10;
assign np18 = 18-(b1[18]+b2[18]+b3[18]+b4[18])*10;
assign np19 = 19-(b1[19]+b2[19]+b3[19]+b4[19])*10;
assign np20 = 20-(b1[20]+b2[20]+b3[20]+b4[20])*10;
assign np21 = 21-(b1[21]+b2[21]+b3[21]+b4[21])*10;
assign np22 = 22-(b1[22]+b2[22]+b3[22]+b4[22])*10;
assign np23 = 23-(b1[23]+b2[23]+b3[23]+b4[23])*10;
assign np24 = 24-(b1[24]+b2[24]+b3[24]+b4[24])*10;
assign np25 = 25-(b1[25]+b2[25]+b3[25]+b4[25])*10;
assign np26 = 26-(b1[26]+b2[26]+b3[26]+b4[26])*10;
assign np27 = 27-(b1[27]+b2[27]+b3[27]+b4[27])*10;
assign np28 = 28-(b1[28]+b2[28]+b3[28]+b4[28])*10;
assign np29 = 29-(b1[29]+b2[29]+b3[29]+b4[29])*10;
assign np30 = 30-(b1[30]+b2[30]+b3[30]+b4[30])*10;
assign np31 = 31-(b1[31]+b2[31]+b3[31]+b4[31])*10;
assign np32 = 32-(b1[32]+b2[32]+b3[32]+b4[32])*10;
assign np33 = 33-(b1[33]+b2[33]+b3[33]+b4[33])*10;
assign np34 = 34-(b1[34]+b2[34]+b3[34]+b4[34])*10;
assign np35 = 35-(b1[35]+b2[35]+b3[35]+b4[35])*10;
assign np36 = 36-(b1[36]+b2[36]+b3[36]+b4[36])*10;
assign np37 = 37-(b1[37]+b2[37]+b3[37]+b4[37])*10;
assign np38 = 38-(b1[38]+b2[38]+b3[38]+b4[38])*10;
assign np39 = 39-(b1[39]+b2[39]+b3[39]+b4[39])*10;
assign np40 = 40-(b1[40]+b2[40]+b3[40]+b4[40])*10;
assign np41 = 41-(b1[41]+b2[41]+b3[41]+b4[41])*10;
assign np42 = 42-(b1[42]+b2[42]+b3[42]+b4[42])*10;
assign np43 = 43-(b1[43]+b2[43]+b3[43]+b4[43])*10;
assign np44 = 44-(b1[44]+b2[44]+b3[44]+b4[44])*10;
assign np45 = 45-(b1[45]+b2[45]+b3[45]+b4[45])*10;
assign np46 = 46-(b1[46]+b2[46]+b3[46]+b4[46])*10;
assign np47 = 47-(b1[47]+b2[47]+b3[47]+b4[47])*10;
assign np48 = 48-(b1[48]+b2[48]+b3[48]+b4[48])*10;
assign np49 = 49-(b1[49]+b2[49]+b3[49]+b4[49])*10;
assign np50 = 50-(b1[50]+b2[50]+b3[50]+b4[50])*10;
assign np51 = 51-(b1[51]+b2[51]+b3[51]+b4[51])*10;
assign np52 = 52-(b1[52]+b2[52]+b3[52]+b4[52])*10;
assign np53 = 53-(b1[53]+b2[53]+b3[53]+b4[53])*10;
assign np54 = 54-(b1[54]+b2[54]+b3[54]+b4[54])*10;
assign np55 = 55-(b1[55]+b2[55]+b3[55]+b4[55])*10;
assign np56 = 56-(b1[56]+b2[56]+b3[56]+b4[56])*10;
assign np57 = 57-(b1[57]+b2[57]+b3[57]+b4[57])*10;
assign np58 = 58-(b1[58]+b2[58]+b3[58]+b4[58])*10;
assign np59 = 59-(b1[59]+b2[59]+b3[59]+b4[59])*10;
assign np60 = 60-(b1[60]+b2[60]+b3[60]+b4[60])*10;
assign np61 = 61-(b1[61]+b2[61]+b3[61]+b4[61])*10;
assign np62 = 62-(b1[62]+b2[62]+b3[62]+b4[62])*10;
assign np63 = 63-(b1[63]+b2[63]+b3[63]+b4[63])*10;
assign np64 = 64-(b1[64]+b2[64]+b3[64]+b4[64])*10;
assign np65 = 65-(b1[65]+b2[65]+b3[65]+b4[65])*10;
assign np66 = 66-(b1[66]+b2[66]+b3[66]+b4[66])*10;
assign np67 = 67-(b1[67]+b2[67]+b3[67]+b4[67])*10;
assign np68 = 68-(b1[68]+b2[68]+b3[68]+b4[68])*10;
assign np69 = 69-(b1[69]+b2[69]+b3[69]+b4[69])*10;
assign np70 = 70-(b1[70]+b2[70]+b3[70]+b4[70])*10;
assign np71 = 71-(b1[71]+b2[71]+b3[71]+b4[71])*10;
assign np72 = 72-(b1[72]+b2[72]+b3[72]+b4[72])*10;
assign np73 = 73-(b1[73]+b2[73]+b3[73]+b4[73])*10;
assign np74 = 74-(b1[74]+b2[74]+b3[74]+b4[74])*10;
assign np75 = 75-(b1[75]+b2[75]+b3[75]+b4[75])*10;
assign np76 = 76-(b1[76]+b2[76]+b3[76]+b4[76])*10;
assign np77 = 77-(b1[77]+b2[77]+b3[77]+b4[77])*10;
assign np78 = 78-(b1[78]+b2[78]+b3[78]+b4[78])*10;
assign np79 = 79-(b1[79]+b2[79]+b3[79]+b4[79])*10;
assign np80 = 80-(b1[80]+b2[80]+b3[80]+b4[80])*10;
assign np81 = 81-(b1[81]+b2[81]+b3[81]+b4[81])*10;
assign np82 = 82-(b1[82]+b2[82]+b3[82]+b4[82])*10;
assign np83 = 83-(b1[83]+b2[83]+b3[83]+b4[83])*10;
assign np84 = 84-(b1[84]+b2[84]+b3[84]+b4[84])*10;
assign np85 = 85-(b1[85]+b2[85]+b3[85]+b4[85])*10;
assign np86 = 86-(b1[86]+b2[86]+b3[86]+b4[86])*10;
assign np87 = 87-(b1[87]+b2[87]+b3[87]+b4[87])*10;
assign np88 = 88-(b1[88]+b2[88]+b3[88]+b4[88])*10;
assign np89 = 89-(b1[89]+b2[89]+b3[89]+b4[89])*10;
assign np90 = 90-(b1[90]+b2[90]+b3[90]+b4[90])*10;
assign np91 = 91-(b1[91]+b2[91]+b3[91]+b4[91])*10;
assign np92 = 92-(b1[92]+b2[92]+b3[92]+b4[92])*10;
assign np93 = 93-(b1[93]+b2[93]+b3[93]+b4[93])*10;
assign np94 = 94-(b1[94]+b2[94]+b3[94]+b4[94])*10;
assign np95 = 95-(b1[95]+b2[95]+b3[95]+b4[95])*10;
assign np96 = 96-(b1[96]+b2[96]+b3[96]+b4[96])*10;
assign np97 = 97-(b1[97]+b2[97]+b3[97]+b4[97])*10;
assign np98 = 98-(b1[98]+b2[98]+b3[98]+b4[98])*10;
assign np99 = 99-(b1[99]+b2[99]+b3[99]+b4[99])*10;
assign np100 = 100-(b1[100]+b2[100]+b3[100]+b4[100])*10;
assign np101 = 101-(b1[101]+b2[101]+b3[101]+b4[101])*10;
assign np102 = 102-(b1[102]+b2[102]+b3[102]+b4[102])*10;
assign np103 = 103-(b1[103]+b2[103]+b3[103]+b4[103])*10;
assign np104 = 104-(b1[104]+b2[104]+b3[104]+b4[104])*10;
assign np105 = 105-(b1[105]+b2[105]+b3[105]+b4[105])*10;
assign np106 = 106-(b1[106]+b2[106]+b3[106]+b4[106])*10;
assign np107 = 107-(b1[107]+b2[107]+b3[107]+b4[107])*10;
assign np108 = 108-(b1[108]+b2[108]+b3[108]+b4[108])*10;
assign np109 = 109-(b1[109]+b2[109]+b3[109]+b4[109])*10;
assign np110 = 110-(b1[110]+b2[110]+b3[110]+b4[110])*10;
assign np111 = 111-(b1[111]+b2[111]+b3[111]+b4[111])*10;
assign np112 = 112-(b1[112]+b2[112]+b3[112]+b4[112])*10;
assign np113 = 113-(b1[113]+b2[113]+b3[113]+b4[113])*10;
assign np114 = 114-(b1[114]+b2[114]+b3[114]+b4[114])*10;
assign np115 = 115-(b1[115]+b2[115]+b3[115]+b4[115])*10;
assign np116 = 116-(b1[116]+b2[116]+b3[116]+b4[116])*10;
assign np117 = 117-(b1[117]+b2[117]+b3[117]+b4[117])*10;
assign np118 = 118-(b1[118]+b2[118]+b3[118]+b4[118])*10;
assign np119 = 119-(b1[119]+b2[119]+b3[119]+b4[119])*10;
assign np120 = 120-(b1[120]+b2[120]+b3[120]+b4[120])*10;
assign np121 = 121-(b1[121]+b2[121]+b3[121]+b4[121])*10;
assign np122 = 122-(b1[122]+b2[122]+b3[122]+b4[122])*10;
assign np123 = 123-(b1[123]+b2[123]+b3[123]+b4[123])*10;
assign np124 = 124-(b1[124]+b2[124]+b3[124]+b4[124])*10;
assign np125 = 125-(b1[125]+b2[125]+b3[125]+b4[125])*10;
assign np126 = 126-(b1[126]+b2[126]+b3[126]+b4[126])*10;
assign np127 = 127-(b1[127]+b2[127]+b3[127]+b4[127])*10;
assign np128 = 128-(b1[128]+b2[128]+b3[128]+b4[128])*10;
assign np129 = 129-(b1[129]+b2[129]+b3[129]+b4[129])*10;
assign np130 = 130-(b1[130]+b2[130]+b3[130]+b4[130])*10;
assign np131 = 131-(b1[131]+b2[131]+b3[131]+b4[131])*10;
assign np132 = 132-(b1[132]+b2[132]+b3[132]+b4[132])*10;
assign np133 = 133-(b1[133]+b2[133]+b3[133]+b4[133])*10;
assign np134 = 134-(b1[134]+b2[134]+b3[134]+b4[134])*10;
assign np135 = 135-(b1[135]+b2[135]+b3[135]+b4[135])*10;
assign np136 = 136-(b1[136]+b2[136]+b3[136]+b4[136])*10;
assign np137 = 137-(b1[137]+b2[137]+b3[137]+b4[137])*10;
assign np138 = 138-(b1[138]+b2[138]+b3[138]+b4[138])*10;
assign np139 = 139-(b1[139]+b2[139]+b3[139]+b4[139])*10;
assign np140 = 140-(b1[140]+b2[140]+b3[140]+b4[140])*10;
assign np141 = 141-(b1[141]+b2[141]+b3[141]+b4[141])*10;
assign np142 = 142-(b1[142]+b2[142]+b3[142]+b4[142])*10;
assign np143 = 143-(b1[143]+b2[143]+b3[143]+b4[143])*10;
assign np144 = 144-(b1[144]+b2[144]+b3[144]+b4[144])*10;
assign np145 = 145-(b1[145]+b2[145]+b3[145]+b4[145])*10;
assign np146 = 146-(b1[146]+b2[146]+b3[146]+b4[146])*10;
assign np147 = 147-(b1[147]+b2[147]+b3[147]+b4[147])*10;
assign np148 = 148-(b1[148]+b2[148]+b3[148]+b4[148])*10;
assign np149 = 149-(b1[149]+b2[149]+b3[149]+b4[149])*10;
assign np150 = 150-(b1[150]+b2[150]+b3[150]+b4[150])*10;
assign np151 = 151-(b1[151]+b2[151]+b3[151]+b4[151])*10;
assign np152 = 152-(b1[152]+b2[152]+b3[152]+b4[152])*10;
assign np153 = 153-(b1[153]+b2[153]+b3[153]+b4[153])*10;
assign np154 = 154-(b1[154]+b2[154]+b3[154]+b4[154])*10;
assign np155 = 155-(b1[155]+b2[155]+b3[155]+b4[155])*10;
assign np156 = 156-(b1[156]+b2[156]+b3[156]+b4[156])*10;
assign np157 = 157-(b1[157]+b2[157]+b3[157]+b4[157])*10;
assign np158 = 158-(b1[158]+b2[158]+b3[158]+b4[158])*10;
assign np159 = 159-(b1[159]+b2[159]+b3[159]+b4[159])*10;
assign np160 = 160-(b1[160]+b2[160]+b3[160]+b4[160])*10;
assign np161 = 161-(b1[161]+b2[161]+b3[161]+b4[161])*10;
assign np162 = 162-(b1[162]+b2[162]+b3[162]+b4[162])*10;
assign np163 = 163-(b1[163]+b2[163]+b3[163]+b4[163])*10;
assign np164 = 164-(b1[164]+b2[164]+b3[164]+b4[164])*10;
assign np165 = 165-(b1[165]+b2[165]+b3[165]+b4[165])*10;
assign np166 = 166-(b1[166]+b2[166]+b3[166]+b4[166])*10;
assign np167 = 167-(b1[167]+b2[167]+b3[167]+b4[167])*10;
assign np168 = 168-(b1[168]+b2[168]+b3[168]+b4[168])*10;
assign np169 = 169-(b1[169]+b2[169]+b3[169]+b4[169])*10;
assign np170 = 170-(b1[170]+b2[170]+b3[170]+b4[170])*10;
assign np171 = 171-(b1[171]+b2[171]+b3[171]+b4[171])*10;
assign np172 = 172-(b1[172]+b2[172]+b3[172]+b4[172])*10;
assign np173 = 173-(b1[173]+b2[173]+b3[173]+b4[173])*10;
assign np174 = 174-(b1[174]+b2[174]+b3[174]+b4[174])*10;
assign np175 = 175-(b1[175]+b2[175]+b3[175]+b4[175])*10;
assign np176 = 176-(b1[176]+b2[176]+b3[176]+b4[176])*10;
assign np177 = 177-(b1[177]+b2[177]+b3[177]+b4[177])*10;
assign np178 = 178-(b1[178]+b2[178]+b3[178]+b4[178])*10;
assign np179 = 179-(b1[179]+b2[179]+b3[179]+b4[179])*10;
assign np180 = 180-(b1[180]+b2[180]+b3[180]+b4[180])*10;
assign np181 = 181-(b1[181]+b2[181]+b3[181]+b4[181])*10;
assign np182 = 182-(b1[182]+b2[182]+b3[182]+b4[182])*10;
assign np183 = 183-(b1[183]+b2[183]+b3[183]+b4[183])*10;
assign np184 = 184-(b1[184]+b2[184]+b3[184]+b4[184])*10;
assign np185 = 185-(b1[185]+b2[185]+b3[185]+b4[185])*10;
assign np186 = 186-(b1[186]+b2[186]+b3[186]+b4[186])*10;
assign np187 = 187-(b1[187]+b2[187]+b3[187]+b4[187])*10;
assign np188 = 188-(b1[188]+b2[188]+b3[188]+b4[188])*10;
assign np189 = 189-(b1[189]+b2[189]+b3[189]+b4[189])*10;
assign np190 = 190-(b1[190]+b2[190]+b3[190]+b4[190])*10;
assign np191 = 191-(b1[191]+b2[191]+b3[191]+b4[191])*10;
assign np192 = 192-(b1[192]+b2[192]+b3[192]+b4[192])*10;
assign np193 = 193-(b1[193]+b2[193]+b3[193]+b4[193])*10;
assign np194 = 194-(b1[194]+b2[194]+b3[194]+b4[194])*10;
assign np195 = 195-(b1[195]+b2[195]+b3[195]+b4[195])*10;
assign np196 = 196-(b1[196]+b2[196]+b3[196]+b4[196])*10;
assign np197 = 197-(b1[197]+b2[197]+b3[197]+b4[197])*10;
assign np198 = 198-(b1[198]+b2[198]+b3[198]+b4[198])*10;
assign np199 = 199-(b1[199]+b2[199]+b3[199]+b4[199])*10;
endmodule
*/

module putBlock(change_en,write_en,address,w_color,block_exist,generate_block,block_type,block_status,rst,clk,turn_right,turn_left,shift_left,shift_right,clkBlockDown,color,led);
input generate_block;
input rst;
input clk;
input [2:0]block_type;
input [1:0]block_status;
input turn_right,turn_left;
input shift_right,shift_left;
input clkBlockDown;
input [2399:0]color;
output reg[199:0]change_en;
output reg write_en;
output reg [7:0]address;
output reg [11:0]w_color;
output reg[199:0]block_exist;

wire [11:0]last_w_color; // redundant
reg [2:0]state;
reg [2:0]block;
reg [1:0]status;
reg [4:0]pos_x,pos_y;
reg [4:0]last_pos_x,last_pos_y;
reg start_write;
reg block_settle ;
//reg write_new_block;

reg [2:0]tmp_state;
reg [2:0]tmp_block;
reg [1:0]tmp_status;
reg [4:0]tmp_pos_x,tmp_pos_y;
reg [4:0]tmp_last_pos_x,tmp_last_pos_y;
reg tmp_start_write;
reg tmp_block_settle;
//reg tmp_write_new_block;

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

reg [199:0]tmp_block_exist;
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

parameter [8:0] DOWN_POS10 = 9'b000010000;
parameter [8:0] DOWN_POS11 = 9'b000010001;
parameter [8:0] DOWN_POS12 = 9'b000010010;
parameter [8:0] DOWN_POS13 = 9'b000010011;
parameter [8:0] DOWN_POS14 = 9'b000010100;
parameter [8:0] DOWN_POS15 = 9'b000010101;
parameter [8:0] DOWN_POS16 = 9'b000010110;
parameter [8:0] DOWN_POS17 = 9'b000010111;
parameter [8:0] DOWN_POS18 = 9'b000011000;
parameter [8:0] DOWN_POS19 = 9'b000011001;
parameter [8:0] DOWN_POS20 = 9'b000011010;
parameter [8:0] DOWN_POS21 = 9'b000011011;
parameter [8:0] DOWN_POS22 = 9'b000011100;
parameter [8:0] DOWN_POS23 = 9'b000011101;
parameter [8:0] DOWN_POS24 = 9'b000011110;
parameter [8:0] DOWN_POS25 = 9'b000011111;
parameter [8:0] DOWN_POS26 = 9'b000100000;
parameter [8:0] DOWN_POS27 = 9'b000100001;
parameter [8:0] DOWN_POS28 = 9'b000100010;
parameter [8:0] DOWN_POS29 = 9'b000100011;
parameter [8:0] DOWN_POS30 = 9'b000100100;
parameter [8:0] DOWN_POS31 = 9'b000100101;
parameter [8:0] DOWN_POS32 = 9'b000100110;
parameter [8:0] DOWN_POS33 = 9'b000100111;
parameter [8:0] DOWN_POS34 = 9'b000101000;
parameter [8:0] DOWN_POS35 = 9'b000101001;
parameter [8:0] DOWN_POS36 = 9'b000101010;
parameter [8:0] DOWN_POS37 = 9'b000101011;
parameter [8:0] DOWN_POS38 = 9'b000101100;
parameter [8:0] DOWN_POS39 = 9'b000101101;
parameter [8:0] DOWN_POS40 = 9'b000101110;
parameter [8:0] DOWN_POS41 = 9'b000101111;
parameter [8:0] DOWN_POS42 = 9'b000110000;
parameter [8:0] DOWN_POS43 = 9'b000110001;
parameter [8:0] DOWN_POS44 = 9'b000110010;
parameter [8:0] DOWN_POS45 = 9'b000110011;
parameter [8:0] DOWN_POS46 = 9'b000110100;
parameter [8:0] DOWN_POS47 = 9'b000110101;
parameter [8:0] DOWN_POS48 = 9'b000110110;
parameter [8:0] DOWN_POS49 = 9'b000110111;
parameter [8:0] DOWN_POS50 = 9'b000111000;
parameter [8:0] DOWN_POS51 = 9'b000111001;
parameter [8:0] DOWN_POS52 = 9'b000111010;
parameter [8:0] DOWN_POS53 = 9'b000111011;
parameter [8:0] DOWN_POS54 = 9'b000111100;
parameter [8:0] DOWN_POS55 = 9'b000111101;
parameter [8:0] DOWN_POS56 = 9'b000111110;
parameter [8:0] DOWN_POS57 = 9'b000111111;
parameter [8:0] DOWN_POS58 = 9'b001000000;
parameter [8:0] DOWN_POS59 = 9'b001000001;
parameter [8:0] DOWN_POS60 = 9'b001000010;
parameter [8:0] DOWN_POS61 = 9'b001000011;
parameter [8:0] DOWN_POS62 = 9'b001000100;
parameter [8:0] DOWN_POS63 = 9'b001000101;
parameter [8:0] DOWN_POS64 = 9'b001000110;
parameter [8:0] DOWN_POS65 = 9'b001000111;
parameter [8:0] DOWN_POS66 = 9'b001001000;
parameter [8:0] DOWN_POS67 = 9'b001001001;
parameter [8:0] DOWN_POS68 = 9'b001001010;
parameter [8:0] DOWN_POS69 = 9'b001001011;
parameter [8:0] DOWN_POS70 = 9'b001001100;
parameter [8:0] DOWN_POS71 = 9'b001001101;
parameter [8:0] DOWN_POS72 = 9'b001001110;
parameter [8:0] DOWN_POS73 = 9'b001001111;
parameter [8:0] DOWN_POS74 = 9'b001010000;
parameter [8:0] DOWN_POS75 = 9'b001010001;
parameter [8:0] DOWN_POS76 = 9'b001010010;
parameter [8:0] DOWN_POS77 = 9'b001010011;
parameter [8:0] DOWN_POS78 = 9'b001010100;
parameter [8:0] DOWN_POS79 = 9'b001010101;
parameter [8:0] DOWN_POS80 = 9'b001010110;
parameter [8:0] DOWN_POS81 = 9'b001010111;
parameter [8:0] DOWN_POS82 = 9'b001011000;
parameter [8:0] DOWN_POS83 = 9'b001011001;
parameter [8:0] DOWN_POS84 = 9'b001011010;
parameter [8:0] DOWN_POS85 = 9'b001011011;
parameter [8:0] DOWN_POS86 = 9'b001011100;
parameter [8:0] DOWN_POS87 = 9'b001011101;
parameter [8:0] DOWN_POS88 = 9'b001011110;
parameter [8:0] DOWN_POS89 = 9'b001011111;
parameter [8:0] DOWN_POS90 = 9'b001100000;
parameter [8:0] DOWN_POS91 = 9'b001100001;
parameter [8:0] DOWN_POS92 = 9'b001100010;
parameter [8:0] DOWN_POS93 = 9'b001100011;
parameter [8:0] DOWN_POS94 = 9'b001100100;
parameter [8:0] DOWN_POS95 = 9'b001100101;
parameter [8:0] DOWN_POS96 = 9'b001100110;
parameter [8:0] DOWN_POS97 = 9'b001100111;
parameter [8:0] DOWN_POS98 = 9'b001101000;
parameter [8:0] DOWN_POS99 = 9'b001101001;
parameter [8:0] DOWN_POS100 = 9'b001101010;
parameter [8:0] DOWN_POS101 = 9'b001101011;
parameter [8:0] DOWN_POS102 = 9'b001101100;
parameter [8:0] DOWN_POS103 = 9'b001101101;
parameter [8:0] DOWN_POS104 = 9'b001101110;
parameter [8:0] DOWN_POS105 = 9'b001101111;
parameter [8:0] DOWN_POS106 = 9'b001110000;
parameter [8:0] DOWN_POS107 = 9'b001110001;
parameter [8:0] DOWN_POS108 = 9'b001110010;
parameter [8:0] DOWN_POS109 = 9'b001110011;
parameter [8:0] DOWN_POS110 = 9'b001110100;
parameter [8:0] DOWN_POS111 = 9'b001110101;
parameter [8:0] DOWN_POS112 = 9'b001110110;
parameter [8:0] DOWN_POS113 = 9'b001110111;
parameter [8:0] DOWN_POS114 = 9'b001111000;
parameter [8:0] DOWN_POS115 = 9'b001111001;
parameter [8:0] DOWN_POS116 = 9'b001111010;
parameter [8:0] DOWN_POS117 = 9'b001111011;
parameter [8:0] DOWN_POS118 = 9'b001111100;
parameter [8:0] DOWN_POS119 = 9'b001111101;
parameter [8:0] DOWN_POS120 = 9'b001111110;
parameter [8:0] DOWN_POS121 = 9'b001111111;
parameter [8:0] DOWN_POS122 = 9'b010000000;
parameter [8:0] DOWN_POS123 = 9'b010000001;
parameter [8:0] DOWN_POS124 = 9'b010000010;
parameter [8:0] DOWN_POS125 = 9'b010000011;
parameter [8:0] DOWN_POS126 = 9'b010000100;
parameter [8:0] DOWN_POS127 = 9'b010000101;
parameter [8:0] DOWN_POS128 = 9'b010000110;
parameter [8:0] DOWN_POS129 = 9'b010000111;
parameter [8:0] DOWN_POS130 = 9'b010001000;
parameter [8:0] DOWN_POS131 = 9'b010001001;
parameter [8:0] DOWN_POS132 = 9'b010001010;
parameter [8:0] DOWN_POS133 = 9'b010001011;
parameter [8:0] DOWN_POS134 = 9'b010001100;
parameter [8:0] DOWN_POS135 = 9'b010001101;
parameter [8:0] DOWN_POS136 = 9'b010001110;
parameter [8:0] DOWN_POS137 = 9'b010001111;
parameter [8:0] DOWN_POS138 = 9'b010010000;
parameter [8:0] DOWN_POS139 = 9'b010010001;
parameter [8:0] DOWN_POS140 = 9'b010010010;
parameter [8:0] DOWN_POS141 = 9'b010010011;
parameter [8:0] DOWN_POS142 = 9'b010010100;
parameter [8:0] DOWN_POS143 = 9'b010010101;
parameter [8:0] DOWN_POS144 = 9'b010010110;
parameter [8:0] DOWN_POS145 = 9'b010010111;
parameter [8:0] DOWN_POS146 = 9'b010011000;
parameter [8:0] DOWN_POS147 = 9'b010011001;
parameter [8:0] DOWN_POS148 = 9'b010011010;
parameter [8:0] DOWN_POS149 = 9'b010011011;
parameter [8:0] DOWN_POS150 = 9'b010011100;
parameter [8:0] DOWN_POS151 = 9'b010011101;
parameter [8:0] DOWN_POS152 = 9'b010011110;
parameter [8:0] DOWN_POS153 = 9'b010011111;
parameter [8:0] DOWN_POS154 = 9'b010100000;
parameter [8:0] DOWN_POS155 = 9'b010100001;
parameter [8:0] DOWN_POS156 = 9'b010100010;
parameter [8:0] DOWN_POS157 = 9'b010100011;
parameter [8:0] DOWN_POS158 = 9'b010100100;
parameter [8:0] DOWN_POS159 = 9'b010100101;
parameter [8:0] DOWN_POS160 = 9'b010100110;
parameter [8:0] DOWN_POS161 = 9'b010100111;
parameter [8:0] DOWN_POS162 = 9'b010101000;
parameter [8:0] DOWN_POS163 = 9'b010101001;
parameter [8:0] DOWN_POS164 = 9'b010101010;
parameter [8:0] DOWN_POS165 = 9'b010101011;
parameter [8:0] DOWN_POS166 = 9'b010101100;
parameter [8:0] DOWN_POS167 = 9'b010101101;
parameter [8:0] DOWN_POS168 = 9'b010101110;
parameter [8:0] DOWN_POS169 = 9'b010101111;
parameter [8:0] DOWN_POS170 = 9'b010110000;
parameter [8:0] DOWN_POS171 = 9'b010110001;
parameter [8:0] DOWN_POS172 = 9'b010110010;
parameter [8:0] DOWN_POS173 = 9'b010110011;
parameter [8:0] DOWN_POS174 = 9'b010110100;
parameter [8:0] DOWN_POS175 = 9'b010110101;
parameter [8:0] DOWN_POS176 = 9'b010110110;
parameter [8:0] DOWN_POS177 = 9'b010110111;
parameter [8:0] DOWN_POS178 = 9'b010111000;
parameter [8:0] DOWN_POS179 = 9'b010111001;
parameter [8:0] DOWN_POS180 = 9'b010111010;
parameter [8:0] DOWN_POS181 = 9'b010111011;
parameter [8:0] DOWN_POS182 = 9'b010111100;
parameter [8:0] DOWN_POS183 = 9'b010111101;
parameter [8:0] DOWN_POS184 = 9'b010111110;
parameter [8:0] DOWN_POS185 = 9'b010111111;
parameter [8:0] DOWN_POS186 = 9'b011000000;
parameter [8:0] DOWN_POS187 = 9'b011000001;
parameter [8:0] DOWN_POS188 = 9'b011000010;
parameter [8:0] DOWN_POS189 = 9'b011000011;
parameter [8:0] DOWN_POS190 = 9'b011000100;
parameter [8:0] DOWN_POS191 = 9'b011000101;
parameter [8:0] DOWN_POS192 = 9'b011000110;
parameter [8:0] DOWN_POS193 = 9'b011000111;
parameter [8:0] DOWN_POS194 = 9'b011001000;
parameter [8:0] DOWN_POS195 = 9'b011001001;
parameter [8:0] DOWN_POS196 = 9'b011001010;
parameter [8:0] DOWN_POS197 = 9'b011001011;
parameter [8:0] DOWN_POS198 = 9'b011001100;
parameter [8:0] DOWN_POS199 = 9'b011001101;

parameter [8:0] SETTING_ADDRESS_POS10 = 9'b011001110;
parameter [8:0] SETTING_ADDRESS_POS11 = 9'b011001111;
parameter [8:0] SETTING_ADDRESS_POS12 = 9'b011010000;
parameter [8:0] SETTING_ADDRESS_POS13 = 9'b011010001;
parameter [8:0] SETTING_ADDRESS_POS14 = 9'b011010010;
parameter [8:0] SETTING_ADDRESS_POS15 = 9'b011010011;
parameter [8:0] SETTING_ADDRESS_POS16 = 9'b011010100;
parameter [8:0] SETTING_ADDRESS_POS17 = 9'b011010101;
parameter [8:0] SETTING_ADDRESS_POS18 = 9'b011010110;
parameter [8:0] SETTING_ADDRESS_POS19 = 9'b011010111;
parameter [8:0] SETTING_ADDRESS_POS20 = 9'b011011000;
parameter [8:0] SETTING_ADDRESS_POS21 = 9'b011011001;
parameter [8:0] SETTING_ADDRESS_POS22 = 9'b011011010;
parameter [8:0] SETTING_ADDRESS_POS23 = 9'b011011011;
parameter [8:0] SETTING_ADDRESS_POS24 = 9'b011011100;
parameter [8:0] SETTING_ADDRESS_POS25 = 9'b011011101;
parameter [8:0] SETTING_ADDRESS_POS26 = 9'b011011110;
parameter [8:0] SETTING_ADDRESS_POS27 = 9'b011011111;
parameter [8:0] SETTING_ADDRESS_POS28 = 9'b011100000;
parameter [8:0] SETTING_ADDRESS_POS29 = 9'b011100001;
parameter [8:0] SETTING_ADDRESS_POS30 = 9'b011100010;
parameter [8:0] SETTING_ADDRESS_POS31 = 9'b011100011;
parameter [8:0] SETTING_ADDRESS_POS32 = 9'b011100100;
parameter [8:0] SETTING_ADDRESS_POS33 = 9'b011100101;
parameter [8:0] SETTING_ADDRESS_POS34 = 9'b011100110;
parameter [8:0] SETTING_ADDRESS_POS35 = 9'b011100111;
parameter [8:0] SETTING_ADDRESS_POS36 = 9'b011101000;
parameter [8:0] SETTING_ADDRESS_POS37 = 9'b011101001;
parameter [8:0] SETTING_ADDRESS_POS38 = 9'b011101010;
parameter [8:0] SETTING_ADDRESS_POS39 = 9'b011101011;
parameter [8:0] SETTING_ADDRESS_POS40 = 9'b011101100;
parameter [8:0] SETTING_ADDRESS_POS41 = 9'b011101101;
parameter [8:0] SETTING_ADDRESS_POS42 = 9'b011101110;
parameter [8:0] SETTING_ADDRESS_POS43 = 9'b011101111;
parameter [8:0] SETTING_ADDRESS_POS44 = 9'b011110000;
parameter [8:0] SETTING_ADDRESS_POS45 = 9'b011110001;
parameter [8:0] SETTING_ADDRESS_POS46 = 9'b011110010;
parameter [8:0] SETTING_ADDRESS_POS47 = 9'b011110011;
parameter [8:0] SETTING_ADDRESS_POS48 = 9'b011110100;
parameter [8:0] SETTING_ADDRESS_POS49 = 9'b011110101;
parameter [8:0] SETTING_ADDRESS_POS50 = 9'b011110110;
parameter [8:0] SETTING_ADDRESS_POS51 = 9'b011110111;
parameter [8:0] SETTING_ADDRESS_POS52 = 9'b011111000;
parameter [8:0] SETTING_ADDRESS_POS53 = 9'b011111001;
parameter [8:0] SETTING_ADDRESS_POS54 = 9'b011111010;
parameter [8:0] SETTING_ADDRESS_POS55 = 9'b011111011;
parameter [8:0] SETTING_ADDRESS_POS56 = 9'b011111100;
parameter [8:0] SETTING_ADDRESS_POS57 = 9'b011111101;
parameter [8:0] SETTING_ADDRESS_POS58 = 9'b011111110;
parameter [8:0] SETTING_ADDRESS_POS59 = 9'b011111111;
parameter [8:0] SETTING_ADDRESS_POS60 = 9'b100000000;
parameter [8:0] SETTING_ADDRESS_POS61 = 9'b100000001;
parameter [8:0] SETTING_ADDRESS_POS62 = 9'b100000010;
parameter [8:0] SETTING_ADDRESS_POS63 = 9'b100000011;
parameter [8:0] SETTING_ADDRESS_POS64 = 9'b100000100;
parameter [8:0] SETTING_ADDRESS_POS65 = 9'b100000101;
parameter [8:0] SETTING_ADDRESS_POS66 = 9'b100000110;
parameter [8:0] SETTING_ADDRESS_POS67 = 9'b100000111;
parameter [8:0] SETTING_ADDRESS_POS68 = 9'b100001000;
parameter [8:0] SETTING_ADDRESS_POS69 = 9'b100001001;
parameter [8:0] SETTING_ADDRESS_POS70 = 9'b100001010;
parameter [8:0] SETTING_ADDRESS_POS71 = 9'b100001011;
parameter [8:0] SETTING_ADDRESS_POS72 = 9'b100001100;
parameter [8:0] SETTING_ADDRESS_POS73 = 9'b100001101;
parameter [8:0] SETTING_ADDRESS_POS74 = 9'b100001110;
parameter [8:0] SETTING_ADDRESS_POS75 = 9'b100001111;
parameter [8:0] SETTING_ADDRESS_POS76 = 9'b100010000;
parameter [8:0] SETTING_ADDRESS_POS77 = 9'b100010001;
parameter [8:0] SETTING_ADDRESS_POS78 = 9'b100010010;
parameter [8:0] SETTING_ADDRESS_POS79 = 9'b100010011;
parameter [8:0] SETTING_ADDRESS_POS80 = 9'b100010100;
parameter [8:0] SETTING_ADDRESS_POS81 = 9'b100010101;
parameter [8:0] SETTING_ADDRESS_POS82 = 9'b100010110;
parameter [8:0] SETTING_ADDRESS_POS83 = 9'b100010111;
parameter [8:0] SETTING_ADDRESS_POS84 = 9'b100011000;
parameter [8:0] SETTING_ADDRESS_POS85 = 9'b100011001;
parameter [8:0] SETTING_ADDRESS_POS86 = 9'b100011010;
parameter [8:0] SETTING_ADDRESS_POS87 = 9'b100011011;
parameter [8:0] SETTING_ADDRESS_POS88 = 9'b100011100;
parameter [8:0] SETTING_ADDRESS_POS89 = 9'b100011101;
parameter [8:0] SETTING_ADDRESS_POS90 = 9'b100011110;
parameter [8:0] SETTING_ADDRESS_POS91 = 9'b100011111;
parameter [8:0] SETTING_ADDRESS_POS92 = 9'b100100000;
parameter [8:0] SETTING_ADDRESS_POS93 = 9'b100100001;
parameter [8:0] SETTING_ADDRESS_POS94 = 9'b100100010;
parameter [8:0] SETTING_ADDRESS_POS95 = 9'b100100011;
parameter [8:0] SETTING_ADDRESS_POS96 = 9'b100100100;
parameter [8:0] SETTING_ADDRESS_POS97 = 9'b100100101;
parameter [8:0] SETTING_ADDRESS_POS98 = 9'b100100110;
parameter [8:0] SETTING_ADDRESS_POS99 = 9'b100100111;
parameter [8:0] SETTING_ADDRESS_POS100 = 9'b100101000;
parameter [8:0] SETTING_ADDRESS_POS101 = 9'b100101001;
parameter [8:0] SETTING_ADDRESS_POS102 = 9'b100101010;
parameter [8:0] SETTING_ADDRESS_POS103 = 9'b100101011;
parameter [8:0] SETTING_ADDRESS_POS104 = 9'b100101100;
parameter [8:0] SETTING_ADDRESS_POS105 = 9'b100101101;
parameter [8:0] SETTING_ADDRESS_POS106 = 9'b100101110;
parameter [8:0] SETTING_ADDRESS_POS107 = 9'b100101111;
parameter [8:0] SETTING_ADDRESS_POS108 = 9'b100110000;
parameter [8:0] SETTING_ADDRESS_POS109 = 9'b100110001;
parameter [8:0] SETTING_ADDRESS_POS110 = 9'b100110010;
parameter [8:0] SETTING_ADDRESS_POS111 = 9'b100110011;
parameter [8:0] SETTING_ADDRESS_POS112 = 9'b100110100;
parameter [8:0] SETTING_ADDRESS_POS113 = 9'b100110101;
parameter [8:0] SETTING_ADDRESS_POS114 = 9'b100110110;
parameter [8:0] SETTING_ADDRESS_POS115 = 9'b100110111;
parameter [8:0] SETTING_ADDRESS_POS116 = 9'b100111000;
parameter [8:0] SETTING_ADDRESS_POS117 = 9'b100111001;
parameter [8:0] SETTING_ADDRESS_POS118 = 9'b100111010;
parameter [8:0] SETTING_ADDRESS_POS119 = 9'b100111011;
parameter [8:0] SETTING_ADDRESS_POS120 = 9'b100111100;
parameter [8:0] SETTING_ADDRESS_POS121 = 9'b100111101;
parameter [8:0] SETTING_ADDRESS_POS122 = 9'b100111110;
parameter [8:0] SETTING_ADDRESS_POS123 = 9'b100111111;
parameter [8:0] SETTING_ADDRESS_POS124 = 9'b101000000;
parameter [8:0] SETTING_ADDRESS_POS125 = 9'b101000001;
parameter [8:0] SETTING_ADDRESS_POS126 = 9'b101000010;
parameter [8:0] SETTING_ADDRESS_POS127 = 9'b101000011;
parameter [8:0] SETTING_ADDRESS_POS128 = 9'b101000100;
parameter [8:0] SETTING_ADDRESS_POS129 = 9'b101000101;
parameter [8:0] SETTING_ADDRESS_POS130 = 9'b101000110;
parameter [8:0] SETTING_ADDRESS_POS131 = 9'b101000111;
parameter [8:0] SETTING_ADDRESS_POS132 = 9'b101001000;
parameter [8:0] SETTING_ADDRESS_POS133 = 9'b101001001;
parameter [8:0] SETTING_ADDRESS_POS134 = 9'b101001010;
parameter [8:0] SETTING_ADDRESS_POS135 = 9'b101001011;
parameter [8:0] SETTING_ADDRESS_POS136 = 9'b101001100;
parameter [8:0] SETTING_ADDRESS_POS137 = 9'b101001101;
parameter [8:0] SETTING_ADDRESS_POS138 = 9'b101001110;
parameter [8:0] SETTING_ADDRESS_POS139 = 9'b101001111;
parameter [8:0] SETTING_ADDRESS_POS140 = 9'b101010000;
parameter [8:0] SETTING_ADDRESS_POS141 = 9'b101010001;
parameter [8:0] SETTING_ADDRESS_POS142 = 9'b101010010;
parameter [8:0] SETTING_ADDRESS_POS143 = 9'b101010011;
parameter [8:0] SETTING_ADDRESS_POS144 = 9'b101010100;
parameter [8:0] SETTING_ADDRESS_POS145 = 9'b101010101;
parameter [8:0] SETTING_ADDRESS_POS146 = 9'b101010110;
parameter [8:0] SETTING_ADDRESS_POS147 = 9'b101010111;
parameter [8:0] SETTING_ADDRESS_POS148 = 9'b101011000;
parameter [8:0] SETTING_ADDRESS_POS149 = 9'b101011001;
parameter [8:0] SETTING_ADDRESS_POS150 = 9'b101011010;
parameter [8:0] SETTING_ADDRESS_POS151 = 9'b101011011;
parameter [8:0] SETTING_ADDRESS_POS152 = 9'b101011100;
parameter [8:0] SETTING_ADDRESS_POS153 = 9'b101011101;
parameter [8:0] SETTING_ADDRESS_POS154 = 9'b101011110;
parameter [8:0] SETTING_ADDRESS_POS155 = 9'b101011111;
parameter [8:0] SETTING_ADDRESS_POS156 = 9'b101100000;
parameter [8:0] SETTING_ADDRESS_POS157 = 9'b101100001;
parameter [8:0] SETTING_ADDRESS_POS158 = 9'b101100010;
parameter [8:0] SETTING_ADDRESS_POS159 = 9'b101100011;
parameter [8:0] SETTING_ADDRESS_POS160 = 9'b101100100;
parameter [8:0] SETTING_ADDRESS_POS161 = 9'b101100101;
parameter [8:0] SETTING_ADDRESS_POS162 = 9'b101100110;
parameter [8:0] SETTING_ADDRESS_POS163 = 9'b101100111;
parameter [8:0] SETTING_ADDRESS_POS164 = 9'b101101000;
parameter [8:0] SETTING_ADDRESS_POS165 = 9'b101101001;
parameter [8:0] SETTING_ADDRESS_POS166 = 9'b101101010;
parameter [8:0] SETTING_ADDRESS_POS167 = 9'b101101011;
parameter [8:0] SETTING_ADDRESS_POS168 = 9'b101101100;
parameter [8:0] SETTING_ADDRESS_POS169 = 9'b101101101;
parameter [8:0] SETTING_ADDRESS_POS170 = 9'b101101110;
parameter [8:0] SETTING_ADDRESS_POS171 = 9'b101101111;
parameter [8:0] SETTING_ADDRESS_POS172 = 9'b101110000;
parameter [8:0] SETTING_ADDRESS_POS173 = 9'b101110001;
parameter [8:0] SETTING_ADDRESS_POS174 = 9'b101110010;
parameter [8:0] SETTING_ADDRESS_POS175 = 9'b101110011;
parameter [8:0] SETTING_ADDRESS_POS176 = 9'b101110100;
parameter [8:0] SETTING_ADDRESS_POS177 = 9'b101110101;
parameter [8:0] SETTING_ADDRESS_POS178 = 9'b101110110;
parameter [8:0] SETTING_ADDRESS_POS179 = 9'b101110111;
parameter [8:0] SETTING_ADDRESS_POS180 = 9'b101111000;
parameter [8:0] SETTING_ADDRESS_POS181 = 9'b101111001;
parameter [8:0] SETTING_ADDRESS_POS182 = 9'b101111010;
parameter [8:0] SETTING_ADDRESS_POS183 = 9'b101111011;
parameter [8:0] SETTING_ADDRESS_POS184 = 9'b101111100;
parameter [8:0] SETTING_ADDRESS_POS185 = 9'b101111101;
parameter [8:0] SETTING_ADDRESS_POS186 = 9'b101111110;
parameter [8:0] SETTING_ADDRESS_POS187 = 9'b101111111;
parameter [8:0] SETTING_ADDRESS_POS188 = 9'b110000000;
parameter [8:0] SETTING_ADDRESS_POS189 = 9'b110000001;
parameter [8:0] SETTING_ADDRESS_POS190 = 9'b110000010;
parameter [8:0] SETTING_ADDRESS_POS191 = 9'b110000011;
parameter [8:0] SETTING_ADDRESS_POS192 = 9'b110000100;
parameter [8:0] SETTING_ADDRESS_POS193 = 9'b110000101;
parameter [8:0] SETTING_ADDRESS_POS194 = 9'b110000110;
parameter [8:0] SETTING_ADDRESS_POS195 = 9'b110000111;
parameter [8:0] SETTING_ADDRESS_POS196 = 9'b110001000;
parameter [8:0] SETTING_ADDRESS_POS197 = 9'b110001001;
parameter [8:0] SETTING_ADDRESS_POS198 = 9'b110001010;
parameter [8:0] SETTING_ADDRESS_POS199 = 9'b110001011;
parameter [8:0] DOWN_COMPLETE = 9'b110001100;

shape s_now  (.w_color(block_color),.color_pos1(color_pos1),.color_pos2(color_pos2),.color_pos3(color_pos3),
              .color_pos4(color_pos4),.block(block),.status(status),.pos_x(pos_x),.pos_y(pos_y));
shape s_last (.w_color(last_w_color),.color_pos1(last_pos1),.color_pos2(last_pos2),.color_pos3(last_pos3),
              .color_pos4(last_pos4),.block(block),.status(status),.pos_x(last_pos_x),.pos_y(last_pos_y));

one_pulse op1 (.push_onepulse(one_pulse_BlockDown),.rst(rst),.clk(clk),.push_debounced(clkBlockDown));

judgeIFContinueShift jich (.left_en(left_en),.right_en(right_en),.down_en(down_en),.block(block),.status(status),
                           .pos_x(pos_x),.pos_y(pos_y),.block_exist(block_exist));
random_num_generator rng (.q(rondom_num),.clk(clk),.rst(rst));

eraseROW er(.row1(er1),.row2(er2),.row3(er3),.row4(er4),.check_finish(check_finish),.eraseROW_en(eraseROW_en),.block_exist(block_exist),.clk(clk),.rst(rst));
assign led[9:5] = er1;
assign led [4:0] = er2;
wire [199:0]b1,b2,b3,b4;
wire CALfinish;
reg blockDownCAL_en;
reg tmp_blockDownCAL_en;
//blockDownCAL bdc (.b1(b1),.b2(b2),.b3(b3),.b4(b4),.CALfinish(CALfinish),.clk(clk),.rst(rst),.row1(er1),.row2(er2),.row3(er3),.row4(er4),.blockDownCAL_en(blockDownCAL_en));

reg start_eraseROW;
reg tmp_start_eraseROW;

/*
wire [7:0]p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39;

erased_row_block_pos erbp(.p0(p0),.p1(p1),.p2(p2),.p3(p3),.p4(p4),.p5(p5),.p6(p6),.p7(p7),.p8(p8),.p9(p9),.p10(p10),.p11(p11),.p12(p12),
                          .p13(p13),.p14(p14),.p15(p15),.p16(p16),.p17(p17),.p18(p18),.p19(p19),.p20(p20),.p21(p21),.p22(p22),.p23(p23),
                          .p24(p24),.p25(p25),.p26(p26),.p27(p27),.p28(p28),.p29(p29),.p30(p30),.p31(p31),.p32(p32),.p33(p33),.p34(p34),
                          .p35(p35),.p36(p36),.p37(p37),.p38(p38),.p39(p39),.row1(er1),.row2(er2),.row3(er3),.row4(er4));

wire[7:0]np10,np11,np12,np13,np14,np15,np16,np17,np18,np19;
wire[7:0]np20,np21,np22,np23,np24,np25,np26,np27,np28,np29,np30,np31,np32,np33,np34,np35,np36,np37,np38,np39;
wire[7:0]np40,np41,np42,np43,np44,np45,np46,np47,np48,np49,np50,np51,np52,np53,np54,np55,np56,np57,np58,np59;
wire[7:0]np60,np61,np62,np63,np64,np65,np66,np67,np68,np69,np70,np71,np72,np73,np74,np75,np76,np77,np78,np79;
wire[7:0]np80,np81,np82,np83,np84,np85,np86,np87,np88,np89,np90,np91,np92,np93,np94,np95,np96,np97,np98,np99;
wire[7:0]np100,np101,np102,np103,np104,np105,np106,np107,np108,np109,np110,np111,np112,np113,np114,np115,np116,np117,np118,np119;
wire[7:0]np120,np121,np122,np123,np124,np125,np126,np127,np128,np129,np130,np131,np132,np133,np134,np135,np136,np137,np138,np139;
wire[7:0]np140,np141,np142,np143,np144,np145,np146,np147,np148,np149,np150,np151,np152,np153,np154,np155,np156,np157,np158,np159;
wire[7:0]np160,np161,np162,np163,np164,np165,np166,np167,np168,np169,np170,np171,np172,np173,np174,np175,np176,np177,np178,np179;
wire[7:0]np180,np181,np182,np183,np184,np185,np186,np187,np188,np189,np190,np191,np192,np193,np194,np195,np196,np197,np198,np199;
cal_down_new_position cdnp(
.np10(np10),.np11(np11),.np12(np12),.np13(np13),.np14(np14),.np15(np15),.np16(np16),.np17(np17),.np18(np18),.np19(np19),
.np20(np20),.np21(np21),.np22(np22),.np23(np23),.np24(np24),.np25(np25),.np26(np26),.np27(np27),.np28(np28),.np29(np29),
.np30(np30),.np31(np31),.np32(np32),.np33(np33),.np34(np34),.np35(np35),.np36(np36),.np37(np37),.np38(np38),.np39(np39),
.np40(np40),.np41(np41),.np42(np42),.np43(np43),.np44(np44),.np45(np45),.np46(np46),.np47(np47),.np48(np48),.np49(np49),
.np50(np50),.np51(np51),.np52(np52),.np53(np53),.np54(np54),.np55(np55),.np56(np56),.np57(np57),.np58(np58),.np59(np59),
.np60(np60),.np61(np61),.np62(np62),.np63(np63),.np64(np64),.np65(np65),.np66(np66),.np67(np67),.np68(np68),.np69(np69),
.np70(np70),.np71(np71),.np72(np72),.np73(np73),.np74(np74),.np75(np75),.np76(np76),.np77(np77),.np78(np78),.np79(np79),
.np80(np80),.np81(np81),.np82(np82),.np83(np83),.np84(np84),.np85(np85),.np86(np86),.np87(np87),.np88(np88),.np89(np89),
.np90(np90),.np91(np91),.np92(np92),.np93(np93),.np94(np94),.np95(np95),.np96(np96),.np97(np97),.np98(np98),.np99(np99),
.np100(np100),.np101(np101),.np102(np102),.np103(np103),.np104(np104),.np105(np105),.np106(np106),.np107(np107),.np108(np108),.np109(np109),
.np110(np110),.np111(np111),.np112(np112),.np113(np113),.np114(np114),.np115(np115),.np116(np116),.np117(np117),.np118(np118),.np119(np119),
.np120(np120),.np121(np121),.np122(np122),.np123(np123),.np124(np124),.np125(np125),.np126(np126),.np127(np127),.np128(np128),.np129(np129),
.np130(np130),.np131(np131),.np132(np132),.np133(np133),.np134(np134),.np135(np135),.np136(np136),.np137(np137),.np138(np138),.np139(np139),
.np140(np140),.np141(np141),.np142(np142),.np143(np143),.np144(np144),.np145(np145),.np146(np146),.np147(np147),.np148(np148),.np149(np149),
.np150(np150),.np151(np151),.np152(np152),.np153(np153),.np154(np154),.np155(np155),.np156(np156),.np157(np157),.np158(np158),.np159(np159),
.np160(np160),.np161(np161),.np162(np162),.np163(np163),.np164(np164),.np165(np165),.np166(np166),.np167(np167),.np168(np168),.np169(np169),
.np170(np170),.np171(np171),.np172(np172),.np173(np173),.np174(np174),.np175(np175),.np176(np176),.np177(np177),.np178(np178),.np179(np179),
.np180(np180),.np181(np181),.np182(np182),.np183(np183),.np184(np184),.np185(np185),.np186(np186),.np187(np187),.np188(np188),.np189(np189),
.np190(np190),.np191(np191),.np192(np192),.np193(np193),.np194(np194),.np195(np195),.np196(np196),.np197(np197),.np198(np198),.np199(np199),
.b1(b1),.b2(b2),.b3(b3),.b4(b4));*/

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= `WAIT_BLOCK_EN;
        block <= 0;
        status <= 0;
        pos_x <= 0;
        pos_y <= 0;
        start_write <=0;
        last_pos_x <=0;
        last_pos_y <=0;
        block_settle <=0;
        eraseROW_en <= 0;
        blockDownCAL_en <=0;
        start_eraseROW <= 0;
        //write_new_block <= 0;
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
        block_settle <= tmp_block_settle;
        eraseROW_en <= tmp_eraseROW_en;
        blockDownCAL_en <= tmp_blockDownCAL_en;
        start_eraseROW <= tmp_start_eraseROW;
        //write_new_block <= tmp_write_new_block;
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
    tmp_block_settle = block_settle;
    tmp_eraseROW_en = eraseROW_en;
    tmp_blockDownCAL_en = blockDownCAL_en;
    tmp_start_eraseROW = start_eraseROW;
    //tmp_write_new_block = write_new_block;
    case(state)
        `WAIT_BLOCK_EN:begin
            if (generate_block)begin
                tmp_state = `BLOCK_DOWN;
                tmp_block = rondom_num%7;
                tmp_status = rondom_num%4;
                tmp_pos_x = 4;
                tmp_pos_y = 17;
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_block_settle = 1;
                tmp_eraseROW_en = 0;
                tmp_blockDownCAL_en = 0;
                tmp_start_eraseROW = 0;
                //tmp_write_new_block = 1;
            end
            else begin
                tmp_state = state;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 0; 
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y;
                tmp_block_settle = 0;
                tmp_eraseROW_en = 0;
                tmp_blockDownCAL_en = 0;
                tmp_start_eraseROW = 0;
                //tmp_write_new_block = 0;
            end
        end
        `BLOCK_DOWN:begin
            if(one_pulse_BlockDown)begin
                tmp_state = (down_en)?`SET_START_WRITE0:`BLOCK_SETTLE;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = (down_en)?pos_y-1:pos_y;                
                tmp_start_write = (down_en)?1:0;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y; 
                tmp_block_settle = 0;
                tmp_eraseROW_en = (down_en)?0:1; 
                //tmp_write_new_block = 0;
            end
            else if(shift_right)begin
                tmp_state = `SET_START_WRITE0;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = (right_en)?pos_x+1:pos_x;
                tmp_pos_y = pos_y;                
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y; 
                tmp_block_settle = 0;    
                //tmp_write_new_block = 0;
            end
            else if(shift_left)begin
                tmp_state = `SET_START_WRITE0;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = (left_en)?pos_x-1:pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_block_settle = 0;
                //tmp_write_new_block = 0;
            end
            else begin
                tmp_state = state;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 0;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_block_settle = 0;
                //tmp_write_new_block = 0;
            end
        end
        `SET_START_WRITE0:begin
            if(write_complete)begin
                tmp_state = `BLOCK_DOWN;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 0;
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y;
                tmp_block_settle = 0;
                //tmp_write_new_block = 0;
            end
            else begin
                tmp_state = state;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 0;
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y;
                tmp_block_settle = 0;
                //tmp_write_new_block = 0;
            end 
        end
        `BLOCK_SETTLE:begin
            if(check_finish)begin
                tmp_state = `WAIT_BLOCK_EN;
                tmp_blockDownCAL_en = 1;
            end
            else begin
                tmp_state = `BLOCK_SETTLE;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;                
                tmp_start_write = 0;
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y; 
                tmp_block_settle = 0;   
                tmp_eraseROW_en = 0; 
                //tmp_write_new_block = 0;
            end  
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
        change_en <= 0;
    end
    else begin
        write_state <= write_state;
        write_en <= write_en;
        address <= address;
        block_exist <= block_exist;
        w_color <= w_color;
        write_complete <= write_complete;
        change_en <= change_en;
        case(write_state)
            WAIT_WRITE:begin
                if(start_write)begin
                    write_state <= SET_BLOCK_EXIST1;
                    write_en <= 0;
                    address <= 0;
                    w_color <= 0;
                    write_complete <= 0;
                end
                // else if(write_new_block)begin
                //     write_state <= SET_BLOCK_EXIST2;
                //     write_en <= 0;
                //     address <= 0;
                //     w_color <= 0;
                //     write_complete <= 0;
                // end
                else if (start_eraseROW)begin
                    write_state <= ERASE_ROW1;
                    write_complete <= 0;
                end
                else begin
                    write_state <= WAIT_WRITE;
                    write_en <= 0;
                    address <= 0;
                    w_color <= 0;
                    write_complete <= 0;
                end      
            end
            SET_BLOCK_EXIST1:begin
                write_state <= TEST_STATE_1;
                block_exist[last_pos1] <=  0;
                block_exist[last_pos2] <=  0;
                block_exist[last_pos3] <=  0;
                block_exist[last_pos4] <=  0;
                block_exist[color_pos1] <= 1;
                block_exist[color_pos2] <= 1;
                block_exist[color_pos3] <= 1;
                block_exist[color_pos4] <= 1;
            end
            // SET_BLOCK_EXIST2:begin
            //     write_state <= TEST_STATE_1;
            //     block_exist[last_pos1] <=  0;
            //     block_exist[last_pos2] <=  0;
            //     block_exist[last_pos3] <=  0;
            //     block_exist[last_pos4] <=  0;
            //     block_exist[color_pos1] <= 1;
            //     block_exist[color_pos2] <= 1;
            //     block_exist[color_pos3] <= 1;
            //     block_exist[color_pos4] <= 1;
            // end
            TEST_STATE_1:begin
                write_state <= WRITE_POS1;
                write_en<=0;
                change_en[color_pos1] <= 1;
                address <= color_pos1;
            end
            WRITE_POS1:begin
                write_state <= TEST_STATE_2;
                write_en <= 1;
               // address <= color_pos1;
                w_color <= block_color;
                write_complete <= 0;
            end
            TEST_STATE_2:begin
                write_state <= WRITE_POS2;
                write_en<=0;
                change_en[color_pos1] <= 0;
                change_en[color_pos2] <= 1;
                address <= color_pos2;
            end
            WRITE_POS2:begin
                write_state <= TEST_STATE_3;
                write_en <= 1;
                //address <= color_pos2;
                w_color <=block_color;
                write_complete <= 0;
            end
            TEST_STATE_3:begin
                write_state <= WRITE_POS3;
                write_en<=0;
                change_en[color_pos2] <= 0;
                change_en[color_pos3] <= 1;
                address <= color_pos3;
            end
            WRITE_POS3:begin
                write_state <= TEST_STATE_4;
                write_en <= 1;
                //address <= color_pos3;
                w_color <=block_color;
                write_complete <= 0;
            end
            TEST_STATE_4:begin
                write_state <= WRITE_POS4;
                write_en<=0;
                change_en[color_pos3] <= 0;
                change_en[color_pos4] <= 1;
                address <= color_pos4;
            end
            WRITE_POS4:begin
                write_state <= WRITE_COMPLETE;
                write_en <= 1;
                //address <= color_pos4;
                w_color <=block_color;
                write_complete <= 0;
            end
            WRITE_COMPLETE:begin
                change_en[color_pos4] <= 0;
                write_state <= WAIT_WRITE;
                write_en <= 0;
                address <= 0;
                w_color <= 0;
                write_complete<=1;
            end

/*
            ERASE_ROW1:begin
                write_state <= ERASE_ROW2;
                if(er1!=20)begin
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
                if(er2!=20)begin
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
                if(er3!=20)begin
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
                write_state <= SETTING_ADDRESS_POS10;
                if(er4!=20)begin
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
            
SETTING_ADDRESS_POS10:begin
    write_state <= DOWN_POS10;
    write_en<=0;
    change_en[np10] <= 1;
    address <= np10;
end
DOWN_POS10:begin
    write_state <= SETTING_ADDRESS_POS11;
    write_en <= (block_exist[10])?1:0;
    w_color <= color[131:120];
    block_exist[10] <= 0;
    block_exist[np10]<= (block_exist[10])?1:0;
end
SETTING_ADDRESS_POS11:begin
    write_state <= DOWN_POS11;
    write_en<=0;
    change_en[np11] <= 1;
    address <= np11;
end
DOWN_POS11:begin
    write_state <= SETTING_ADDRESS_POS12;
    write_en <= (block_exist[11])?1:0;
    w_color <= color[143:132];
    block_exist[11] <= 0;
    block_exist[np11]<= (block_exist[11])?1:0;
end
SETTING_ADDRESS_POS12:begin
    write_state <= DOWN_POS12;
    write_en<=0;
    change_en[np12] <= 1;
    address <= np12;
end
DOWN_POS12:begin
    write_state <= SETTING_ADDRESS_POS13;
    write_en <= (block_exist[12])?1:0;
    w_color <= color[155:144];
    block_exist[12] <= 0;
    block_exist[np12]<= (block_exist[12])?1:0;
end
SETTING_ADDRESS_POS13:begin
    write_state <= DOWN_POS13;
    write_en<=0;
    change_en[np13] <= 1;
    address <= np13;
end
DOWN_POS13:begin
    write_state <= SETTING_ADDRESS_POS14;
    write_en <= (block_exist[13])?1:0;
    w_color <= color[167:156];
    block_exist[13] <= 0;
    block_exist[np13]<= (block_exist[13])?1:0;
end
SETTING_ADDRESS_POS14:begin
    write_state <= DOWN_POS14;
    write_en<=0;
    change_en[np14] <= 1;
    address <= np14;
end
DOWN_POS14:begin
    write_state <= SETTING_ADDRESS_POS15;
    write_en <= (block_exist[14])?1:0;
    w_color <= color[179:168];
    block_exist[14] <= 0;
    block_exist[np14]<= (block_exist[14])?1:0;
end
SETTING_ADDRESS_POS15:begin
    write_state <= DOWN_POS15;
    write_en<=0;
    change_en[np15] <= 1;
    address <= np15;
end
DOWN_POS15:begin
    write_state <= SETTING_ADDRESS_POS16;
    write_en <= (block_exist[15])?1:0;
    w_color <= color[191:180];
    block_exist[15] <= 0;
    block_exist[np15]<= (block_exist[15])?1:0;
end
SETTING_ADDRESS_POS16:begin
    write_state <= DOWN_POS16;
    write_en<=0;
    change_en[np16] <= 1;
    address <= np16;
end
DOWN_POS16:begin
    write_state <= SETTING_ADDRESS_POS17;
    write_en <= (block_exist[16])?1:0;
    w_color <= color[203:192];
    block_exist[16] <= 0;
    block_exist[np16]<= (block_exist[16])?1:0;
end
SETTING_ADDRESS_POS17:begin
    write_state <= DOWN_POS17;
    write_en<=0;
    change_en[np17] <= 1;
    address <= np17;
end
DOWN_POS17:begin
    write_state <= SETTING_ADDRESS_POS18;
    write_en <= (block_exist[17])?1:0;
    w_color <= color[215:204];
    block_exist[17] <= 0;
    block_exist[np17]<= (block_exist[17])?1:0;
end
SETTING_ADDRESS_POS18:begin
    write_state <= DOWN_POS18;
    write_en<=0;
    change_en[np18] <= 1;
    address <= np18;
end
DOWN_POS18:begin
    write_state <= SETTING_ADDRESS_POS19;
    write_en <= (block_exist[18])?1:0;
    w_color <= color[227:216];
    block_exist[18] <= 0;
    block_exist[np18]<= (block_exist[18])?1:0;
end
SETTING_ADDRESS_POS19:begin
    write_state <= DOWN_POS19;
    write_en<=0;
    change_en[np19] <= 1;
    address <= np19;
end
DOWN_POS19:begin
    write_state <= SETTING_ADDRESS_POS20;
    write_en <= (block_exist[19])?1:0;
    w_color <= color[239:228];
    block_exist[19] <= 0;
    block_exist[np19]<= (block_exist[19])?1:0;
end
SETTING_ADDRESS_POS20:begin
    write_state <= DOWN_POS20;
    write_en<=0;
    change_en[np20] <= 1;
    address <= np20;
end
DOWN_POS20:begin
    write_state <= SETTING_ADDRESS_POS21;
    write_en <= (block_exist[20])?1:0;
    w_color <= color[251:240];
    block_exist[20] <= 0;
    block_exist[np20]<= (block_exist[20])?1:0;
end
SETTING_ADDRESS_POS21:begin
    write_state <= DOWN_POS21;
    write_en<=0;
    change_en[np21] <= 1;
    address <= np21;
end
DOWN_POS21:begin
    write_state <= SETTING_ADDRESS_POS22;
    write_en <= (block_exist[21])?1:0;
    w_color <= color[263:252];
    block_exist[21] <= 0;
    block_exist[np21]<= (block_exist[21])?1:0;
end
SETTING_ADDRESS_POS22:begin
    write_state <= DOWN_POS22;
    write_en<=0;
    change_en[np22] <= 1;
    address <= np22;
end
DOWN_POS22:begin
    write_state <= SETTING_ADDRESS_POS23;
    write_en <= (block_exist[22])?1:0;
    w_color <= color[275:264];
    block_exist[22] <= 0;
    block_exist[np22]<= (block_exist[22])?1:0;
end
SETTING_ADDRESS_POS23:begin
    write_state <= DOWN_POS23;
    write_en<=0;
    change_en[np23] <= 1;
    address <= np23;
end
DOWN_POS23:begin
    write_state <= SETTING_ADDRESS_POS24;
    write_en <= (block_exist[23])?1:0;
    w_color <= color[287:276];
    block_exist[23] <= 0;
    block_exist[np23]<= (block_exist[23])?1:0;
end
SETTING_ADDRESS_POS24:begin
    write_state <= DOWN_POS24;
    write_en<=0;
    change_en[np24] <= 1;
    address <= np24;
end
DOWN_POS24:begin
    write_state <= SETTING_ADDRESS_POS25;
    write_en <= (block_exist[24])?1:0;
    w_color <= color[299:288];
    block_exist[24] <= 0;
    block_exist[np24]<= (block_exist[24])?1:0;
end
SETTING_ADDRESS_POS25:begin
    write_state <= DOWN_POS25;
    write_en<=0;
    change_en[np25] <= 1;
    address <= np25;
end
DOWN_POS25:begin
    write_state <= SETTING_ADDRESS_POS26;
    write_en <= (block_exist[25])?1:0;
    w_color <= color[311:300];
    block_exist[25] <= 0;
    block_exist[np25]<= (block_exist[25])?1:0;
end
SETTING_ADDRESS_POS26:begin
    write_state <= DOWN_POS26;
    write_en<=0;
    change_en[np26] <= 1;
    address <= np26;
end
DOWN_POS26:begin
    write_state <= SETTING_ADDRESS_POS27;
    write_en <= (block_exist[26])?1:0;
    w_color <= color[323:312];
    block_exist[26] <= 0;
    block_exist[np26]<= (block_exist[26])?1:0;
end
SETTING_ADDRESS_POS27:begin
    write_state <= DOWN_POS27;
    write_en<=0;
    change_en[np27] <= 1;
    address <= np27;
end
DOWN_POS27:begin
    write_state <= SETTING_ADDRESS_POS28;
    write_en <= (block_exist[27])?1:0;
    w_color <= color[335:324];
    block_exist[27] <= 0;
    block_exist[np27]<= (block_exist[27])?1:0;
end
SETTING_ADDRESS_POS28:begin
    write_state <= DOWN_POS28;
    write_en<=0;
    change_en[np28] <= 1;
    address <= np28;
end
DOWN_POS28:begin
    write_state <= SETTING_ADDRESS_POS29;
    write_en <= (block_exist[28])?1:0;
    w_color <= color[347:336];
    block_exist[28] <= 0;
    block_exist[np28]<= (block_exist[28])?1:0;
end
SETTING_ADDRESS_POS29:begin
    write_state <= DOWN_POS29;
    write_en<=0;
    change_en[np29] <= 1;
    address <= np29;
end
DOWN_POS29:begin
    write_state <= SETTING_ADDRESS_POS30;
    write_en <= (block_exist[29])?1:0;
    w_color <= color[359:348];
    block_exist[29] <= 0;
    block_exist[np29]<= (block_exist[29])?1:0;
end
SETTING_ADDRESS_POS30:begin
    write_state <= DOWN_POS30;
    write_en<=0;
    change_en[np30] <= 1;
    address <= np30;
end
DOWN_POS30:begin
    write_state <= SETTING_ADDRESS_POS31;
    write_en <= (block_exist[30])?1:0;
    w_color <= color[371:360];
    block_exist[30] <= 0;
    block_exist[np30]<= (block_exist[30])?1:0;
end
SETTING_ADDRESS_POS31:begin
    write_state <= DOWN_POS31;
    write_en<=0;
    change_en[np31] <= 1;
    address <= np31;
end
DOWN_POS31:begin
    write_state <= SETTING_ADDRESS_POS32;
    write_en <= (block_exist[31])?1:0;
    w_color <= color[383:372];
    block_exist[31] <= 0;
    block_exist[np31]<= (block_exist[31])?1:0;
end
SETTING_ADDRESS_POS32:begin
    write_state <= DOWN_POS32;
    write_en<=0;
    change_en[np32] <= 1;
    address <= np32;
end
DOWN_POS32:begin
    write_state <= SETTING_ADDRESS_POS33;
    write_en <= (block_exist[32])?1:0;
    w_color <= color[395:384];
    block_exist[32] <= 0;
    block_exist[np32]<= (block_exist[32])?1:0;
end
SETTING_ADDRESS_POS33:begin
    write_state <= DOWN_POS33;
    write_en<=0;
    change_en[np33] <= 1;
    address <= np33;
end
DOWN_POS33:begin
    write_state <= SETTING_ADDRESS_POS34;
    write_en <= (block_exist[33])?1:0;
    w_color <= color[407:396];
    block_exist[33] <= 0;
    block_exist[np33]<= (block_exist[33])?1:0;
end
SETTING_ADDRESS_POS34:begin
    write_state <= DOWN_POS34;
    write_en<=0;
    change_en[np34] <= 1;
    address <= np34;
end
DOWN_POS34:begin
    write_state <= SETTING_ADDRESS_POS35;
    write_en <= (block_exist[34])?1:0;
    w_color <= color[419:408];
    block_exist[34] <= 0;
    block_exist[np34]<= (block_exist[34])?1:0;
end
SETTING_ADDRESS_POS35:begin
    write_state <= DOWN_POS35;
    write_en<=0;
    change_en[np35] <= 1;
    address <= np35;
end
DOWN_POS35:begin
    write_state <= SETTING_ADDRESS_POS36;
    write_en <= (block_exist[35])?1:0;
    w_color <= color[431:420];
    block_exist[35] <= 0;
    block_exist[np35]<= (block_exist[35])?1:0;
end
SETTING_ADDRESS_POS36:begin
    write_state <= DOWN_POS36;
    write_en<=0;
    change_en[np36] <= 1;
    address <= np36;
end
DOWN_POS36:begin
    write_state <= SETTING_ADDRESS_POS37;
    write_en <= (block_exist[36])?1:0;
    w_color <= color[443:432];
    block_exist[36] <= 0;
    block_exist[np36]<= (block_exist[36])?1:0;
end
SETTING_ADDRESS_POS37:begin
    write_state <= DOWN_POS37;
    write_en<=0;
    change_en[np37] <= 1;
    address <= np37;
end
DOWN_POS37:begin
    write_state <= SETTING_ADDRESS_POS38;
    write_en <= (block_exist[37])?1:0;
    w_color <= color[455:444];
    block_exist[37] <= 0;
    block_exist[np37]<= (block_exist[37])?1:0;
end
SETTING_ADDRESS_POS38:begin
    write_state <= DOWN_POS38;
    write_en<=0;
    change_en[np38] <= 1;
    address <= np38;
end
DOWN_POS38:begin
    write_state <= SETTING_ADDRESS_POS39;
    write_en <= (block_exist[38])?1:0;
    w_color <= color[467:456];
    block_exist[38] <= 0;
    block_exist[np38]<= (block_exist[38])?1:0;
end
SETTING_ADDRESS_POS39:begin
    write_state <= DOWN_POS39;
    write_en<=0;
    change_en[np39] <= 1;
    address <= np39;
end
DOWN_POS39:begin
    write_state <= SETTING_ADDRESS_POS40;
    write_en <= (block_exist[39])?1:0;
    w_color <= color[479:468];
    block_exist[39] <= 0;
    block_exist[np39]<= (block_exist[39])?1:0;
end
SETTING_ADDRESS_POS40:begin
    write_state <= DOWN_POS40;
    write_en<=0;
    change_en[np40] <= 1;
    address <= np40;
end
DOWN_POS40:begin
    write_state <= SETTING_ADDRESS_POS41;
    write_en <= (block_exist[40])?1:0;
    w_color <= color[491:480];
    block_exist[40] <= 0;
    block_exist[np40]<= (block_exist[40])?1:0;
end
SETTING_ADDRESS_POS41:begin
    write_state <= DOWN_POS41;
    write_en<=0;
    change_en[np41] <= 1;
    address <= np41;
end
DOWN_POS41:begin
    write_state <= SETTING_ADDRESS_POS42;
    write_en <= (block_exist[41])?1:0;
    w_color <= color[503:492];
    block_exist[41] <= 0;
    block_exist[np41]<= (block_exist[41])?1:0;
end
SETTING_ADDRESS_POS42:begin
    write_state <= DOWN_POS42;
    write_en<=0;
    change_en[np42] <= 1;
    address <= np42;
end
DOWN_POS42:begin
    write_state <= SETTING_ADDRESS_POS43;
    write_en <= (block_exist[42])?1:0;
    w_color <= color[515:504];
    block_exist[42] <= 0;
    block_exist[np42]<= (block_exist[42])?1:0;
end
SETTING_ADDRESS_POS43:begin
    write_state <= DOWN_POS43;
    write_en<=0;
    change_en[np43] <= 1;
    address <= np43;
end
DOWN_POS43:begin
    write_state <= SETTING_ADDRESS_POS44;
    write_en <= (block_exist[43])?1:0;
    w_color <= color[527:516];
    block_exist[43] <= 0;
    block_exist[np43]<= (block_exist[43])?1:0;
end
SETTING_ADDRESS_POS44:begin
    write_state <= DOWN_POS44;
    write_en<=0;
    change_en[np44] <= 1;
    address <= np44;
end
DOWN_POS44:begin
    write_state <= SETTING_ADDRESS_POS45;
    write_en <= (block_exist[44])?1:0;
    w_color <= color[539:528];
    block_exist[44] <= 0;
    block_exist[np44]<= (block_exist[44])?1:0;
end
SETTING_ADDRESS_POS45:begin
    write_state <= DOWN_POS45;
    write_en<=0;
    change_en[np45] <= 1;
    address <= np45;
end
DOWN_POS45:begin
    write_state <= SETTING_ADDRESS_POS46;
    write_en <= (block_exist[45])?1:0;
    w_color <= color[551:540];
    block_exist[45] <= 0;
    block_exist[np45]<= (block_exist[45])?1:0;
end
SETTING_ADDRESS_POS46:begin
    write_state <= DOWN_POS46;
    write_en<=0;
    change_en[np46] <= 1;
    address <= np46;
end
DOWN_POS46:begin
    write_state <= SETTING_ADDRESS_POS47;
    write_en <= (block_exist[46])?1:0;
    w_color <= color[563:552];
    block_exist[46] <= 0;
    block_exist[np46]<= (block_exist[46])?1:0;
end
SETTING_ADDRESS_POS47:begin
    write_state <= DOWN_POS47;
    write_en<=0;
    change_en[np47] <= 1;
    address <= np47;
end
DOWN_POS47:begin
    write_state <= SETTING_ADDRESS_POS48;
    write_en <= (block_exist[47])?1:0;
    w_color <= color[575:564];
    block_exist[47] <= 0;
    block_exist[np47]<= (block_exist[47])?1:0;
end
SETTING_ADDRESS_POS48:begin
    write_state <= DOWN_POS48;
    write_en<=0;
    change_en[np48] <= 1;
    address <= np48;
end
DOWN_POS48:begin
    write_state <= SETTING_ADDRESS_POS49;
    write_en <= (block_exist[48])?1:0;
    w_color <= color[587:576];
    block_exist[48] <= 0;
    block_exist[np48]<= (block_exist[48])?1:0;
end
SETTING_ADDRESS_POS49:begin
    write_state <= DOWN_POS49;
    write_en<=0;
    change_en[np49] <= 1;
    address <= np49;
end
DOWN_POS49:begin
    write_state <= SETTING_ADDRESS_POS50;
    write_en <= (block_exist[49])?1:0;
    w_color <= color[599:588];
    block_exist[49] <= 0;
    block_exist[np49]<= (block_exist[49])?1:0;
end
SETTING_ADDRESS_POS50:begin
    write_state <= DOWN_POS50;
    write_en<=0;
    change_en[np50] <= 1;
    address <= np50;
end
DOWN_POS50:begin
    write_state <= SETTING_ADDRESS_POS51;
    write_en <= (block_exist[50])?1:0;
    w_color <= color[611:600];
    block_exist[50] <= 0;
    block_exist[np50]<= (block_exist[50])?1:0;
end
SETTING_ADDRESS_POS51:begin
    write_state <= DOWN_POS51;
    write_en<=0;
    change_en[np51] <= 1;
    address <= np51;
end
DOWN_POS51:begin
    write_state <= SETTING_ADDRESS_POS52;
    write_en <= (block_exist[51])?1:0;
    w_color <= color[623:612];
    block_exist[51] <= 0;
    block_exist[np51]<= (block_exist[51])?1:0;
end
SETTING_ADDRESS_POS52:begin
    write_state <= DOWN_POS52;
    write_en<=0;
    change_en[np52] <= 1;
    address <= np52;
end
DOWN_POS52:begin
    write_state <= SETTING_ADDRESS_POS53;
    write_en <= (block_exist[52])?1:0;
    w_color <= color[635:624];
    block_exist[52] <= 0;
    block_exist[np52]<= (block_exist[52])?1:0;
end
SETTING_ADDRESS_POS53:begin
    write_state <= DOWN_POS53;
    write_en<=0;
    change_en[np53] <= 1;
    address <= np53;
end
DOWN_POS53:begin
    write_state <= SETTING_ADDRESS_POS54;
    write_en <= (block_exist[53])?1:0;
    w_color <= color[647:636];
    block_exist[53] <= 0;
    block_exist[np53]<= (block_exist[53])?1:0;
end
SETTING_ADDRESS_POS54:begin
    write_state <= DOWN_POS54;
    write_en<=0;
    change_en[np54] <= 1;
    address <= np54;
end
DOWN_POS54:begin
    write_state <= SETTING_ADDRESS_POS55;
    write_en <= (block_exist[54])?1:0;
    w_color <= color[659:648];
    block_exist[54] <= 0;
    block_exist[np54]<= (block_exist[54])?1:0;
end
SETTING_ADDRESS_POS55:begin
    write_state <= DOWN_POS55;
    write_en<=0;
    change_en[np55] <= 1;
    address <= np55;
end
DOWN_POS55:begin
    write_state <= SETTING_ADDRESS_POS56;
    write_en <= (block_exist[55])?1:0;
    w_color <= color[671:660];
    block_exist[55] <= 0;
    block_exist[np55]<= (block_exist[55])?1:0;
end
SETTING_ADDRESS_POS56:begin
    write_state <= DOWN_POS56;
    write_en<=0;
    change_en[np56] <= 1;
    address <= np56;
end
DOWN_POS56:begin
    write_state <= SETTING_ADDRESS_POS57;
    write_en <= (block_exist[56])?1:0;
    w_color <= color[683:672];
    block_exist[56] <= 0;
    block_exist[np56]<= (block_exist[56])?1:0;
end
SETTING_ADDRESS_POS57:begin
    write_state <= DOWN_POS57;
    write_en<=0;
    change_en[np57] <= 1;
    address <= np57;
end
DOWN_POS57:begin
    write_state <= SETTING_ADDRESS_POS58;
    write_en <= (block_exist[57])?1:0;
    w_color <= color[695:684];
    block_exist[57] <= 0;
    block_exist[np57]<= (block_exist[57])?1:0;
end
SETTING_ADDRESS_POS58:begin
    write_state <= DOWN_POS58;
    write_en<=0;
    change_en[np58] <= 1;
    address <= np58;
end
DOWN_POS58:begin
    write_state <= SETTING_ADDRESS_POS59;
    write_en <= (block_exist[58])?1:0;
    w_color <= color[707:696];
    block_exist[58] <= 0;
    block_exist[np58]<= (block_exist[58])?1:0;
end
SETTING_ADDRESS_POS59:begin
    write_state <= DOWN_POS59;
    write_en<=0;
    change_en[np59] <= 1;
    address <= np59;
end
DOWN_POS59:begin
    write_state <= SETTING_ADDRESS_POS60;
    write_en <= (block_exist[59])?1:0;
    w_color <= color[719:708];
    block_exist[59] <= 0;
    block_exist[np59]<= (block_exist[59])?1:0;
end
SETTING_ADDRESS_POS60:begin
    write_state <= DOWN_POS60;
    write_en<=0;
    change_en[np60] <= 1;
    address <= np60;
end
DOWN_POS60:begin
    write_state <= SETTING_ADDRESS_POS61;
    write_en <= (block_exist[60])?1:0;
    w_color <= color[731:720];
    block_exist[60] <= 0;
    block_exist[np60]<= (block_exist[60])?1:0;
end
SETTING_ADDRESS_POS61:begin
    write_state <= DOWN_POS61;
    write_en<=0;
    change_en[np61] <= 1;
    address <= np61;
end
DOWN_POS61:begin
    write_state <= SETTING_ADDRESS_POS62;
    write_en <= (block_exist[61])?1:0;
    w_color <= color[743:732];
    block_exist[61] <= 0;
    block_exist[np61]<= (block_exist[61])?1:0;
end
SETTING_ADDRESS_POS62:begin
    write_state <= DOWN_POS62;
    write_en<=0;
    change_en[np62] <= 1;
    address <= np62;
end
DOWN_POS62:begin
    write_state <= SETTING_ADDRESS_POS63;
    write_en <= (block_exist[62])?1:0;
    w_color <= color[755:744];
    block_exist[62] <= 0;
    block_exist[np62]<= (block_exist[62])?1:0;
end
SETTING_ADDRESS_POS63:begin
    write_state <= DOWN_POS63;
    write_en<=0;
    change_en[np63] <= 1;
    address <= np63;
end
DOWN_POS63:begin
    write_state <= SETTING_ADDRESS_POS64;
    write_en <= (block_exist[63])?1:0;
    w_color <= color[767:756];
    block_exist[63] <= 0;
    block_exist[np63]<= (block_exist[63])?1:0;
end
SETTING_ADDRESS_POS64:begin
    write_state <= DOWN_POS64;
    write_en<=0;
    change_en[np64] <= 1;
    address <= np64;
end
DOWN_POS64:begin
    write_state <= SETTING_ADDRESS_POS65;
    write_en <= (block_exist[64])?1:0;
    w_color <= color[779:768];
    block_exist[64] <= 0;
    block_exist[np64]<= (block_exist[64])?1:0;
end
SETTING_ADDRESS_POS65:begin
    write_state <= DOWN_POS65;
    write_en<=0;
    change_en[np65] <= 1;
    address <= np65;
end
DOWN_POS65:begin
    write_state <= SETTING_ADDRESS_POS66;
    write_en <= (block_exist[65])?1:0;
    w_color <= color[791:780];
    block_exist[65] <= 0;
    block_exist[np65]<= (block_exist[65])?1:0;
end
SETTING_ADDRESS_POS66:begin
    write_state <= DOWN_POS66;
    write_en<=0;
    change_en[np66] <= 1;
    address <= np66;
end
DOWN_POS66:begin
    write_state <= SETTING_ADDRESS_POS67;
    write_en <= (block_exist[66])?1:0;
    w_color <= color[803:792];
    block_exist[66] <= 0;
    block_exist[np66]<= (block_exist[66])?1:0;
end
SETTING_ADDRESS_POS67:begin
    write_state <= DOWN_POS67;
    write_en<=0;
    change_en[np67] <= 1;
    address <= np67;
end
DOWN_POS67:begin
    write_state <= SETTING_ADDRESS_POS68;
    write_en <= (block_exist[67])?1:0;
    w_color <= color[815:804];
    block_exist[67] <= 0;
    block_exist[np67]<= (block_exist[67])?1:0;
end
SETTING_ADDRESS_POS68:begin
    write_state <= DOWN_POS68;
    write_en<=0;
    change_en[np68] <= 1;
    address <= np68;
end
DOWN_POS68:begin
    write_state <= SETTING_ADDRESS_POS69;
    write_en <= (block_exist[68])?1:0;
    w_color <= color[827:816];
    block_exist[68] <= 0;
    block_exist[np68]<= (block_exist[68])?1:0;
end
SETTING_ADDRESS_POS69:begin
    write_state <= DOWN_POS69;
    write_en<=0;
    change_en[np69] <= 1;
    address <= np69;
end
DOWN_POS69:begin
    write_state <= SETTING_ADDRESS_POS70;
    write_en <= (block_exist[69])?1:0;
    w_color <= color[839:828];
    block_exist[69] <= 0;
    block_exist[np69]<= (block_exist[69])?1:0;
end
SETTING_ADDRESS_POS70:begin
    write_state <= DOWN_POS70;
    write_en<=0;
    change_en[np70] <= 1;
    address <= np70;
end
DOWN_POS70:begin
    write_state <= SETTING_ADDRESS_POS71;
    write_en <= (block_exist[70])?1:0;
    w_color <= color[851:840];
    block_exist[70] <= 0;
    block_exist[np70]<= (block_exist[70])?1:0;
end
SETTING_ADDRESS_POS71:begin
    write_state <= DOWN_POS71;
    write_en<=0;
    change_en[np71] <= 1;
    address <= np71;
end
DOWN_POS71:begin
    write_state <= SETTING_ADDRESS_POS72;
    write_en <= (block_exist[71])?1:0;
    w_color <= color[863:852];
    block_exist[71] <= 0;
    block_exist[np71]<= (block_exist[71])?1:0;
end
SETTING_ADDRESS_POS72:begin
    write_state <= DOWN_POS72;
    write_en<=0;
    change_en[np72] <= 1;
    address <= np72;
end
DOWN_POS72:begin
    write_state <= SETTING_ADDRESS_POS73;
    write_en <= (block_exist[72])?1:0;
    w_color <= color[875:864];
    block_exist[72] <= 0;
    block_exist[np72]<= (block_exist[72])?1:0;
end
SETTING_ADDRESS_POS73:begin
    write_state <= DOWN_POS73;
    write_en<=0;
    change_en[np73] <= 1;
    address <= np73;
end
DOWN_POS73:begin
    write_state <= SETTING_ADDRESS_POS74;
    write_en <= (block_exist[73])?1:0;
    w_color <= color[887:876];
    block_exist[73] <= 0;
    block_exist[np73]<= (block_exist[73])?1:0;
end
SETTING_ADDRESS_POS74:begin
    write_state <= DOWN_POS74;
    write_en<=0;
    change_en[np74] <= 1;
    address <= np74;
end
DOWN_POS74:begin
    write_state <= SETTING_ADDRESS_POS75;
    write_en <= (block_exist[74])?1:0;
    w_color <= color[899:888];
    block_exist[74] <= 0;
    block_exist[np74]<= (block_exist[74])?1:0;
end
SETTING_ADDRESS_POS75:begin
    write_state <= DOWN_POS75;
    write_en<=0;
    change_en[np75] <= 1;
    address <= np75;
end
DOWN_POS75:begin
    write_state <= SETTING_ADDRESS_POS76;
    write_en <= (block_exist[75])?1:0;
    w_color <= color[911:900];
    block_exist[75] <= 0;
    block_exist[np75]<= (block_exist[75])?1:0;
end
SETTING_ADDRESS_POS76:begin
    write_state <= DOWN_POS76;
    write_en<=0;
    change_en[np76] <= 1;
    address <= np76;
end
DOWN_POS76:begin
    write_state <= SETTING_ADDRESS_POS77;
    write_en <= (block_exist[76])?1:0;
    w_color <= color[923:912];
    block_exist[76] <= 0;
    block_exist[np76]<= (block_exist[76])?1:0;
end
SETTING_ADDRESS_POS77:begin
    write_state <= DOWN_POS77;
    write_en<=0;
    change_en[np77] <= 1;
    address <= np77;
end
DOWN_POS77:begin
    write_state <= SETTING_ADDRESS_POS78;
    write_en <= (block_exist[77])?1:0;
    w_color <= color[935:924];
    block_exist[77] <= 0;
    block_exist[np77]<= (block_exist[77])?1:0;
end
SETTING_ADDRESS_POS78:begin
    write_state <= DOWN_POS78;
    write_en<=0;
    change_en[np78] <= 1;
    address <= np78;
end
DOWN_POS78:begin
    write_state <= SETTING_ADDRESS_POS79;
    write_en <= (block_exist[78])?1:0;
    w_color <= color[947:936];
    block_exist[78] <= 0;
    block_exist[np78]<= (block_exist[78])?1:0;
end
SETTING_ADDRESS_POS79:begin
    write_state <= DOWN_POS79;
    write_en<=0;
    change_en[np79] <= 1;
    address <= np79;
end
DOWN_POS79:begin
    write_state <= SETTING_ADDRESS_POS80;
    write_en <= (block_exist[79])?1:0;
    w_color <= color[959:948];
    block_exist[79] <= 0;
    block_exist[np79]<= (block_exist[79])?1:0;
end
SETTING_ADDRESS_POS80:begin
    write_state <= DOWN_POS80;
    write_en<=0;
    change_en[np80] <= 1;
    address <= np80;
end
DOWN_POS80:begin
    write_state <= SETTING_ADDRESS_POS81;
    write_en <= (block_exist[80])?1:0;
    w_color <= color[971:960];
    block_exist[80] <= 0;
    block_exist[np80]<= (block_exist[80])?1:0;
end
SETTING_ADDRESS_POS81:begin
    write_state <= DOWN_POS81;
    write_en<=0;
    change_en[np81] <= 1;
    address <= np81;
end
DOWN_POS81:begin
    write_state <= SETTING_ADDRESS_POS82;
    write_en <= (block_exist[81])?1:0;
    w_color <= color[983:972];
    block_exist[81] <= 0;
    block_exist[np81]<= (block_exist[81])?1:0;
end
SETTING_ADDRESS_POS82:begin
    write_state <= DOWN_POS82;
    write_en<=0;
    change_en[np82] <= 1;
    address <= np82;
end
DOWN_POS82:begin
    write_state <= SETTING_ADDRESS_POS83;
    write_en <= (block_exist[82])?1:0;
    w_color <= color[995:984];
    block_exist[82] <= 0;
    block_exist[np82]<= (block_exist[82])?1:0;
end
SETTING_ADDRESS_POS83:begin
    write_state <= DOWN_POS83;
    write_en<=0;
    change_en[np83] <= 1;
    address <= np83;
end
DOWN_POS83:begin
    write_state <= SETTING_ADDRESS_POS84;
    write_en <= (block_exist[83])?1:0;
    w_color <= color[1007:996];
    block_exist[83] <= 0;
    block_exist[np83]<= (block_exist[83])?1:0;
end
SETTING_ADDRESS_POS84:begin
    write_state <= DOWN_POS84;
    write_en<=0;
    change_en[np84] <= 1;
    address <= np84;
end
DOWN_POS84:begin
    write_state <= SETTING_ADDRESS_POS85;
    write_en <= (block_exist[84])?1:0;
    w_color <= color[1019:1008];
    block_exist[84] <= 0;
    block_exist[np84]<= (block_exist[84])?1:0;
end
SETTING_ADDRESS_POS85:begin
    write_state <= DOWN_POS85;
    write_en<=0;
    change_en[np85] <= 1;
    address <= np85;
end
DOWN_POS85:begin
    write_state <= SETTING_ADDRESS_POS86;
    write_en <= (block_exist[85])?1:0;
    w_color <= color[1031:1020];
    block_exist[85] <= 0;
    block_exist[np85]<= (block_exist[85])?1:0;
end
SETTING_ADDRESS_POS86:begin
    write_state <= DOWN_POS86;
    write_en<=0;
    change_en[np86] <= 1;
    address <= np86;
end
DOWN_POS86:begin
    write_state <= SETTING_ADDRESS_POS87;
    write_en <= (block_exist[86])?1:0;
    w_color <= color[1043:1032];
    block_exist[86] <= 0;
    block_exist[np86]<= (block_exist[86])?1:0;
end
SETTING_ADDRESS_POS87:begin
    write_state <= DOWN_POS87;
    write_en<=0;
    change_en[np87] <= 1;
    address <= np87;
end
DOWN_POS87:begin
    write_state <= SETTING_ADDRESS_POS88;
    write_en <= (block_exist[87])?1:0;
    w_color <= color[1055:1044];
    block_exist[87] <= 0;
    block_exist[np87]<= (block_exist[87])?1:0;
end
SETTING_ADDRESS_POS88:begin
    write_state <= DOWN_POS88;
    write_en<=0;
    change_en[np88] <= 1;
    address <= np88;
end
DOWN_POS88:begin
    write_state <= SETTING_ADDRESS_POS89;
    write_en <= (block_exist[88])?1:0;
    w_color <= color[1067:1056];
    block_exist[88] <= 0;
    block_exist[np88]<= (block_exist[88])?1:0;
end
SETTING_ADDRESS_POS89:begin
    write_state <= DOWN_POS89;
    write_en<=0;
    change_en[np89] <= 1;
    address <= np89;
end
DOWN_POS89:begin
    write_state <= SETTING_ADDRESS_POS90;
    write_en <= (block_exist[89])?1:0;
    w_color <= color[1079:1068];
    block_exist[89] <= 0;
    block_exist[np89]<= (block_exist[89])?1:0;
end
SETTING_ADDRESS_POS90:begin
    write_state <= DOWN_POS90;
    write_en<=0;
    change_en[np90] <= 1;
    address <= np90;
end
DOWN_POS90:begin
    write_state <= SETTING_ADDRESS_POS91;
    write_en <= (block_exist[90])?1:0;
    w_color <= color[1091:1080];
    block_exist[90] <= 0;
    block_exist[np90]<= (block_exist[90])?1:0;
end
SETTING_ADDRESS_POS91:begin
    write_state <= DOWN_POS91;
    write_en<=0;
    change_en[np91] <= 1;
    address <= np91;
end
DOWN_POS91:begin
    write_state <= SETTING_ADDRESS_POS92;
    write_en <= (block_exist[91])?1:0;
    w_color <= color[1103:1092];
    block_exist[91] <= 0;
    block_exist[np91]<= (block_exist[91])?1:0;
end
SETTING_ADDRESS_POS92:begin
    write_state <= DOWN_POS92;
    write_en<=0;
    change_en[np92] <= 1;
    address <= np92;
end
DOWN_POS92:begin
    write_state <= SETTING_ADDRESS_POS93;
    write_en <= (block_exist[92])?1:0;
    w_color <= color[1115:1104];
    block_exist[92] <= 0;
    block_exist[np92]<= (block_exist[92])?1:0;
end
SETTING_ADDRESS_POS93:begin
    write_state <= DOWN_POS93;
    write_en<=0;
    change_en[np93] <= 1;
    address <= np93;
end
DOWN_POS93:begin
    write_state <= SETTING_ADDRESS_POS94;
    write_en <= (block_exist[93])?1:0;
    w_color <= color[1127:1116];
    block_exist[93] <= 0;
    block_exist[np93]<= (block_exist[93])?1:0;
end
SETTING_ADDRESS_POS94:begin
    write_state <= DOWN_POS94;
    write_en<=0;
    change_en[np94] <= 1;
    address <= np94;
end
DOWN_POS94:begin
    write_state <= SETTING_ADDRESS_POS95;
    write_en <= (block_exist[94])?1:0;
    w_color <= color[1139:1128];
    block_exist[94] <= 0;
    block_exist[np94]<= (block_exist[94])?1:0;
end
SETTING_ADDRESS_POS95:begin
    write_state <= DOWN_POS95;
    write_en<=0;
    change_en[np95] <= 1;
    address <= np95;
end
DOWN_POS95:begin
    write_state <= SETTING_ADDRESS_POS96;
    write_en <= (block_exist[95])?1:0;
    w_color <= color[1151:1140];
    block_exist[95] <= 0;
    block_exist[np95]<= (block_exist[95])?1:0;
end
SETTING_ADDRESS_POS96:begin
    write_state <= DOWN_POS96;
    write_en<=0;
    change_en[np96] <= 1;
    address <= np96;
end
DOWN_POS96:begin
    write_state <= SETTING_ADDRESS_POS97;
    write_en <= (block_exist[96])?1:0;
    w_color <= color[1163:1152];
    block_exist[96] <= 0;
    block_exist[np96]<= (block_exist[96])?1:0;
end
SETTING_ADDRESS_POS97:begin
    write_state <= DOWN_POS97;
    write_en<=0;
    change_en[np97] <= 1;
    address <= np97;
end
DOWN_POS97:begin
    write_state <= SETTING_ADDRESS_POS98;
    write_en <= (block_exist[97])?1:0;
    w_color <= color[1175:1164];
    block_exist[97] <= 0;
    block_exist[np97]<= (block_exist[97])?1:0;
end
SETTING_ADDRESS_POS98:begin
    write_state <= DOWN_POS98;
    write_en<=0;
    change_en[np98] <= 1;
    address <= np98;
end
DOWN_POS98:begin
    write_state <= SETTING_ADDRESS_POS99;
    write_en <= (block_exist[98])?1:0;
    w_color <= color[1187:1176];
    block_exist[98] <= 0;
    block_exist[np98]<= (block_exist[98])?1:0;
end
SETTING_ADDRESS_POS99:begin
    write_state <= DOWN_POS99;
    write_en<=0;
    change_en[np99] <= 1;
    address <= np99;
end
DOWN_POS99:begin
    write_state <= SETTING_ADDRESS_POS100;
    write_en <= (block_exist[99])?1:0;
    w_color <= color[1199:1188];
    block_exist[99] <= 0;
    block_exist[np99]<= (block_exist[99])?1:0;
end
SETTING_ADDRESS_POS100:begin
    write_state <= DOWN_POS100;
    write_en<=0;
    change_en[np100] <= 1;
    address <= np100;
end
DOWN_POS100:begin
    write_state <= SETTING_ADDRESS_POS101;
    write_en <= (block_exist[100])?1:0;
    w_color <= color[1211:1200];
    block_exist[100] <= 0;
    block_exist[np100]<= (block_exist[100])?1:0;
end
SETTING_ADDRESS_POS101:begin
    write_state <= DOWN_POS101;
    write_en<=0;
    change_en[np101] <= 1;
    address <= np101;
end
DOWN_POS101:begin
    write_state <= SETTING_ADDRESS_POS102;
    write_en <= (block_exist[101])?1:0;
    w_color <= color[1223:1212];
    block_exist[101] <= 0;
    block_exist[np101]<= (block_exist[101])?1:0;
end
SETTING_ADDRESS_POS102:begin
    write_state <= DOWN_POS102;
    write_en<=0;
    change_en[np102] <= 1;
    address <= np102;
end
DOWN_POS102:begin
    write_state <= SETTING_ADDRESS_POS103;
    write_en <= (block_exist[102])?1:0;
    w_color <= color[1235:1224];
    block_exist[102] <= 0;
    block_exist[np102]<= (block_exist[102])?1:0;
end
SETTING_ADDRESS_POS103:begin
    write_state <= DOWN_POS103;
    write_en<=0;
    change_en[np103] <= 1;
    address <= np103;
end
DOWN_POS103:begin
    write_state <= SETTING_ADDRESS_POS104;
    write_en <= (block_exist[103])?1:0;
    w_color <= color[1247:1236];
    block_exist[103] <= 0;
    block_exist[np103]<= (block_exist[103])?1:0;
end
SETTING_ADDRESS_POS104:begin
    write_state <= DOWN_POS104;
    write_en<=0;
    change_en[np104] <= 1;
    address <= np104;
end
DOWN_POS104:begin
    write_state <= SETTING_ADDRESS_POS105;
    write_en <= (block_exist[104])?1:0;
    w_color <= color[1259:1248];
    block_exist[104] <= 0;
    block_exist[np104]<= (block_exist[104])?1:0;
end
SETTING_ADDRESS_POS105:begin
    write_state <= DOWN_POS105;
    write_en<=0;
    change_en[np105] <= 1;
    address <= np105;
end
DOWN_POS105:begin
    write_state <= SETTING_ADDRESS_POS106;
    write_en <= (block_exist[105])?1:0;
    w_color <= color[1271:1260];
    block_exist[105] <= 0;
    block_exist[np105]<= (block_exist[105])?1:0;
end
SETTING_ADDRESS_POS106:begin
    write_state <= DOWN_POS106;
    write_en<=0;
    change_en[np106] <= 1;
    address <= np106;
end
DOWN_POS106:begin
    write_state <= SETTING_ADDRESS_POS107;
    write_en <= (block_exist[106])?1:0;
    w_color <= color[1283:1272];
    block_exist[106] <= 0;
    block_exist[np106]<= (block_exist[106])?1:0;
end
SETTING_ADDRESS_POS107:begin
    write_state <= DOWN_POS107;
    write_en<=0;
    change_en[np107] <= 1;
    address <= np107;
end
DOWN_POS107:begin
    write_state <= SETTING_ADDRESS_POS108;
    write_en <= (block_exist[107])?1:0;
    w_color <= color[1295:1284];
    block_exist[107] <= 0;
    block_exist[np107]<= (block_exist[107])?1:0;
end
SETTING_ADDRESS_POS108:begin
    write_state <= DOWN_POS108;
    write_en<=0;
    change_en[np108] <= 1;
    address <= np108;
end
DOWN_POS108:begin
    write_state <= SETTING_ADDRESS_POS109;
    write_en <= (block_exist[108])?1:0;
    w_color <= color[1307:1296];
    block_exist[108] <= 0;
    block_exist[np108]<= (block_exist[108])?1:0;
end
SETTING_ADDRESS_POS109:begin
    write_state <= DOWN_POS109;
    write_en<=0;
    change_en[np109] <= 1;
    address <= np109;
end
DOWN_POS109:begin
    write_state <= SETTING_ADDRESS_POS110;
    write_en <= (block_exist[109])?1:0;
    w_color <= color[1319:1308];
    block_exist[109] <= 0;
    block_exist[np109]<= (block_exist[109])?1:0;
end
SETTING_ADDRESS_POS110:begin
    write_state <= DOWN_POS110;
    write_en<=0;
    change_en[np110] <= 1;
    address <= np110;
end
DOWN_POS110:begin
    write_state <= SETTING_ADDRESS_POS111;
    write_en <= (block_exist[110])?1:0;
    w_color <= color[1331:1320];
    block_exist[110] <= 0;
    block_exist[np110]<= (block_exist[110])?1:0;
end
SETTING_ADDRESS_POS111:begin
    write_state <= DOWN_POS111;
    write_en<=0;
    change_en[np111] <= 1;
    address <= np111;
end
DOWN_POS111:begin
    write_state <= SETTING_ADDRESS_POS112;
    write_en <= (block_exist[111])?1:0;
    w_color <= color[1343:1332];
    block_exist[111] <= 0;
    block_exist[np111]<= (block_exist[111])?1:0;
end
SETTING_ADDRESS_POS112:begin
    write_state <= DOWN_POS112;
    write_en<=0;
    change_en[np112] <= 1;
    address <= np112;
end
DOWN_POS112:begin
    write_state <= SETTING_ADDRESS_POS113;
    write_en <= (block_exist[112])?1:0;
    w_color <= color[1355:1344];
    block_exist[112] <= 0;
    block_exist[np112]<= (block_exist[112])?1:0;
end
SETTING_ADDRESS_POS113:begin
    write_state <= DOWN_POS113;
    write_en<=0;
    change_en[np113] <= 1;
    address <= np113;
end
DOWN_POS113:begin
    write_state <= SETTING_ADDRESS_POS114;
    write_en <= (block_exist[113])?1:0;
    w_color <= color[1367:1356];
    block_exist[113] <= 0;
    block_exist[np113]<= (block_exist[113])?1:0;
end
SETTING_ADDRESS_POS114:begin
    write_state <= DOWN_POS114;
    write_en<=0;
    change_en[np114] <= 1;
    address <= np114;
end
DOWN_POS114:begin
    write_state <= SETTING_ADDRESS_POS115;
    write_en <= (block_exist[114])?1:0;
    w_color <= color[1379:1368];
    block_exist[114] <= 0;
    block_exist[np114]<= (block_exist[114])?1:0;
end
SETTING_ADDRESS_POS115:begin
    write_state <= DOWN_POS115;
    write_en<=0;
    change_en[np115] <= 1;
    address <= np115;
end
DOWN_POS115:begin
    write_state <= SETTING_ADDRESS_POS116;
    write_en <= (block_exist[115])?1:0;
    w_color <= color[1391:1380];
    block_exist[115] <= 0;
    block_exist[np115]<= (block_exist[115])?1:0;
end
SETTING_ADDRESS_POS116:begin
    write_state <= DOWN_POS116;
    write_en<=0;
    change_en[np116] <= 1;
    address <= np116;
end
DOWN_POS116:begin
    write_state <= SETTING_ADDRESS_POS117;
    write_en <= (block_exist[116])?1:0;
    w_color <= color[1403:1392];
    block_exist[116] <= 0;
    block_exist[np116]<= (block_exist[116])?1:0;
end
SETTING_ADDRESS_POS117:begin
    write_state <= DOWN_POS117;
    write_en<=0;
    change_en[np117] <= 1;
    address <= np117;
end
DOWN_POS117:begin
    write_state <= SETTING_ADDRESS_POS118;
    write_en <= (block_exist[117])?1:0;
    w_color <= color[1415:1404];
    block_exist[117] <= 0;
    block_exist[np117]<= (block_exist[117])?1:0;
end
SETTING_ADDRESS_POS118:begin
    write_state <= DOWN_POS118;
    write_en<=0;
    change_en[np118] <= 1;
    address <= np118;
end
DOWN_POS118:begin
    write_state <= SETTING_ADDRESS_POS119;
    write_en <= (block_exist[118])?1:0;
    w_color <= color[1427:1416];
    block_exist[118] <= 0;
    block_exist[np118]<= (block_exist[118])?1:0;
end
SETTING_ADDRESS_POS119:begin
    write_state <= DOWN_POS119;
    write_en<=0;
    change_en[np119] <= 1;
    address <= np119;
end
DOWN_POS119:begin
    write_state <= SETTING_ADDRESS_POS120;
    write_en <= (block_exist[119])?1:0;
    w_color <= color[1439:1428];
    block_exist[119] <= 0;
    block_exist[np119]<= (block_exist[119])?1:0;
end
SETTING_ADDRESS_POS120:begin
    write_state <= DOWN_POS120;
    write_en<=0;
    change_en[np120] <= 1;
    address <= np120;
end
DOWN_POS120:begin
    write_state <= SETTING_ADDRESS_POS121;
    write_en <= (block_exist[120])?1:0;
    w_color <= color[1451:1440];
    block_exist[120] <= 0;
    block_exist[np120]<= (block_exist[120])?1:0;
end
SETTING_ADDRESS_POS121:begin
    write_state <= DOWN_POS121;
    write_en<=0;
    change_en[np121] <= 1;
    address <= np121;
end
DOWN_POS121:begin
    write_state <= SETTING_ADDRESS_POS122;
    write_en <= (block_exist[121])?1:0;
    w_color <= color[1463:1452];
    block_exist[121] <= 0;
    block_exist[np121]<= (block_exist[121])?1:0;
end
SETTING_ADDRESS_POS122:begin
    write_state <= DOWN_POS122;
    write_en<=0;
    change_en[np122] <= 1;
    address <= np122;
end
DOWN_POS122:begin
    write_state <= SETTING_ADDRESS_POS123;
    write_en <= (block_exist[122])?1:0;
    w_color <= color[1475:1464];
    block_exist[122] <= 0;
    block_exist[np122]<= (block_exist[122])?1:0;
end
SETTING_ADDRESS_POS123:begin
    write_state <= DOWN_POS123;
    write_en<=0;
    change_en[np123] <= 1;
    address <= np123;
end
DOWN_POS123:begin
    write_state <= SETTING_ADDRESS_POS124;
    write_en <= (block_exist[123])?1:0;
    w_color <= color[1487:1476];
    block_exist[123] <= 0;
    block_exist[np123]<= (block_exist[123])?1:0;
end
SETTING_ADDRESS_POS124:begin
    write_state <= DOWN_POS124;
    write_en<=0;
    change_en[np124] <= 1;
    address <= np124;
end
DOWN_POS124:begin
    write_state <= SETTING_ADDRESS_POS125;
    write_en <= (block_exist[124])?1:0;
    w_color <= color[1499:1488];
    block_exist[124] <= 0;
    block_exist[np124]<= (block_exist[124])?1:0;
end
SETTING_ADDRESS_POS125:begin
    write_state <= DOWN_POS125;
    write_en<=0;
    change_en[np125] <= 1;
    address <= np125;
end
DOWN_POS125:begin
    write_state <= SETTING_ADDRESS_POS126;
    write_en <= (block_exist[125])?1:0;
    w_color <= color[1511:1500];
    block_exist[125] <= 0;
    block_exist[np125]<= (block_exist[125])?1:0;
end
SETTING_ADDRESS_POS126:begin
    write_state <= DOWN_POS126;
    write_en<=0;
    change_en[np126] <= 1;
    address <= np126;
end
DOWN_POS126:begin
    write_state <= SETTING_ADDRESS_POS127;
    write_en <= (block_exist[126])?1:0;
    w_color <= color[1523:1512];
    block_exist[126] <= 0;
    block_exist[np126]<= (block_exist[126])?1:0;
end
SETTING_ADDRESS_POS127:begin
    write_state <= DOWN_POS127;
    write_en<=0;
    change_en[np127] <= 1;
    address <= np127;
end
DOWN_POS127:begin
    write_state <= SETTING_ADDRESS_POS128;
    write_en <= (block_exist[127])?1:0;
    w_color <= color[1535:1524];
    block_exist[127] <= 0;
    block_exist[np127]<= (block_exist[127])?1:0;
end
SETTING_ADDRESS_POS128:begin
    write_state <= DOWN_POS128;
    write_en<=0;
    change_en[np128] <= 1;
    address <= np128;
end
DOWN_POS128:begin
    write_state <= SETTING_ADDRESS_POS129;
    write_en <= (block_exist[128])?1:0;
    w_color <= color[1547:1536];
    block_exist[128] <= 0;
    block_exist[np128]<= (block_exist[128])?1:0;
end
SETTING_ADDRESS_POS129:begin
    write_state <= DOWN_POS129;
    write_en<=0;
    change_en[np129] <= 1;
    address <= np129;
end
DOWN_POS129:begin
    write_state <= SETTING_ADDRESS_POS130;
    write_en <= (block_exist[129])?1:0;
    w_color <= color[1559:1548];
    block_exist[129] <= 0;
    block_exist[np129]<= (block_exist[129])?1:0;
end
SETTING_ADDRESS_POS130:begin
    write_state <= DOWN_POS130;
    write_en<=0;
    change_en[np130] <= 1;
    address <= np130;
end
DOWN_POS130:begin
    write_state <= SETTING_ADDRESS_POS131;
    write_en <= (block_exist[130])?1:0;
    w_color <= color[1571:1560];
    block_exist[130] <= 0;
    block_exist[np130]<= (block_exist[130])?1:0;
end
SETTING_ADDRESS_POS131:begin
    write_state <= DOWN_POS131;
    write_en<=0;
    change_en[np131] <= 1;
    address <= np131;
end
DOWN_POS131:begin
    write_state <= SETTING_ADDRESS_POS132;
    write_en <= (block_exist[131])?1:0;
    w_color <= color[1583:1572];
    block_exist[131] <= 0;
    block_exist[np131]<= (block_exist[131])?1:0;
end
SETTING_ADDRESS_POS132:begin
    write_state <= DOWN_POS132;
    write_en<=0;
    change_en[np132] <= 1;
    address <= np132;
end
DOWN_POS132:begin
    write_state <= SETTING_ADDRESS_POS133;
    write_en <= (block_exist[132])?1:0;
    w_color <= color[1595:1584];
    block_exist[132] <= 0;
    block_exist[np132]<= (block_exist[132])?1:0;
end
SETTING_ADDRESS_POS133:begin
    write_state <= DOWN_POS133;
    write_en<=0;
    change_en[np133] <= 1;
    address <= np133;
end
DOWN_POS133:begin
    write_state <= SETTING_ADDRESS_POS134;
    write_en <= (block_exist[133])?1:0;
    w_color <= color[1607:1596];
    block_exist[133] <= 0;
    block_exist[np133]<= (block_exist[133])?1:0;
end
SETTING_ADDRESS_POS134:begin
    write_state <= DOWN_POS134;
    write_en<=0;
    change_en[np134] <= 1;
    address <= np134;
end
DOWN_POS134:begin
    write_state <= SETTING_ADDRESS_POS135;
    write_en <= (block_exist[134])?1:0;
    w_color <= color[1619:1608];
    block_exist[134] <= 0;
    block_exist[np134]<= (block_exist[134])?1:0;
end
SETTING_ADDRESS_POS135:begin
    write_state <= DOWN_POS135;
    write_en<=0;
    change_en[np135] <= 1;
    address <= np135;
end
DOWN_POS135:begin
    write_state <= SETTING_ADDRESS_POS136;
    write_en <= (block_exist[135])?1:0;
    w_color <= color[1631:1620];
    block_exist[135] <= 0;
    block_exist[np135]<= (block_exist[135])?1:0;
end
SETTING_ADDRESS_POS136:begin
    write_state <= DOWN_POS136;
    write_en<=0;
    change_en[np136] <= 1;
    address <= np136;
end
DOWN_POS136:begin
    write_state <= SETTING_ADDRESS_POS137;
    write_en <= (block_exist[136])?1:0;
    w_color <= color[1643:1632];
    block_exist[136] <= 0;
    block_exist[np136]<= (block_exist[136])?1:0;
end
SETTING_ADDRESS_POS137:begin
    write_state <= DOWN_POS137;
    write_en<=0;
    change_en[np137] <= 1;
    address <= np137;
end
DOWN_POS137:begin
    write_state <= SETTING_ADDRESS_POS138;
    write_en <= (block_exist[137])?1:0;
    w_color <= color[1655:1644];
    block_exist[137] <= 0;
    block_exist[np137]<= (block_exist[137])?1:0;
end
SETTING_ADDRESS_POS138:begin
    write_state <= DOWN_POS138;
    write_en<=0;
    change_en[np138] <= 1;
    address <= np138;
end
DOWN_POS138:begin
    write_state <= SETTING_ADDRESS_POS139;
    write_en <= (block_exist[138])?1:0;
    w_color <= color[1667:1656];
    block_exist[138] <= 0;
    block_exist[np138]<= (block_exist[138])?1:0;
end
SETTING_ADDRESS_POS139:begin
    write_state <= DOWN_POS139;
    write_en<=0;
    change_en[np139] <= 1;
    address <= np139;
end
DOWN_POS139:begin
    write_state <= SETTING_ADDRESS_POS140;
    write_en <= (block_exist[139])?1:0;
    w_color <= color[1679:1668];
    block_exist[139] <= 0;
    block_exist[np139]<= (block_exist[139])?1:0;
end
SETTING_ADDRESS_POS140:begin
    write_state <= DOWN_POS140;
    write_en<=0;
    change_en[np140] <= 1;
    address <= np140;
end
DOWN_POS140:begin
    write_state <= SETTING_ADDRESS_POS141;
    write_en <= (block_exist[140])?1:0;
    w_color <= color[1691:1680];
    block_exist[140] <= 0;
    block_exist[np140]<= (block_exist[140])?1:0;
end
SETTING_ADDRESS_POS141:begin
    write_state <= DOWN_POS141;
    write_en<=0;
    change_en[np141] <= 1;
    address <= np141;
end
DOWN_POS141:begin
    write_state <= SETTING_ADDRESS_POS142;
    write_en <= (block_exist[141])?1:0;
    w_color <= color[1703:1692];
    block_exist[141] <= 0;
    block_exist[np141]<= (block_exist[141])?1:0;
end
SETTING_ADDRESS_POS142:begin
    write_state <= DOWN_POS142;
    write_en<=0;
    change_en[np142] <= 1;
    address <= np142;
end
DOWN_POS142:begin
    write_state <= SETTING_ADDRESS_POS143;
    write_en <= (block_exist[142])?1:0;
    w_color <= color[1715:1704];
    block_exist[142] <= 0;
    block_exist[np142]<= (block_exist[142])?1:0;
end
SETTING_ADDRESS_POS143:begin
    write_state <= DOWN_POS143;
    write_en<=0;
    change_en[np143] <= 1;
    address <= np143;
end
DOWN_POS143:begin
    write_state <= SETTING_ADDRESS_POS144;
    write_en <= (block_exist[143])?1:0;
    w_color <= color[1727:1716];
    block_exist[143] <= 0;
    block_exist[np143]<= (block_exist[143])?1:0;
end
SETTING_ADDRESS_POS144:begin
    write_state <= DOWN_POS144;
    write_en<=0;
    change_en[np144] <= 1;
    address <= np144;
end
DOWN_POS144:begin
    write_state <= SETTING_ADDRESS_POS145;
    write_en <= (block_exist[144])?1:0;
    w_color <= color[1739:1728];
    block_exist[144] <= 0;
    block_exist[np144]<= (block_exist[144])?1:0;
end
SETTING_ADDRESS_POS145:begin
    write_state <= DOWN_POS145;
    write_en<=0;
    change_en[np145] <= 1;
    address <= np145;
end
DOWN_POS145:begin
    write_state <= SETTING_ADDRESS_POS146;
    write_en <= (block_exist[145])?1:0;
    w_color <= color[1751:1740];
    block_exist[145] <= 0;
    block_exist[np145]<= (block_exist[145])?1:0;
end
SETTING_ADDRESS_POS146:begin
    write_state <= DOWN_POS146;
    write_en<=0;
    change_en[np146] <= 1;
    address <= np146;
end
DOWN_POS146:begin
    write_state <= SETTING_ADDRESS_POS147;
    write_en <= (block_exist[146])?1:0;
    w_color <= color[1763:1752];
    block_exist[146] <= 0;
    block_exist[np146]<= (block_exist[146])?1:0;
end
SETTING_ADDRESS_POS147:begin
    write_state <= DOWN_POS147;
    write_en<=0;
    change_en[np147] <= 1;
    address <= np147;
end
DOWN_POS147:begin
    write_state <= SETTING_ADDRESS_POS148;
    write_en <= (block_exist[147])?1:0;
    w_color <= color[1775:1764];
    block_exist[147] <= 0;
    block_exist[np147]<= (block_exist[147])?1:0;
end
SETTING_ADDRESS_POS148:begin
    write_state <= DOWN_POS148;
    write_en<=0;
    change_en[np148] <= 1;
    address <= np148;
end
DOWN_POS148:begin
    write_state <= SETTING_ADDRESS_POS149;
    write_en <= (block_exist[148])?1:0;
    w_color <= color[1787:1776];
    block_exist[148] <= 0;
    block_exist[np148]<= (block_exist[148])?1:0;
end
SETTING_ADDRESS_POS149:begin
    write_state <= DOWN_POS149;
    write_en<=0;
    change_en[np149] <= 1;
    address <= np149;
end
DOWN_POS149:begin
    write_state <= SETTING_ADDRESS_POS150;
    write_en <= (block_exist[149])?1:0;
    w_color <= color[1799:1788];
    block_exist[149] <= 0;
    block_exist[np149]<= (block_exist[149])?1:0;
end
SETTING_ADDRESS_POS150:begin
    write_state <= DOWN_POS150;
    write_en<=0;
    change_en[np150] <= 1;
    address <= np150;
end
DOWN_POS150:begin
    write_state <= SETTING_ADDRESS_POS151;
    write_en <= (block_exist[150])?1:0;
    w_color <= color[1811:1800];
    block_exist[150] <= 0;
    block_exist[np150]<= (block_exist[150])?1:0;
end
SETTING_ADDRESS_POS151:begin
    write_state <= DOWN_POS151;
    write_en<=0;
    change_en[np151] <= 1;
    address <= np151;
end
DOWN_POS151:begin
    write_state <= SETTING_ADDRESS_POS152;
    write_en <= (block_exist[151])?1:0;
    w_color <= color[1823:1812];
    block_exist[151] <= 0;
    block_exist[np151]<= (block_exist[151])?1:0;
end
SETTING_ADDRESS_POS152:begin
    write_state <= DOWN_POS152;
    write_en<=0;
    change_en[np152] <= 1;
    address <= np152;
end
DOWN_POS152:begin
    write_state <= SETTING_ADDRESS_POS153;
    write_en <= (block_exist[152])?1:0;
    w_color <= color[1835:1824];
    block_exist[152] <= 0;
    block_exist[np152]<= (block_exist[152])?1:0;
end
SETTING_ADDRESS_POS153:begin
    write_state <= DOWN_POS153;
    write_en<=0;
    change_en[np153] <= 1;
    address <= np153;
end
DOWN_POS153:begin
    write_state <= SETTING_ADDRESS_POS154;
    write_en <= (block_exist[153])?1:0;
    w_color <= color[1847:1836];
    block_exist[153] <= 0;
    block_exist[np153]<= (block_exist[153])?1:0;
end
SETTING_ADDRESS_POS154:begin
    write_state <= DOWN_POS154;
    write_en<=0;
    change_en[np154] <= 1;
    address <= np154;
end
DOWN_POS154:begin
    write_state <= SETTING_ADDRESS_POS155;
    write_en <= (block_exist[154])?1:0;
    w_color <= color[1859:1848];
    block_exist[154] <= 0;
    block_exist[np154]<= (block_exist[154])?1:0;
end
SETTING_ADDRESS_POS155:begin
    write_state <= DOWN_POS155;
    write_en<=0;
    change_en[np155] <= 1;
    address <= np155;
end
DOWN_POS155:begin
    write_state <= SETTING_ADDRESS_POS156;
    write_en <= (block_exist[155])?1:0;
    w_color <= color[1871:1860];
    block_exist[155] <= 0;
    block_exist[np155]<= (block_exist[155])?1:0;
end
SETTING_ADDRESS_POS156:begin
    write_state <= DOWN_POS156;
    write_en<=0;
    change_en[np156] <= 1;
    address <= np156;
end
DOWN_POS156:begin
    write_state <= SETTING_ADDRESS_POS157;
    write_en <= (block_exist[156])?1:0;
    w_color <= color[1883:1872];
    block_exist[156] <= 0;
    block_exist[np156]<= (block_exist[156])?1:0;
end
SETTING_ADDRESS_POS157:begin
    write_state <= DOWN_POS157;
    write_en<=0;
    change_en[np157] <= 1;
    address <= np157;
end
DOWN_POS157:begin
    write_state <= SETTING_ADDRESS_POS158;
    write_en <= (block_exist[157])?1:0;
    w_color <= color[1895:1884];
    block_exist[157] <= 0;
    block_exist[np157]<= (block_exist[157])?1:0;
end
SETTING_ADDRESS_POS158:begin
    write_state <= DOWN_POS158;
    write_en<=0;
    change_en[np158] <= 1;
    address <= np158;
end
DOWN_POS158:begin
    write_state <= SETTING_ADDRESS_POS159;
    write_en <= (block_exist[158])?1:0;
    w_color <= color[1907:1896];
    block_exist[158] <= 0;
    block_exist[np158]<= (block_exist[158])?1:0;
end
SETTING_ADDRESS_POS159:begin
    write_state <= DOWN_POS159;
    write_en<=0;
    change_en[np159] <= 1;
    address <= np159;
end
DOWN_POS159:begin
    write_state <= SETTING_ADDRESS_POS160;
    write_en <= (block_exist[159])?1:0;
    w_color <= color[1919:1908];
    block_exist[159] <= 0;
    block_exist[np159]<= (block_exist[159])?1:0;
end
SETTING_ADDRESS_POS160:begin
    write_state <= DOWN_POS160;
    write_en<=0;
    change_en[np160] <= 1;
    address <= np160;
end
DOWN_POS160:begin
    write_state <= SETTING_ADDRESS_POS161;
    write_en <= (block_exist[160])?1:0;
    w_color <= color[1931:1920];
    block_exist[160] <= 0;
    block_exist[np160]<= (block_exist[160])?1:0;
end
SETTING_ADDRESS_POS161:begin
    write_state <= DOWN_POS161;
    write_en<=0;
    change_en[np161] <= 1;
    address <= np161;
end
DOWN_POS161:begin
    write_state <= SETTING_ADDRESS_POS162;
    write_en <= (block_exist[161])?1:0;
    w_color <= color[1943:1932];
    block_exist[161] <= 0;
    block_exist[np161]<= (block_exist[161])?1:0;
end
SETTING_ADDRESS_POS162:begin
    write_state <= DOWN_POS162;
    write_en<=0;
    change_en[np162] <= 1;
    address <= np162;
end
DOWN_POS162:begin
    write_state <= SETTING_ADDRESS_POS163;
    write_en <= (block_exist[162])?1:0;
    w_color <= color[1955:1944];
    block_exist[162] <= 0;
    block_exist[np162]<= (block_exist[162])?1:0;
end
SETTING_ADDRESS_POS163:begin
    write_state <= DOWN_POS163;
    write_en<=0;
    change_en[np163] <= 1;
    address <= np163;
end
DOWN_POS163:begin
    write_state <= SETTING_ADDRESS_POS164;
    write_en <= (block_exist[163])?1:0;
    w_color <= color[1967:1956];
    block_exist[163] <= 0;
    block_exist[np163]<= (block_exist[163])?1:0;
end
SETTING_ADDRESS_POS164:begin
    write_state <= DOWN_POS164;
    write_en<=0;
    change_en[np164] <= 1;
    address <= np164;
end
DOWN_POS164:begin
    write_state <= SETTING_ADDRESS_POS165;
    write_en <= (block_exist[164])?1:0;
    w_color <= color[1979:1968];
    block_exist[164] <= 0;
    block_exist[np164]<= (block_exist[164])?1:0;
end
SETTING_ADDRESS_POS165:begin
    write_state <= DOWN_POS165;
    write_en<=0;
    change_en[np165] <= 1;
    address <= np165;
end
DOWN_POS165:begin
    write_state <= SETTING_ADDRESS_POS166;
    write_en <= (block_exist[165])?1:0;
    w_color <= color[1991:1980];
    block_exist[165] <= 0;
    block_exist[np165]<= (block_exist[165])?1:0;
end
SETTING_ADDRESS_POS166:begin
    write_state <= DOWN_POS166;
    write_en<=0;
    change_en[np166] <= 1;
    address <= np166;
end
DOWN_POS166:begin
    write_state <= SETTING_ADDRESS_POS167;
    write_en <= (block_exist[166])?1:0;
    w_color <= color[2003:1992];
    block_exist[166] <= 0;
    block_exist[np166]<= (block_exist[166])?1:0;
end
SETTING_ADDRESS_POS167:begin
    write_state <= DOWN_POS167;
    write_en<=0;
    change_en[np167] <= 1;
    address <= np167;
end
DOWN_POS167:begin
    write_state <= SETTING_ADDRESS_POS168;
    write_en <= (block_exist[167])?1:0;
    w_color <= color[2015:2004];
    block_exist[167] <= 0;
    block_exist[np167]<= (block_exist[167])?1:0;
end
SETTING_ADDRESS_POS168:begin
    write_state <= DOWN_POS168;
    write_en<=0;
    change_en[np168] <= 1;
    address <= np168;
end
DOWN_POS168:begin
    write_state <= SETTING_ADDRESS_POS169;
    write_en <= (block_exist[168])?1:0;
    w_color <= color[2027:2016];
    block_exist[168] <= 0;
    block_exist[np168]<= (block_exist[168])?1:0;
end
SETTING_ADDRESS_POS169:begin
    write_state <= DOWN_POS169;
    write_en<=0;
    change_en[np169] <= 1;
    address <= np169;
end
DOWN_POS169:begin
    write_state <= SETTING_ADDRESS_POS170;
    write_en <= (block_exist[169])?1:0;
    w_color <= color[2039:2028];
    block_exist[169] <= 0;
    block_exist[np169]<= (block_exist[169])?1:0;
end
SETTING_ADDRESS_POS170:begin
    write_state <= DOWN_POS170;
    write_en<=0;
    change_en[np170] <= 1;
    address <= np170;
end
DOWN_POS170:begin
    write_state <= SETTING_ADDRESS_POS171;
    write_en <= (block_exist[170])?1:0;
    w_color <= color[2051:2040];
    block_exist[170] <= 0;
    block_exist[np170]<= (block_exist[170])?1:0;
end
SETTING_ADDRESS_POS171:begin
    write_state <= DOWN_POS171;
    write_en<=0;
    change_en[np171] <= 1;
    address <= np171;
end
DOWN_POS171:begin
    write_state <= SETTING_ADDRESS_POS172;
    write_en <= (block_exist[171])?1:0;
    w_color <= color[2063:2052];
    block_exist[171] <= 0;
    block_exist[np171]<= (block_exist[171])?1:0;
end
SETTING_ADDRESS_POS172:begin
    write_state <= DOWN_POS172;
    write_en<=0;
    change_en[np172] <= 1;
    address <= np172;
end
DOWN_POS172:begin
    write_state <= SETTING_ADDRESS_POS173;
    write_en <= (block_exist[172])?1:0;
    w_color <= color[2075:2064];
    block_exist[172] <= 0;
    block_exist[np172]<= (block_exist[172])?1:0;
end
SETTING_ADDRESS_POS173:begin
    write_state <= DOWN_POS173;
    write_en<=0;
    change_en[np173] <= 1;
    address <= np173;
end
DOWN_POS173:begin
    write_state <= SETTING_ADDRESS_POS174;
    write_en <= (block_exist[173])?1:0;
    w_color <= color[2087:2076];
    block_exist[173] <= 0;
    block_exist[np173]<= (block_exist[173])?1:0;
end
SETTING_ADDRESS_POS174:begin
    write_state <= DOWN_POS174;
    write_en<=0;
    change_en[np174] <= 1;
    address <= np174;
end
DOWN_POS174:begin
    write_state <= SETTING_ADDRESS_POS175;
    write_en <= (block_exist[174])?1:0;
    w_color <= color[2099:2088];
    block_exist[174] <= 0;
    block_exist[np174]<= (block_exist[174])?1:0;
end
SETTING_ADDRESS_POS175:begin
    write_state <= DOWN_POS175;
    write_en<=0;
    change_en[np175] <= 1;
    address <= np175;
end
DOWN_POS175:begin
    write_state <= SETTING_ADDRESS_POS176;
    write_en <= (block_exist[175])?1:0;
    w_color <= color[2111:2100];
    block_exist[175] <= 0;
    block_exist[np175]<= (block_exist[175])?1:0;
end
SETTING_ADDRESS_POS176:begin
    write_state <= DOWN_POS176;
    write_en<=0;
    change_en[np176] <= 1;
    address <= np176;
end
DOWN_POS176:begin
    write_state <= SETTING_ADDRESS_POS177;
    write_en <= (block_exist[176])?1:0;
    w_color <= color[2123:2112];
    block_exist[176] <= 0;
    block_exist[np176]<= (block_exist[176])?1:0;
end
SETTING_ADDRESS_POS177:begin
    write_state <= DOWN_POS177;
    write_en<=0;
    change_en[np177] <= 1;
    address <= np177;
end
DOWN_POS177:begin
    write_state <= SETTING_ADDRESS_POS178;
    write_en <= (block_exist[177])?1:0;
    w_color <= color[2135:2124];
    block_exist[177] <= 0;
    block_exist[np177]<= (block_exist[177])?1:0;
end
SETTING_ADDRESS_POS178:begin
    write_state <= DOWN_POS178;
    write_en<=0;
    change_en[np178] <= 1;
    address <= np178;
end
DOWN_POS178:begin
    write_state <= SETTING_ADDRESS_POS179;
    write_en <= (block_exist[178])?1:0;
    w_color <= color[2147:2136];
    block_exist[178] <= 0;
    block_exist[np178]<= (block_exist[178])?1:0;
end
SETTING_ADDRESS_POS179:begin
    write_state <= DOWN_POS179;
    write_en<=0;
    change_en[np179] <= 1;
    address <= np179;
end
DOWN_POS179:begin
    write_state <= SETTING_ADDRESS_POS180;
    write_en <= (block_exist[179])?1:0;
    w_color <= color[2159:2148];
    block_exist[179] <= 0;
    block_exist[np179]<= (block_exist[179])?1:0;
end
SETTING_ADDRESS_POS180:begin
    write_state <= DOWN_POS180;
    write_en<=0;
    change_en[np180] <= 1;
    address <= np180;
end
DOWN_POS180:begin
    write_state <= SETTING_ADDRESS_POS181;
    write_en <= (block_exist[180])?1:0;
    w_color <= color[2171:2160];
    block_exist[180] <= 0;
    block_exist[np180]<= (block_exist[180])?1:0;
end
SETTING_ADDRESS_POS181:begin
    write_state <= DOWN_POS181;
    write_en<=0;
    change_en[np181] <= 1;
    address <= np181;
end
DOWN_POS181:begin
    write_state <= SETTING_ADDRESS_POS182;
    write_en <= (block_exist[181])?1:0;
    w_color <= color[2183:2172];
    block_exist[181] <= 0;
    block_exist[np181]<= (block_exist[181])?1:0;
end
SETTING_ADDRESS_POS182:begin
    write_state <= DOWN_POS182;
    write_en<=0;
    change_en[np182] <= 1;
    address <= np182;
end
DOWN_POS182:begin
    write_state <= SETTING_ADDRESS_POS183;
    write_en <= (block_exist[182])?1:0;
    w_color <= color[2195:2184];
    block_exist[182] <= 0;
    block_exist[np182]<= (block_exist[182])?1:0;
end
SETTING_ADDRESS_POS183:begin
    write_state <= DOWN_POS183;
    write_en<=0;
    change_en[np183] <= 1;
    address <= np183;
end
DOWN_POS183:begin
    write_state <= SETTING_ADDRESS_POS184;
    write_en <= (block_exist[183])?1:0;
    w_color <= color[2207:2196];
    block_exist[183] <= 0;
    block_exist[np183]<= (block_exist[183])?1:0;
end
SETTING_ADDRESS_POS184:begin
    write_state <= DOWN_POS184;
    write_en<=0;
    change_en[np184] <= 1;
    address <= np184;
end
DOWN_POS184:begin
    write_state <= SETTING_ADDRESS_POS185;
    write_en <= (block_exist[184])?1:0;
    w_color <= color[2219:2208];
    block_exist[184] <= 0;
    block_exist[np184]<= (block_exist[184])?1:0;
end
SETTING_ADDRESS_POS185:begin
    write_state <= DOWN_POS185;
    write_en<=0;
    change_en[np185] <= 1;
    address <= np185;
end
DOWN_POS185:begin
    write_state <= SETTING_ADDRESS_POS186;
    write_en <= (block_exist[185])?1:0;
    w_color <= color[2231:2220];
    block_exist[185] <= 0;
    block_exist[np185]<= (block_exist[185])?1:0;
end
SETTING_ADDRESS_POS186:begin
    write_state <= DOWN_POS186;
    write_en<=0;
    change_en[np186] <= 1;
    address <= np186;
end
DOWN_POS186:begin
    write_state <= SETTING_ADDRESS_POS187;
    write_en <= (block_exist[186])?1:0;
    w_color <= color[2243:2232];
    block_exist[186] <= 0;
    block_exist[np186]<= (block_exist[186])?1:0;
end
SETTING_ADDRESS_POS187:begin
    write_state <= DOWN_POS187;
    write_en<=0;
    change_en[np187] <= 1;
    address <= np187;
end
DOWN_POS187:begin
    write_state <= SETTING_ADDRESS_POS188;
    write_en <= (block_exist[187])?1:0;
    w_color <= color[2255:2244];
    block_exist[187] <= 0;
    block_exist[np187]<= (block_exist[187])?1:0;
end
SETTING_ADDRESS_POS188:begin
    write_state <= DOWN_POS188;
    write_en<=0;
    change_en[np188] <= 1;
    address <= np188;
end
DOWN_POS188:begin
    write_state <= SETTING_ADDRESS_POS189;
    write_en <= (block_exist[188])?1:0;
    w_color <= color[2267:2256];
    block_exist[188] <= 0;
    block_exist[np188]<= (block_exist[188])?1:0;
end
SETTING_ADDRESS_POS189:begin
    write_state <= DOWN_POS189;
    write_en<=0;
    change_en[np189] <= 1;
    address <= np189;
end
DOWN_POS189:begin
    write_state <= SETTING_ADDRESS_POS190;
    write_en <= (block_exist[189])?1:0;
    w_color <= color[2279:2268];
    block_exist[189] <= 0;
    block_exist[np189]<= (block_exist[189])?1:0;
end
SETTING_ADDRESS_POS190:begin
    write_state <= DOWN_POS190;
    write_en<=0;
    change_en[np190] <= 1;
    address <= np190;
end
DOWN_POS190:begin
    write_state <= SETTING_ADDRESS_POS191;
    write_en <= (block_exist[190])?1:0;
    w_color <= color[2291:2280];
    block_exist[190] <= 0;
    block_exist[np190]<= (block_exist[190])?1:0;
end
SETTING_ADDRESS_POS191:begin
    write_state <= DOWN_POS191;
    write_en<=0;
    change_en[np191] <= 1;
    address <= np191;
end
DOWN_POS191:begin
    write_state <= SETTING_ADDRESS_POS192;
    write_en <= (block_exist[191])?1:0;
    w_color <= color[2303:2292];
    block_exist[191] <= 0;
    block_exist[np191]<= (block_exist[191])?1:0;
end
SETTING_ADDRESS_POS192:begin
    write_state <= DOWN_POS192;
    write_en<=0;
    change_en[np192] <= 1;
    address <= np192;
end
DOWN_POS192:begin
    write_state <= SETTING_ADDRESS_POS193;
    write_en <= (block_exist[192])?1:0;
    w_color <= color[2315:2304];
    block_exist[192] <= 0;
    block_exist[np192]<= (block_exist[192])?1:0;
end
SETTING_ADDRESS_POS193:begin
    write_state <= DOWN_POS193;
    write_en<=0;
    change_en[np193] <= 1;
    address <= np193;
end
DOWN_POS193:begin
    write_state <= SETTING_ADDRESS_POS194;
    write_en <= (block_exist[193])?1:0;
    w_color <= color[2327:2316];
    block_exist[193] <= 0;
    block_exist[np193]<= (block_exist[193])?1:0;
end
SETTING_ADDRESS_POS194:begin
    write_state <= DOWN_POS194;
    write_en<=0;
    change_en[np194] <= 1;
    address <= np194;
end
DOWN_POS194:begin
    write_state <= SETTING_ADDRESS_POS195;
    write_en <= (block_exist[194])?1:0;
    w_color <= color[2339:2328];
    block_exist[194] <= 0;
    block_exist[np194]<= (block_exist[194])?1:0;
end
SETTING_ADDRESS_POS195:begin
    write_state <= DOWN_POS195;
    write_en<=0;
    change_en[np195] <= 1;
    address <= np195;
end
DOWN_POS195:begin
    write_state <= SETTING_ADDRESS_POS196;
    write_en <= (block_exist[195])?1:0;
    w_color <= color[2351:2340];
    block_exist[195] <= 0;
    block_exist[np195]<= (block_exist[195])?1:0;
end
SETTING_ADDRESS_POS196:begin
    write_state <= DOWN_POS196;
    write_en<=0;
    change_en[np196] <= 1;
    address <= np196;
end
DOWN_POS196:begin
    write_state <= SETTING_ADDRESS_POS197;
    write_en <= (block_exist[196])?1:0;
    w_color <= color[2363:2352];
    block_exist[196] <= 0;
    block_exist[np196]<= (block_exist[196])?1:0;
end
SETTING_ADDRESS_POS197:begin
    write_state <= DOWN_POS197;
    write_en<=0;
    change_en[np197] <= 1;
    address <= np197;
end
DOWN_POS197:begin
    write_state <= SETTING_ADDRESS_POS198;
    write_en <= (block_exist[197])?1:0;
    w_color <= color[2375:2364];
    block_exist[197] <= 0;
    block_exist[np197]<= (block_exist[197])?1:0;
end
SETTING_ADDRESS_POS198:begin
    write_state <= DOWN_POS198;
    write_en<=0;
    change_en[np198] <= 1;
    address <= np198;
end
DOWN_POS198:begin
    write_state <= SETTING_ADDRESS_POS199;
    write_en <= (block_exist[198])?1:0;
    w_color <= color[2387:2376];
    block_exist[198] <= 0;
    block_exist[np198]<= (block_exist[198])?1:0;
end
SETTING_ADDRESS_POS199:begin
    write_state <= DOWN_POS199;
    write_en<=0;
    change_en[np199] <= 1;
    address <= np199;
end
DOWN_POS199:begin
    write_state <= DOWN_COMPLETE;
    write_en <= (block_exist[199])?1:0;
    w_color <= color[2399:2388];
    block_exist[199] <= 0;
    block_exist[np199]<= (block_exist[199])?1:0;
end
DOWN_COMPLETE:begin
    write_state <=
    change_en[np199] <= 0;
    write_state <= WAIT_WRITE;
    write_en <= 0;
    address <= 0;
    w_color <= 0;
    write_complete<=1;
end
      */      
            default:begin end
        endcase
    end
end
endmodule



