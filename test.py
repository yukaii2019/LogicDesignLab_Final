'''
for i in range (0,200):
    if (i//10)%2==1 :
        if i%2==1 :
            print("color[%d:%d]<=12'h000;"%((i+1)*12-1,i*12))
        else:
            print("color[%d:%d]<=12'h222;"%((i+1)*12-1,i*12))
    else:
        if i%2==1 :
            print("color[%d:%d]<=12'h222;"%((i+1)*12-1,i*12))
        else:
            print("color[%d:%d]<=12'h000;"%((i+1)*12-1,i*12))

'''
'''
k=0
for i in range(5,25):
    print("%d:begin"%(29-i))
    print("    case(horizontal_mod_16)")
    for j in range(15,25):
        print("        %d : {vgaRed, vgaGreen, vgaBlue} = color[%d:%d];"%(j,(k+1)*12-1,k*12))
        k = k+1
    print("        default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;")
    print("    endcase")
    print("end")
    '''
#for i in range (0,20):
    #print("%d : begin tmp_color[%d:%d] = (block_exist[%d])? w_color: ; end"%(i,(i+1)*12-1,(i-1)*12)
'''
for i in range (0,200):
    if (i//10)%2==1 :
        if i%2==1 :
            print("%d : begin tmp_color[%d:%d] = (block_exist[%d])? w_color:12'h000; end"%(i,(i+1)*12-1,(i)*12,i))
        else:
            print("%d : begin tmp_color[%d:%d] = (block_exist[%d])? w_color:12'h222; end"%(i,(i+1)*12-1,(i)*12,i))

    else:
        if i%2==1 :
            print("%d : begin tmp_color[%d:%d] = (block_exist[%d])? w_color:12'h222; end"%(i,(i+1)*12-1,(i)*12,i))

        else:
            print("%d : begin tmp_color[%d:%d] = (block_exist[%d])? w_color:12'h000; end"%(i,(i+1)*12-1,(i)*12,i))
'''
'''
for i in range (0,200):
    if (i//10)%2==1 :
        if i%2==1 :
            print("%d : begin tmp_color[%d:%d] = (change_en[%d])?w_color:color[%d:%d]; end"%(i,(i+1)*12-1,(i)*12,i,(i+1)*12-1,(i)*12))
        else:
            print("%d : begin tmp_color[%d:%d] = (change_en[%d])?w_color:color[%d:%d]; end"%(i,(i+1)*12-1,(i)*12,i,(i+1)*12-1,(i)*12))

    else:
        if i%2==1 :
            print("%d : begin tmp_color[%d:%d] = (change_en[%d])?w_color:color[%d:%d]; end"%(i,(i+1)*12-1,(i)*12,i,(i+1)*12-1,(i)*12))

        else:
            print("%d : begin tmp_color[%d:%d] = (change_en[%d])?w_color:color[%d:%d]; end"%(i,(i+1)*12-1,(i)*12,i,(i+1)*12-1,(i)*12))
'''
'''
for i in range(0,20):
    print("row[%d] = block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d]&&block_exist[%d];"%(i,10*i,10*i+1,10*i+2,10*i+3,10*i+4,10*i+5,10*i+6,10*i+7,10*i+8,10*i+9))

'''
'''
for i in range(1,21):
    print("parameter [4:0] check_row%d = 5'b"%(i)+"{0:05b};".format(i-1))
'''
'''
for i in range (1,21):
    print("CHECK_ROW%d:begin"%i)
    print("    tmp_state = CHECK_ROW%d;"%(i+1))
    print("    tmp_count = (row[%d]==1)?count+1:count;"%(i-1))
    print("    if(row[%d]==1)begin"%(i-1))
    print("        case(count)")
    print("            0:tmp_row1 = %d;"%(i-1))
    print("            1:tmp_row2 = %d;"%(i-1))
    print("            2:tmp_row3 = %d;"%(i-1))
    print("            3:tmp_row4 = %d;"%(i-1))
    print("            default:")
    print("        endcase")
    print("    end")
    print("end")
'''
'''
for i in range (0,20):
    print("%d:begin"%i)
    print("    tmp_b1[199:%d] = %d'b"%((i+1)*10,200-(i+1)*10),end='')
    for j in range (0,200-(i+1)*10):
        print("1",end = "")
    print(";")
    print("end")
'''
'''
for i in range(10,200):
    print("parameter [8:0] DOWN_POS%d = 9'b"%(i)+"{0:09b};".format(i+6))
'''
'''
for i in range(10,200):
    print("parameter [8:0] SETTING_ADDRESS_POS%d = 9'b"%(i)+"{0:09b};".format(i+196))
'''
'''
for i in range (10,200):
    print(".np%d(np%d)"%(i,i),end=",")
    if(i%10==9):
        print("")
'''

'''
for i in range (1,5):
    for j in range (0,10):
        print("assign p%d = (row%d == 20)?row%d*10+%d:200;"%((i-1)*10+j,i,i,j))
'''
'''
for i in range (0,40):
    print(".p%d(p%d)"%(i,i),end=",")
'''
'''
for i in range(0,10):
    print("block_exist[p%d] <= 0;"%i)
'''
'''
for i in range(10,200):
    print("assign np%d = %d-(b1[%d]+b2[%d]+b3[%d]+b4[%d])*10;"%(i,i,i,i,i,i))
'''
'''
for i in range(10,200):
    print("assign c%d = color[%d:%d];"%(i,(i+1)*12-1,i*12))
'''
for i in range (10,200):
    print("SETTING_ADDRESS_POS%d:begin"%i)
    print("    write_state <= DOWN_POS%d;"%i)
    print("    write_en<=0;")
    print("    change_en[np%d] <= 1;"%i)
    print("    address <= np%d;"%i)
    print("end")
    print("DOWN_POS%d:begin"%i)
    print("    write_state <= SETTING_ADDRESS_POS%d;"%(i+1))
    print("    write_en <= (block_exist[%d])?1:0;"%i)
    print("    w_color <= color[%d:%d];"%(i*12+11,i*12))
    print("    block_exist[%d] <= 0;"%i)
    print("    block_exist[np%d]<= (block_exist[%d])?1:0;"%(i,i))
    print("end")