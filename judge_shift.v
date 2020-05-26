`include "C:\Users\ACER\Desktop\logic_design_lab\FINAL\FinalProjectRepo\global.v"
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
input [239:0]block_exist;
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