module shape (w_color,color_pos1,color_pos2,color_pos3,color_pos4,block,status,pos_x,pos_y);
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
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x-1; 
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y+1)*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-1;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y-1)*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
            endcase
        end
        `BLOCK_L:begin
            w_color = `COLOR_L;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x+1; 
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y-1)*10+pos_x  ;
                    color_pos4 = (pos_y-1)*10+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-1;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x-1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x-1;
                    color_pos3 = (pos_y+1)*10+pos_x  ;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
            endcase
        end
        `BLOCK_S:begin
            w_color = `COLOR_S;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x  ; 
                    color_pos3 = (pos_y+1)*10+pos_x+1;
                    color_pos4 = (pos_y  )*10+pos_x-1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x+1;
                    color_pos3 = (pos_y-1)*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x-1;
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
            endcase
        end
        `BLOCK_T:begin
            w_color = `COLOR_T;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x  ; 
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-1;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
            endcase
        end
        `BLOCK_Z:begin
            w_color = `COLOR_Z;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x-1; 
                    color_pos3 = (pos_y+1)*10+pos_x  ;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x+1;
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-1;
                    color_pos3 = (pos_y-1)*10+pos_x  ;
                    color_pos4 = (pos_y-1)*10+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x-1;
                end
            endcase
        end
        `BLOCK_I:begin
            w_color = `COLOR_I;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y  )*10+pos_x-1; 
                    color_pos3 = (pos_y  )*10+pos_x+1;
                    color_pos4 = (pos_y  )*10+pos_x+2;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x  ;
                    color_pos3 = (pos_y-1)*10+pos_x  ;
                    color_pos4 = (pos_y-2)*10+pos_x  ;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-2;
                    color_pos3 = (pos_y  )*10+pos_x-1;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+2)*10+pos_x  ;
                    color_pos3 = (pos_y+1)*10+pos_x  ;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
            endcase
        end
        `BLOCK_O:begin
            w_color = `COLOR_O;
            case(status)
                `BLOCK_STATUS_0:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;  //center
                    color_pos2 = (pos_y+1)*10+pos_x  ; 
                    color_pos3 = (pos_y+1)*10+pos_x+1;
                    color_pos4 = (pos_y  )*10+pos_x+1;
                end 
                `BLOCK_STATUS_R:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x+1;
                    color_pos3 = (pos_y-1)*10+pos_x  ;
                    color_pos4 = (pos_y-1)*10+pos_x+1;
                end
                `BLOCK_STATUS_2:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y  )*10+pos_x-1;
                    color_pos3 = (pos_y-1)*10+pos_x-1;
                    color_pos4 = (pos_y-1)*10+pos_x  ;
                end
                `BLOCK_STATUS_L:begin 
                    color_pos1 = (pos_y  )*10+pos_x  ;
                    color_pos2 = (pos_y+1)*10+pos_x-1;
                    color_pos3 = (pos_y+1)*10+pos_x  ;
                    color_pos4 = (pos_y  )*10+pos_x-1;
                end
            endcase
        end
        default:begin end
    endcase
end
endmodule