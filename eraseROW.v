module find_rows_should_be_earsed(row,block_exist);
output reg [19:0]row;
input [239:0]block_exist;
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
input [239:0]block_exist;
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
        row1 <= 25;
        row2 <= 25;
        row3 <= 25;
        row4 <= 25;
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
            tmp_row1 = (eraseROW_en)?25:row1;
            tmp_row2 = (eraseROW_en)?25:row2;
            tmp_row3 = (eraseROW_en)?25:row3;
            tmp_row4 = (eraseROW_en)?25:row4;
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

module erased_row_block_pos(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39,row1,row2,row3,row4);

output [7:0]p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39;
input [4:0]row1,row2,row3,row4;
assign p0 = (row1 != 25)?row1*10+0:240;
assign p1 = (row1 != 25)?row1*10+1:240;
assign p2 = (row1 != 25)?row1*10+2:240;
assign p3 = (row1 != 25)?row1*10+3:240;
assign p4 = (row1 != 25)?row1*10+4:240;
assign p5 = (row1 != 25)?row1*10+5:240;
assign p6 = (row1 != 25)?row1*10+6:240;
assign p7 = (row1 != 25)?row1*10+7:240;
assign p8 = (row1 != 25)?row1*10+8:240;
assign p9 = (row1 != 25)?row1*10+9:240;
assign p10 = (row2 != 25)?row2*10+0:240;
assign p11 = (row2 != 25)?row2*10+1:240;
assign p12 = (row2 != 25)?row2*10+2:240;
assign p13 = (row2 != 25)?row2*10+3:240;
assign p14 = (row2 != 25)?row2*10+4:240;
assign p15 = (row2 != 25)?row2*10+5:240;
assign p16 = (row2 != 25)?row2*10+6:240;
assign p17 = (row2 != 25)?row2*10+7:240;
assign p18 = (row2 != 25)?row2*10+8:240;
assign p19 = (row2 != 25)?row2*10+9:240;
assign p20 = (row3 != 25)?row3*10+0:240;
assign p21 = (row3 != 25)?row3*10+1:240;
assign p22 = (row3 != 25)?row3*10+2:240;
assign p23 = (row3 != 25)?row3*10+3:240;
assign p24 = (row3 != 25)?row3*10+4:240;
assign p25 = (row3 != 25)?row3*10+5:240;
assign p26 = (row3 != 25)?row3*10+6:240;
assign p27 = (row3 != 25)?row3*10+7:240;
assign p28 = (row3 != 25)?row3*10+8:240;
assign p29 = (row3 != 25)?row3*10+9:240;
assign p30 = (row4 != 25)?row4*10+0:240;
assign p31 = (row4 != 25)?row4*10+1:240;
assign p32 = (row4 != 25)?row4*10+2:240;
assign p33 = (row4 != 25)?row4*10+3:240;
assign p34 = (row4 != 25)?row4*10+4:240;
assign p35 = (row4 != 25)?row4*10+5:240;
assign p36 = (row4 != 25)?row4*10+6:240;
assign p37 = (row4 != 25)?row4*10+7:240;
assign p38 = (row4 != 25)?row4*10+8:240;
assign p39 = (row4 != 25)?row4*10+9:240;
endmodule