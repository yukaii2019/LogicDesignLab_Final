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