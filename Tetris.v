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

`define WAIT_BLOCK_EN 2'b00
`define BLOCK_DOWN 2'b01
`define BLOCK_SETTLE 2'b10
`define SET_START_WRITE0 2'b11

`define COLOR_J 12'h00f
`define COLOR_L 12'hf60
`define COLOR_S 12'h0f0
`define COLOR_T 12'hd7d
`define COLOR_Z 12'hf00
`define COLOR_I 12'h0ff
`define COLOR_O 12'hff0

module Tetris(vgaRed,vgaGreen,vgaBlue,hsync,vsync,clk,rst,btn_L,btn_R,btn_U,btn_D,generate_block);
input clk;
input rst;
input generate_block;
output [3:0] vgaRed;
output [3:0] vgaGreen;
output [3:0] vgaBlue;
output hsync;
output vsync;

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


clock_divisor clk_wiz_0_inst(.clk(clk),.clk1(clk_25MHz),.clk22(clk_22),.clkBlockDown(clkBlockDown));
pixel_gen pg (.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.h_cnt(h_cnt),.v_cnt(v_cnt),.valid(valid),.color(color));
vga_controller vga_inst(.pclk(clk_25MHz),.reset(rst),.hsync(hsync),.vsync(vsync),.valid(valid),.h_cnt(h_cnt),.v_cnt(v_cnt));
BackGroundMemory bm (.color(color),.clk(clk),.rst(rst),.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist));
putBlock pb (.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.generate_block(generate_block),
             .block_type(`BLOCK_J),.block_status(`BLOCK_STATUS_0),.rst(rst),.clk(clk),.turn_right(op_btn_U),.turn_left(op_btn_D),
             .shift_left(op_btn_L),.shift_right(op_btn_R));
//putblock pb (.outBackground(),.blockType(),.R_rotate(),.L_rotate(),.blockState(),.rst(),.clk(),.background(),.clkBlockDown(),.start_position());

endmodule

module BackGroundMemory(color,clk,rst,write_en,address,w_color,block_exist);
output reg [2399:0]color;
input clk;
input rst;
input write_en;
input [7:0]address;
input [11:0]w_color;
input [199:0]block_exist;
reg [2399:0]tmp_color;

always@(*)begin
    if(write_en)begin
        case(address)
            0 : begin tmp_color[11:0] = (block_exist[0])? w_color:12'h000; end
            1 : begin tmp_color[23:12] = (block_exist[1])? w_color:12'h222; end
            2 : begin tmp_color[35:24] = (block_exist[2])? w_color:12'h000; end
            3 : begin tmp_color[47:36] = (block_exist[3])? w_color:12'h222; end
            4 : begin tmp_color[59:48] = (block_exist[4])? w_color:12'h000; end
            5 : begin tmp_color[71:60] = (block_exist[5])? w_color:12'h222; end
            6 : begin tmp_color[83:72] = (block_exist[6])? w_color:12'h000; end
            7 : begin tmp_color[95:84] = (block_exist[7])? w_color:12'h222; end
            8 : begin tmp_color[107:96] = (block_exist[8])? w_color:12'h000; end
            9 : begin tmp_color[119:108] = (block_exist[9])? w_color:12'h222; end
            10 : begin tmp_color[131:120] = (block_exist[10])? w_color:12'h222; end
            11 : begin tmp_color[143:132] = (block_exist[11])? w_color:12'h000; end
            12 : begin tmp_color[155:144] = (block_exist[12])? w_color:12'h222; end
            13 : begin tmp_color[167:156] = (block_exist[13])? w_color:12'h000; end
            14 : begin tmp_color[179:168] = (block_exist[14])? w_color:12'h222; end
            15 : begin tmp_color[191:180] = (block_exist[15])? w_color:12'h000; end
            16 : begin tmp_color[203:192] = (block_exist[16])? w_color:12'h222; end
            17 : begin tmp_color[215:204] = (block_exist[17])? w_color:12'h000; end
            18 : begin tmp_color[227:216] = (block_exist[18])? w_color:12'h222; end
            19 : begin tmp_color[239:228] = (block_exist[19])? w_color:12'h000; end
            20 : begin tmp_color[251:240] = (block_exist[20])? w_color:12'h000; end
            21 : begin tmp_color[263:252] = (block_exist[21])? w_color:12'h222; end
            22 : begin tmp_color[275:264] = (block_exist[22])? w_color:12'h000; end
            23 : begin tmp_color[287:276] = (block_exist[23])? w_color:12'h222; end
            24 : begin tmp_color[299:288] = (block_exist[24])? w_color:12'h000; end
            25 : begin tmp_color[311:300] = (block_exist[25])? w_color:12'h222; end
            26 : begin tmp_color[323:312] = (block_exist[26])? w_color:12'h000; end
            27 : begin tmp_color[335:324] = (block_exist[27])? w_color:12'h222; end
            28 : begin tmp_color[347:336] = (block_exist[28])? w_color:12'h000; end
            29 : begin tmp_color[359:348] = (block_exist[29])? w_color:12'h222; end
            30 : begin tmp_color[371:360] = (block_exist[30])? w_color:12'h222; end
            31 : begin tmp_color[383:372] = (block_exist[31])? w_color:12'h000; end
            32 : begin tmp_color[395:384] = (block_exist[32])? w_color:12'h222; end
            33 : begin tmp_color[407:396] = (block_exist[33])? w_color:12'h000; end
            34 : begin tmp_color[419:408] = (block_exist[34])? w_color:12'h222; end
            35 : begin tmp_color[431:420] = (block_exist[35])? w_color:12'h000; end
            36 : begin tmp_color[443:432] = (block_exist[36])? w_color:12'h222; end
            37 : begin tmp_color[455:444] = (block_exist[37])? w_color:12'h000; end
            38 : begin tmp_color[467:456] = (block_exist[38])? w_color:12'h222; end
            39 : begin tmp_color[479:468] = (block_exist[39])? w_color:12'h000; end
            40 : begin tmp_color[491:480] = (block_exist[40])? w_color:12'h000; end
            41 : begin tmp_color[503:492] = (block_exist[41])? w_color:12'h222; end
            42 : begin tmp_color[515:504] = (block_exist[42])? w_color:12'h000; end
            43 : begin tmp_color[527:516] = (block_exist[43])? w_color:12'h222; end
            44 : begin tmp_color[539:528] = (block_exist[44])? w_color:12'h000; end
            45 : begin tmp_color[551:540] = (block_exist[45])? w_color:12'h222; end
            46 : begin tmp_color[563:552] = (block_exist[46])? w_color:12'h000; end
            47 : begin tmp_color[575:564] = (block_exist[47])? w_color:12'h222; end
            48 : begin tmp_color[587:576] = (block_exist[48])? w_color:12'h000; end
            49 : begin tmp_color[599:588] = (block_exist[49])? w_color:12'h222; end
            50 : begin tmp_color[611:600] = (block_exist[50])? w_color:12'h222; end
            51 : begin tmp_color[623:612] = (block_exist[51])? w_color:12'h000; end
            52 : begin tmp_color[635:624] = (block_exist[52])? w_color:12'h222; end
            53 : begin tmp_color[647:636] = (block_exist[53])? w_color:12'h000; end
            54 : begin tmp_color[659:648] = (block_exist[54])? w_color:12'h222; end
            55 : begin tmp_color[671:660] = (block_exist[55])? w_color:12'h000; end
            56 : begin tmp_color[683:672] = (block_exist[56])? w_color:12'h222; end
            57 : begin tmp_color[695:684] = (block_exist[57])? w_color:12'h000; end
            58 : begin tmp_color[707:696] = (block_exist[58])? w_color:12'h222; end
            59 : begin tmp_color[719:708] = (block_exist[59])? w_color:12'h000; end
            60 : begin tmp_color[731:720] = (block_exist[60])? w_color:12'h000; end
            61 : begin tmp_color[743:732] = (block_exist[61])? w_color:12'h222; end
            62 : begin tmp_color[755:744] = (block_exist[62])? w_color:12'h000; end
            63 : begin tmp_color[767:756] = (block_exist[63])? w_color:12'h222; end
            64 : begin tmp_color[779:768] = (block_exist[64])? w_color:12'h000; end
            65 : begin tmp_color[791:780] = (block_exist[65])? w_color:12'h222; end
            66 : begin tmp_color[803:792] = (block_exist[66])? w_color:12'h000; end
            67 : begin tmp_color[815:804] = (block_exist[67])? w_color:12'h222; end
            68 : begin tmp_color[827:816] = (block_exist[68])? w_color:12'h000; end
            69 : begin tmp_color[839:828] = (block_exist[69])? w_color:12'h222; end
            70 : begin tmp_color[851:840] = (block_exist[70])? w_color:12'h222; end
            71 : begin tmp_color[863:852] = (block_exist[71])? w_color:12'h000; end
            72 : begin tmp_color[875:864] = (block_exist[72])? w_color:12'h222; end
            73 : begin tmp_color[887:876] = (block_exist[73])? w_color:12'h000; end
            74 : begin tmp_color[899:888] = (block_exist[74])? w_color:12'h222; end
            75 : begin tmp_color[911:900] = (block_exist[75])? w_color:12'h000; end
            76 : begin tmp_color[923:912] = (block_exist[76])? w_color:12'h222; end
            77 : begin tmp_color[935:924] = (block_exist[77])? w_color:12'h000; end
            78 : begin tmp_color[947:936] = (block_exist[78])? w_color:12'h222; end
            79 : begin tmp_color[959:948] = (block_exist[79])? w_color:12'h000; end
            80 : begin tmp_color[971:960] = (block_exist[80])? w_color:12'h000; end
            81 : begin tmp_color[983:972] = (block_exist[81])? w_color:12'h222; end
            82 : begin tmp_color[995:984] = (block_exist[82])? w_color:12'h000; end
            83 : begin tmp_color[1007:996] = (block_exist[83])? w_color:12'h222; end
            84 : begin tmp_color[1019:1008] = (block_exist[84])? w_color:12'h000; end
            85 : begin tmp_color[1031:1020] = (block_exist[85])? w_color:12'h222; end
            86 : begin tmp_color[1043:1032] = (block_exist[86])? w_color:12'h000; end
            87 : begin tmp_color[1055:1044] = (block_exist[87])? w_color:12'h222; end
            88 : begin tmp_color[1067:1056] = (block_exist[88])? w_color:12'h000; end
            89 : begin tmp_color[1079:1068] = (block_exist[89])? w_color:12'h222; end
            90 : begin tmp_color[1091:1080] = (block_exist[90])? w_color:12'h222; end
            91 : begin tmp_color[1103:1092] = (block_exist[91])? w_color:12'h000; end
            92 : begin tmp_color[1115:1104] = (block_exist[92])? w_color:12'h222; end
            93 : begin tmp_color[1127:1116] = (block_exist[93])? w_color:12'h000; end
            94 : begin tmp_color[1139:1128] = (block_exist[94])? w_color:12'h222; end
            95 : begin tmp_color[1151:1140] = (block_exist[95])? w_color:12'h000; end
            96 : begin tmp_color[1163:1152] = (block_exist[96])? w_color:12'h222; end
            97 : begin tmp_color[1175:1164] = (block_exist[97])? w_color:12'h000; end
            98 : begin tmp_color[1187:1176] = (block_exist[98])? w_color:12'h222; end
            99 : begin tmp_color[1199:1188] = (block_exist[99])? w_color:12'h000; end
            100 : begin tmp_color[1211:1200] = (block_exist[100])? w_color:12'h000; end
            101 : begin tmp_color[1223:1212] = (block_exist[101])? w_color:12'h222; end
            102 : begin tmp_color[1235:1224] = (block_exist[102])? w_color:12'h000; end
            103 : begin tmp_color[1247:1236] = (block_exist[103])? w_color:12'h222; end
            104 : begin tmp_color[1259:1248] = (block_exist[104])? w_color:12'h000; end
            105 : begin tmp_color[1271:1260] = (block_exist[105])? w_color:12'h222; end
            106 : begin tmp_color[1283:1272] = (block_exist[106])? w_color:12'h000; end
            107 : begin tmp_color[1295:1284] = (block_exist[107])? w_color:12'h222; end
            108 : begin tmp_color[1307:1296] = (block_exist[108])? w_color:12'h000; end
            109 : begin tmp_color[1319:1308] = (block_exist[109])? w_color:12'h222; end
            110 : begin tmp_color[1331:1320] = (block_exist[110])? w_color:12'h222; end
            111 : begin tmp_color[1343:1332] = (block_exist[111])? w_color:12'h000; end
            112 : begin tmp_color[1355:1344] = (block_exist[112])? w_color:12'h222; end
            113 : begin tmp_color[1367:1356] = (block_exist[113])? w_color:12'h000; end
            114 : begin tmp_color[1379:1368] = (block_exist[114])? w_color:12'h222; end
            115 : begin tmp_color[1391:1380] = (block_exist[115])? w_color:12'h000; end
            116 : begin tmp_color[1403:1392] = (block_exist[116])? w_color:12'h222; end
            117 : begin tmp_color[1415:1404] = (block_exist[117])? w_color:12'h000; end
            118 : begin tmp_color[1427:1416] = (block_exist[118])? w_color:12'h222; end
            119 : begin tmp_color[1439:1428] = (block_exist[119])? w_color:12'h000; end
            120 : begin tmp_color[1451:1440] = (block_exist[120])? w_color:12'h000; end
            121 : begin tmp_color[1463:1452] = (block_exist[121])? w_color:12'h222; end
            122 : begin tmp_color[1475:1464] = (block_exist[122])? w_color:12'h000; end
            123 : begin tmp_color[1487:1476] = (block_exist[123])? w_color:12'h222; end
            124 : begin tmp_color[1499:1488] = (block_exist[124])? w_color:12'h000; end
            125 : begin tmp_color[1511:1500] = (block_exist[125])? w_color:12'h222; end
            126 : begin tmp_color[1523:1512] = (block_exist[126])? w_color:12'h000; end
            127 : begin tmp_color[1535:1524] = (block_exist[127])? w_color:12'h222; end
            128 : begin tmp_color[1547:1536] = (block_exist[128])? w_color:12'h000; end
            129 : begin tmp_color[1559:1548] = (block_exist[129])? w_color:12'h222; end
            130 : begin tmp_color[1571:1560] = (block_exist[130])? w_color:12'h222; end
            131 : begin tmp_color[1583:1572] = (block_exist[131])? w_color:12'h000; end
            132 : begin tmp_color[1595:1584] = (block_exist[132])? w_color:12'h222; end
            133 : begin tmp_color[1607:1596] = (block_exist[133])? w_color:12'h000; end
            134 : begin tmp_color[1619:1608] = (block_exist[134])? w_color:12'h222; end
            135 : begin tmp_color[1631:1620] = (block_exist[135])? w_color:12'h000; end
            136 : begin tmp_color[1643:1632] = (block_exist[136])? w_color:12'h222; end
            137 : begin tmp_color[1655:1644] = (block_exist[137])? w_color:12'h000; end
            138 : begin tmp_color[1667:1656] = (block_exist[138])? w_color:12'h222; end
            139 : begin tmp_color[1679:1668] = (block_exist[139])? w_color:12'h000; end
            140 : begin tmp_color[1691:1680] = (block_exist[140])? w_color:12'h000; end
            141 : begin tmp_color[1703:1692] = (block_exist[141])? w_color:12'h222; end
            142 : begin tmp_color[1715:1704] = (block_exist[142])? w_color:12'h000; end
            143 : begin tmp_color[1727:1716] = (block_exist[143])? w_color:12'h222; end
            144 : begin tmp_color[1739:1728] = (block_exist[144])? w_color:12'h000; end
            145 : begin tmp_color[1751:1740] = (block_exist[145])? w_color:12'h222; end
            146 : begin tmp_color[1763:1752] = (block_exist[146])? w_color:12'h000; end
            147 : begin tmp_color[1775:1764] = (block_exist[147])? w_color:12'h222; end
            148 : begin tmp_color[1787:1776] = (block_exist[148])? w_color:12'h000; end
            149 : begin tmp_color[1799:1788] = (block_exist[149])? w_color:12'h222; end
            150 : begin tmp_color[1811:1800] = (block_exist[150])? w_color:12'h222; end
            151 : begin tmp_color[1823:1812] = (block_exist[151])? w_color:12'h000; end
            152 : begin tmp_color[1835:1824] = (block_exist[152])? w_color:12'h222; end
            153 : begin tmp_color[1847:1836] = (block_exist[153])? w_color:12'h000; end
            154 : begin tmp_color[1859:1848] = (block_exist[154])? w_color:12'h222; end
            155 : begin tmp_color[1871:1860] = (block_exist[155])? w_color:12'h000; end
            156 : begin tmp_color[1883:1872] = (block_exist[156])? w_color:12'h222; end
            157 : begin tmp_color[1895:1884] = (block_exist[157])? w_color:12'h000; end
            158 : begin tmp_color[1907:1896] = (block_exist[158])? w_color:12'h222; end
            159 : begin tmp_color[1919:1908] = (block_exist[159])? w_color:12'h000; end
            160 : begin tmp_color[1931:1920] = (block_exist[160])? w_color:12'h000; end
            161 : begin tmp_color[1943:1932] = (block_exist[161])? w_color:12'h222; end
            162 : begin tmp_color[1955:1944] = (block_exist[162])? w_color:12'h000; end
            163 : begin tmp_color[1967:1956] = (block_exist[163])? w_color:12'h222; end
            164 : begin tmp_color[1979:1968] = (block_exist[164])? w_color:12'h000; end
            165 : begin tmp_color[1991:1980] = (block_exist[165])? w_color:12'h222; end
            166 : begin tmp_color[2003:1992] = (block_exist[166])? w_color:12'h000; end
            167 : begin tmp_color[2015:2004] = (block_exist[167])? w_color:12'h222; end
            168 : begin tmp_color[2027:2016] = (block_exist[168])? w_color:12'h000; end
            169 : begin tmp_color[2039:2028] = (block_exist[169])? w_color:12'h222; end
            170 : begin tmp_color[2051:2040] = (block_exist[170])? w_color:12'h222; end
            171 : begin tmp_color[2063:2052] = (block_exist[171])? w_color:12'h000; end
            172 : begin tmp_color[2075:2064] = (block_exist[172])? w_color:12'h222; end
            173 : begin tmp_color[2087:2076] = (block_exist[173])? w_color:12'h000; end
            174 : begin tmp_color[2099:2088] = (block_exist[174])? w_color:12'h222; end
            175 : begin tmp_color[2111:2100] = (block_exist[175])? w_color:12'h000; end
            176 : begin tmp_color[2123:2112] = (block_exist[176])? w_color:12'h222; end
            177 : begin tmp_color[2135:2124] = (block_exist[177])? w_color:12'h000; end
            178 : begin tmp_color[2147:2136] = (block_exist[178])? w_color:12'h222; end
            179 : begin tmp_color[2159:2148] = (block_exist[179])? w_color:12'h000; end
            180 : begin tmp_color[2171:2160] = (block_exist[180])? w_color:12'h000; end
            181 : begin tmp_color[2183:2172] = (block_exist[181])? w_color:12'h222; end
            182 : begin tmp_color[2195:2184] = (block_exist[182])? w_color:12'h000; end
            183 : begin tmp_color[2207:2196] = (block_exist[183])? w_color:12'h222; end
            184 : begin tmp_color[2219:2208] = (block_exist[184])? w_color:12'h000; end
            185 : begin tmp_color[2231:2220] = (block_exist[185])? w_color:12'h222; end
            186 : begin tmp_color[2243:2232] = (block_exist[186])? w_color:12'h000; end
            187 : begin tmp_color[2255:2244] = (block_exist[187])? w_color:12'h222; end
            188 : begin tmp_color[2267:2256] = (block_exist[188])? w_color:12'h000; end
            189 : begin tmp_color[2279:2268] = (block_exist[189])? w_color:12'h222; end
            190 : begin tmp_color[2291:2280] = (block_exist[190])? w_color:12'h222; end
            191 : begin tmp_color[2303:2292] = (block_exist[191])? w_color:12'h000; end
            192 : begin tmp_color[2315:2304] = (block_exist[192])? w_color:12'h222; end
            193 : begin tmp_color[2327:2316] = (block_exist[193])? w_color:12'h000; end
            194 : begin tmp_color[2339:2328] = (block_exist[194])? w_color:12'h222; end
            195 : begin tmp_color[2351:2340] = (block_exist[195])? w_color:12'h000; end
            196 : begin tmp_color[2363:2352] = (block_exist[196])? w_color:12'h222; end
            197 : begin tmp_color[2375:2364] = (block_exist[197])? w_color:12'h000; end
            198 : begin tmp_color[2387:2376] = (block_exist[198])? w_color:12'h222; end
            199 : begin tmp_color[2399:2388] = (block_exist[199])? w_color:12'h000; end
            default:begin end
        endcase
    end
    else begin
            tmp_color[2399:0] = color[2399:0];
    end
end
always@(posedge clk or posedge rst)begin
    if(rst)begin
        color[11:0]<=12'h000;
        color[23:12]<=12'h222;
        color[35:24]<=12'h000;
        color[47:36]<=12'h222;
        color[59:48]<=12'h000;
        color[71:60]<=12'h222;
        color[83:72]<=12'h000;
        color[95:84]<=12'h222;
        color[107:96]<=12'h000;
        color[119:108]<=12'h222;
        color[131:120]<=12'h222;
        color[143:132]<=12'h000;
        color[155:144]<=12'h222;
        color[167:156]<=12'h000;
        color[179:168]<=12'h222;
        color[191:180]<=12'h000;
        color[203:192]<=12'h222;
        color[215:204]<=12'h000;
        color[227:216]<=12'h222;
        color[239:228]<=12'h000;
        color[251:240]<=12'h000;
        color[263:252]<=12'h222;
        color[275:264]<=12'h000;
        color[287:276]<=12'h222;
        color[299:288]<=12'h000;
        color[311:300]<=12'h222;
        color[323:312]<=12'h000;
        color[335:324]<=12'h222;
        color[347:336]<=12'h000;
        color[359:348]<=12'h222;
        color[371:360]<=12'h222;
        color[383:372]<=12'h000;
        color[395:384]<=12'h222;
        color[407:396]<=12'h000;
        color[419:408]<=12'h222;
        color[431:420]<=12'h000;
        color[443:432]<=12'h222;
        color[455:444]<=12'h000;
        color[467:456]<=12'h222;
        color[479:468]<=12'h000;
        color[491:480]<=12'h000;
        color[503:492]<=12'h222;
        color[515:504]<=12'h000;
        color[527:516]<=12'h222;
        color[539:528]<=12'h000;
        color[551:540]<=12'h222;
        color[563:552]<=12'h000;
        color[575:564]<=12'h222;
        color[587:576]<=12'h000;
        color[599:588]<=12'h222;
        color[611:600]<=12'h222;
        color[623:612]<=12'h000;
        color[635:624]<=12'h222;
        color[647:636]<=12'h000;
        color[659:648]<=12'h222;
        color[671:660]<=12'h000;
        color[683:672]<=12'h222;
        color[695:684]<=12'h000;
        color[707:696]<=12'h222;
        color[719:708]<=12'h000;
        color[731:720]<=12'h000;
        color[743:732]<=12'h222;
        color[755:744]<=12'h000;
        color[767:756]<=12'h222;
        color[779:768]<=12'h000;
        color[791:780]<=12'h222;
        color[803:792]<=12'h000;
        color[815:804]<=12'h222;
        color[827:816]<=12'h000;
        color[839:828]<=12'h222;
        color[851:840]<=12'h222;
        color[863:852]<=12'h000;
        color[875:864]<=12'h222;
        color[887:876]<=12'h000;
        color[899:888]<=12'h222;
        color[911:900]<=12'h000;
        color[923:912]<=12'h222;
        color[935:924]<=12'h000;
        color[947:936]<=12'h222;
        color[959:948]<=12'h000;
        color[971:960]<=12'h000;
        color[983:972]<=12'h222;
        color[995:984]<=12'h000;
        color[1007:996]<=12'h222;
        color[1019:1008]<=12'h000;
        color[1031:1020]<=12'h222;
        color[1043:1032]<=12'h000;
        color[1055:1044]<=12'h222;
        color[1067:1056]<=12'h000;
        color[1079:1068]<=12'h222;
        color[1091:1080]<=12'h222;
        color[1103:1092]<=12'h000;
        color[1115:1104]<=12'h222;
        color[1127:1116]<=12'h000;
        color[1139:1128]<=12'h222;
        color[1151:1140]<=12'h000;
        color[1163:1152]<=12'h222;
        color[1175:1164]<=12'h000;
        color[1187:1176]<=12'h222;
        color[1199:1188]<=12'h000;
        color[1211:1200]<=12'h000;
        color[1223:1212]<=12'h222;
        color[1235:1224]<=12'h000;
        color[1247:1236]<=12'h222;
        color[1259:1248]<=12'h000;
        color[1271:1260]<=12'h222;
        color[1283:1272]<=12'h000;
        color[1295:1284]<=12'h222;
        color[1307:1296]<=12'h000;
        color[1319:1308]<=12'h222;
        color[1331:1320]<=12'h222;
        color[1343:1332]<=12'h000;
        color[1355:1344]<=12'h222;
        color[1367:1356]<=12'h000;
        color[1379:1368]<=12'h222;
        color[1391:1380]<=12'h000;
        color[1403:1392]<=12'h222;
        color[1415:1404]<=12'h000;
        color[1427:1416]<=12'h222;
        color[1439:1428]<=12'h000;
        color[1451:1440]<=12'h000;
        color[1463:1452]<=12'h222;
        color[1475:1464]<=12'h000;
        color[1487:1476]<=12'h222;
        color[1499:1488]<=12'h000;
        color[1511:1500]<=12'h222;
        color[1523:1512]<=12'h000;
        color[1535:1524]<=12'h222;
        color[1547:1536]<=12'h000;
        color[1559:1548]<=12'h222;
        color[1571:1560]<=12'h222;
        color[1583:1572]<=12'h000;
        color[1595:1584]<=12'h222;
        color[1607:1596]<=12'h000;
        color[1619:1608]<=12'h222;
        color[1631:1620]<=12'h000;
        color[1643:1632]<=12'h222;
        color[1655:1644]<=12'h000;
        color[1667:1656]<=12'h222;
        color[1679:1668]<=12'h000;
        color[1691:1680]<=12'h000;
        color[1703:1692]<=12'h222;
        color[1715:1704]<=12'h000;
        color[1727:1716]<=12'h222;
        color[1739:1728]<=12'h000;
        color[1751:1740]<=12'h222;
        color[1763:1752]<=12'h000;
        color[1775:1764]<=12'h222;
        color[1787:1776]<=12'h000;
        color[1799:1788]<=12'h222;
        color[1811:1800]<=12'h222;
        color[1823:1812]<=12'h000;
        color[1835:1824]<=12'h222;
        color[1847:1836]<=12'h000;
        color[1859:1848]<=12'h222;
        color[1871:1860]<=12'h000;
        color[1883:1872]<=12'h222;
        color[1895:1884]<=12'h000;
        color[1907:1896]<=12'h222;
        color[1919:1908]<=12'h000;
        color[1931:1920]<=12'h000;
        color[1943:1932]<=12'h222;
        color[1955:1944]<=12'h000;
        color[1967:1956]<=12'h222;
        color[1979:1968]<=12'h000;
        color[1991:1980]<=12'h222;
        color[2003:1992]<=12'h000;
        color[2015:2004]<=12'h222;
        color[2027:2016]<=12'h000;
        color[2039:2028]<=12'h222;
        color[2051:2040]<=12'h222;
        color[2063:2052]<=12'h000;
        color[2075:2064]<=12'h222;
        color[2087:2076]<=12'h000;
        color[2099:2088]<=12'h222;
        color[2111:2100]<=12'h000;
        color[2123:2112]<=12'h222;
        color[2135:2124]<=12'h000;
        color[2147:2136]<=12'h222;
        color[2159:2148]<=12'h000;
        color[2171:2160]<=12'h000;
        color[2183:2172]<=12'h222;
        color[2195:2184]<=12'h000;
        color[2207:2196]<=12'h222;
        color[2219:2208]<=12'h000;
        color[2231:2220]<=12'h222;
        color[2243:2232]<=12'h000;
        color[2255:2244]<=12'h222;
        color[2267:2256]<=12'h000;
        color[2279:2268]<=12'h222;
        color[2291:2280]<=12'h222;
        color[2303:2292]<=12'h000;
        color[2315:2304]<=12'h222;
        color[2327:2316]<=12'h000;
        color[2339:2328]<=12'h222;
        color[2351:2340]<=12'h000;
        color[2363:2352]<=12'h222;
        color[2375:2364]<=12'h000;
        color[2387:2376]<=12'h222;
        color[2399:2388]<=12'h000;
        
    end
    else begin
        color[11:0]<=tmp_color[11:0];
        color[23:12]<=tmp_color[23:12];
        color[35:24]<=tmp_color[35:24];
        color[47:36]<=tmp_color[47:36];
        color[59:48]<=tmp_color[59:48];
        color[71:60]<=tmp_color[71:60];
        color[83:72]<=tmp_color[83:72];
        color[95:84]<=tmp_color[95:84];
        color[107:96]<=tmp_color[107:96];
        color[119:108]<=tmp_color[119:108];
        color[131:120]<=tmp_color[131:120];
        color[143:132]<=tmp_color[143:132];
        color[155:144]<=tmp_color[155:144];
        color[167:156]<=tmp_color[167:156];
        color[179:168]<=tmp_color[179:168];
        color[191:180]<=tmp_color[191:180];
        color[203:192]<=tmp_color[203:192];
        color[215:204]<=tmp_color[215:204];
        color[227:216]<=tmp_color[227:216];
        color[239:228]<=tmp_color[239:228];
        color[251:240]<=tmp_color[251:240];
        color[263:252]<=tmp_color[263:252];
        color[275:264]<=tmp_color[275:264];
        color[287:276]<=tmp_color[287:276];
        color[299:288]<=tmp_color[299:288];
        color[311:300]<=tmp_color[311:300];
        color[323:312]<=tmp_color[323:312];
        color[335:324]<=tmp_color[335:324];
        color[347:336]<=tmp_color[347:336];
        color[359:348]<=tmp_color[359:348];
        color[371:360]<=tmp_color[371:360];
        color[383:372]<=tmp_color[383:372];
        color[395:384]<=tmp_color[395:384];
        color[407:396]<=tmp_color[407:396];
        color[419:408]<=tmp_color[419:408];
        color[431:420]<=tmp_color[431:420];
        color[443:432]<=tmp_color[443:432];
        color[455:444]<=tmp_color[455:444];
        color[467:456]<=tmp_color[467:456];
        color[479:468]<=tmp_color[479:468];
        color[491:480]<=tmp_color[491:480];
        color[503:492]<=tmp_color[503:492];
        color[515:504]<=tmp_color[515:504];
        color[527:516]<=tmp_color[527:516];
        color[539:528]<=tmp_color[539:528];
        color[551:540]<=tmp_color[551:540];
        color[563:552]<=tmp_color[563:552];
        color[575:564]<=tmp_color[575:564];
        color[587:576]<=tmp_color[587:576];
        color[599:588]<=tmp_color[599:588];
        color[611:600]<=tmp_color[611:600];
        color[623:612]<=tmp_color[623:612];
        color[635:624]<=tmp_color[635:624];
        color[647:636]<=tmp_color[647:636];
        color[659:648]<=tmp_color[659:648];
        color[671:660]<=tmp_color[671:660];
        color[683:672]<=tmp_color[683:672];
        color[695:684]<=tmp_color[695:684];
        color[707:696]<=tmp_color[707:696];
        color[719:708]<=tmp_color[719:708];
        color[731:720]<=tmp_color[731:720];
        color[743:732]<=tmp_color[743:732];
        color[755:744]<=tmp_color[755:744];
        color[767:756]<=tmp_color[767:756];
        color[779:768]<=tmp_color[779:768];
        color[791:780]<=tmp_color[791:780];
        color[803:792]<=tmp_color[803:792];
        color[815:804]<=tmp_color[815:804];
        color[827:816]<=tmp_color[827:816];
        color[839:828]<=tmp_color[839:828];
        color[851:840]<=tmp_color[851:840];
        color[863:852]<=tmp_color[863:852];
        color[875:864]<=tmp_color[875:864];
        color[887:876]<=tmp_color[887:876];
        color[899:888]<=tmp_color[899:888];
        color[911:900]<=tmp_color[911:900];
        color[923:912]<=tmp_color[923:912];
        color[935:924]<=tmp_color[935:924];
        color[947:936]<=tmp_color[947:936];
        color[959:948]<=tmp_color[959:948];
        color[971:960]<=tmp_color[971:960];
        color[983:972]<=tmp_color[983:972];
        color[995:984]<=tmp_color[995:984];
        color[1007:996]<=tmp_color[1007:996];
        color[1019:1008]<=tmp_color[1019:1008];
        color[1031:1020]<=tmp_color[1031:1020];
        color[1043:1032]<=tmp_color[1043:1032];
        color[1055:1044]<=tmp_color[1055:1044];
        color[1067:1056]<=tmp_color[1067:1056];
        color[1079:1068]<=tmp_color[1079:1068];
        color[1091:1080]<=tmp_color[1091:1080];
        color[1103:1092]<=tmp_color[1103:1092];
        color[1115:1104]<=tmp_color[1115:1104];
        color[1127:1116]<=tmp_color[1127:1116];
        color[1139:1128]<=tmp_color[1139:1128];
        color[1151:1140]<=tmp_color[1151:1140];
        color[1163:1152]<=tmp_color[1163:1152];
        color[1175:1164]<=tmp_color[1175:1164];
        color[1187:1176]<=tmp_color[1187:1176];
        color[1199:1188]<=tmp_color[1199:1188];
        color[1211:1200]<=tmp_color[1211:1200];
        color[1223:1212]<=tmp_color[1223:1212];
        color[1235:1224]<=tmp_color[1235:1224];
        color[1247:1236]<=tmp_color[1247:1236];
        color[1259:1248]<=tmp_color[1259:1248];
        color[1271:1260]<=tmp_color[1271:1260];
        color[1283:1272]<=tmp_color[1283:1272];
        color[1295:1284]<=tmp_color[1295:1284];
        color[1307:1296]<=tmp_color[1307:1296];
        color[1319:1308]<=tmp_color[1319:1308];
        color[1331:1320]<=tmp_color[1331:1320];
        color[1343:1332]<=tmp_color[1343:1332];
        color[1355:1344]<=tmp_color[1355:1344];
        color[1367:1356]<=tmp_color[1367:1356];
        color[1379:1368]<=tmp_color[1379:1368];
        color[1391:1380]<=tmp_color[1391:1380];
        color[1403:1392]<=tmp_color[1403:1392];
        color[1415:1404]<=tmp_color[1415:1404];
        color[1427:1416]<=tmp_color[1427:1416];
        color[1439:1428]<=tmp_color[1439:1428];
        color[1451:1440]<=tmp_color[1451:1440];
        color[1463:1452]<=tmp_color[1463:1452];
        color[1475:1464]<=tmp_color[1475:1464];
        color[1487:1476]<=tmp_color[1487:1476];
        color[1499:1488]<=tmp_color[1499:1488];
        color[1511:1500]<=tmp_color[1511:1500];
        color[1523:1512]<=tmp_color[1523:1512];
        color[1535:1524]<=tmp_color[1535:1524];
        color[1547:1536]<=tmp_color[1547:1536];
        color[1559:1548]<=tmp_color[1559:1548];
        color[1571:1560]<=tmp_color[1571:1560];
        color[1583:1572]<=tmp_color[1583:1572];
        color[1595:1584]<=tmp_color[1595:1584];
        color[1607:1596]<=tmp_color[1607:1596];
        color[1619:1608]<=tmp_color[1619:1608];
        color[1631:1620]<=tmp_color[1631:1620];
        color[1643:1632]<=tmp_color[1643:1632];
        color[1655:1644]<=tmp_color[1655:1644];
        color[1667:1656]<=tmp_color[1667:1656];
        color[1679:1668]<=tmp_color[1679:1668];
        color[1691:1680]<=tmp_color[1691:1680];
        color[1703:1692]<=tmp_color[1703:1692];
        color[1715:1704]<=tmp_color[1715:1704];
        color[1727:1716]<=tmp_color[1727:1716];
        color[1739:1728]<=tmp_color[1739:1728];
        color[1751:1740]<=tmp_color[1751:1740];
        color[1763:1752]<=tmp_color[1763:1752];
        color[1775:1764]<=tmp_color[1775:1764];
        color[1787:1776]<=tmp_color[1787:1776];
        color[1799:1788]<=tmp_color[1799:1788];
        color[1811:1800]<=tmp_color[1811:1800];
        color[1823:1812]<=tmp_color[1823:1812];
        color[1835:1824]<=tmp_color[1835:1824];
        color[1847:1836]<=tmp_color[1847:1836];
        color[1859:1848]<=tmp_color[1859:1848];
        color[1871:1860]<=tmp_color[1871:1860];
        color[1883:1872]<=tmp_color[1883:1872];
        color[1895:1884]<=tmp_color[1895:1884];
        color[1907:1896]<=tmp_color[1907:1896];
        color[1919:1908]<=tmp_color[1919:1908];
        color[1931:1920]<=tmp_color[1931:1920];
        color[1943:1932]<=tmp_color[1943:1932];
        color[1955:1944]<=tmp_color[1955:1944];
        color[1967:1956]<=tmp_color[1967:1956];
        color[1979:1968]<=tmp_color[1979:1968];
        color[1991:1980]<=tmp_color[1991:1980];
        color[2003:1992]<=tmp_color[2003:1992];
        color[2015:2004]<=tmp_color[2015:2004];
        color[2027:2016]<=tmp_color[2027:2016];
        color[2039:2028]<=tmp_color[2039:2028];
        color[2051:2040]<=tmp_color[2051:2040];
        color[2063:2052]<=tmp_color[2063:2052];
        color[2075:2064]<=tmp_color[2075:2064];
        color[2087:2076]<=tmp_color[2087:2076];
        color[2099:2088]<=tmp_color[2099:2088];
        color[2111:2100]<=tmp_color[2111:2100];
        color[2123:2112]<=tmp_color[2123:2112];
        color[2135:2124]<=tmp_color[2135:2124];
        color[2147:2136]<=tmp_color[2147:2136];
        color[2159:2148]<=tmp_color[2159:2148];
        color[2171:2160]<=tmp_color[2171:2160];
        color[2183:2172]<=tmp_color[2183:2172];
        color[2195:2184]<=tmp_color[2195:2184];
        color[2207:2196]<=tmp_color[2207:2196];
        color[2219:2208]<=tmp_color[2219:2208];
        color[2231:2220]<=tmp_color[2231:2220];
        color[2243:2232]<=tmp_color[2243:2232];
        color[2255:2244]<=tmp_color[2255:2244];
        color[2267:2256]<=tmp_color[2267:2256];
        color[2279:2268]<=tmp_color[2279:2268];
        color[2291:2280]<=tmp_color[2291:2280];
        color[2303:2292]<=tmp_color[2303:2292];
        color[2315:2304]<=tmp_color[2315:2304];
        color[2327:2316]<=tmp_color[2327:2316];
        color[2339:2328]<=tmp_color[2339:2328];
        color[2351:2340]<=tmp_color[2351:2340];
        color[2363:2352]<=tmp_color[2363:2352];
        color[2375:2364]<=tmp_color[2375:2364];
        color[2387:2376]<=tmp_color[2387:2376];
        color[2399:2388]<=tmp_color[2399:2388];
    end
end
endmodule

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
        end
        `BLOCK_T:begin
            w_color = `COLOR_T;
        end
        `BLOCK_Z:begin
            w_color = `COLOR_Z;
        end
        `BLOCK_I:begin
            w_color = `COLOR_I;
        end
        `BLOCK_O:begin
            w_color = `COLOR_O;
        end
        default:begin end
    endcase
end
endmodule



module putBlock(write_en,address,w_color,block_exist,generate_block,block_type,block_status,rst,clk,turn_right,turn_left,shift_left,shift_right);
input generate_block;
input rst;
input clk;
input [2:0]block_type;
input [1:0]block_status;
input turn_right,turn_left;
input shift_right,shift_left;

output reg write_en;
output reg [7:0]address;
output [11:0]w_color;
output reg[199:0]block_exist;

wire [11:0]last_w_color; // redundant
reg [1:0]state;
reg [2:0]block;
reg [1:0]status;
reg [4:0]pos_x,pos_y;
reg [4:0]last_pos_x,last_pos_y;
reg start_write;

reg [1:0]tmp_state;
reg [2:0]tmp_block;
reg [1:0]tmp_status;
reg [4:0]tmp_pos_x,tmp_pos_y;
reg [4:0]tmp_last_pos_x,tmp_last_pos_y;
reg tmp_start_write;

wire [7:0] color_pos1;
wire [7:0] color_pos2;
wire [7:0] color_pos3;
wire [7:0] color_pos4;

wire [7:0] last_pos1;
wire [7:0] last_pos2;
wire [7:0] last_pos3;
wire [7:0] last_pos4;

reg [3:0]write_state;

wire block_settle ;
assign block_settle = 0;

parameter [3:0] WAIT_WRITE = 4'b0000;
parameter [3:0] WRITE_POS1 = 4'b0001;
parameter [3:0] WRITE_POS2 = 4'b0010;
parameter [3:0] WRITE_POS3 = 4'b0011;
parameter [3:0] WRITE_POS4 = 4'b0100;
parameter [3:0] ERASE_POS1 = 4'b0101;
parameter [3:0] ERASE_POS2 = 4'b0110;
parameter [3:0] ERASE_POS3 = 4'b0111;
parameter [3:0] ERASE_POS4 = 4'b1000;
parameter [3:0] SET_BLOCK_EXIST_ERASE = 4'b1001;
parameter [3:0] SET_BLOCK_EXIST_WRITE = 4'b1010;

shape s_now  (.w_color(w_color),.color_pos1(color_pos1),.color_pos2(color_pos2),.color_pos3(color_pos3),
              .color_pos4(color_pos4),.block(block),.status(status),.pos_x(pos_x),.pos_y(pos_y));
shape s_last (.w_color(last_w_color),.color_pos1(last_pos1),.color_pos2(last_pos2),.color_pos3(last_pos3),
              .color_pos4(last_pos4),.block(block),.status(status),.pos_x(tmp_last_pos_x),.pos_y(tmp_last_pos_y));

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
    end
end

always@(*)begin
    case(state)
        `WAIT_BLOCK_EN:begin
            if (generate_block)begin
                tmp_state = `BLOCK_DOWN;
                tmp_block = block_type;
                tmp_status = block_status;
                tmp_pos_x = 4;
                tmp_pos_y = 9;
                tmp_start_write = 1;
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y;
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
            end
        end
        `BLOCK_DOWN:begin
            if (block_settle)begin
                tmp_state = `BLOCK_SETTLE;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;
                tmp_start_write = 0; 
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y;
            end
            else if(shift_right)begin
                tmp_state = `SET_START_WRITE0;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x+1;
                tmp_pos_y = pos_y;                
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;     
            end
            else if(shift_left)begin
                tmp_state = `SET_START_WRITE0;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x-1;
                tmp_pos_y = pos_y;
                tmp_start_write = 1;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
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
            end
        end
        `SET_START_WRITE0:begin
            tmp_state = `BLOCK_DOWN;
            tmp_block = block;
            tmp_status = status;
            tmp_pos_x = pos_x;
            tmp_pos_y = pos_y;
            tmp_start_write = 0;
            tmp_last_pos_x = last_pos_x;
            tmp_last_pos_y = last_pos_y;
        end
        `BLOCK_SETTLE:begin
            tmp_state = `WAIT_BLOCK_EN;
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
    end
    else begin
        write_state <= write_state;
        write_en <= write_en;
        address <= address;
        block_exist <= block_exist;
        case(write_state)
            WAIT_WRITE:begin
                if(start_write)begin
                    write_state <= SET_BLOCK_EXIST_ERASE;
                    write_en <= 0;
                end
                else begin
                    write_state <= WAIT_WRITE;
                    write_en <= 0;
                end      
            end
            SET_BLOCK_EXIST_ERASE:begin
                write_state <= ERASE_POS1;
                write_en <= 0;
                address <= 0;
                block_exist[last_pos1] <= 0;
                block_exist[last_pos2] <= 0;
                block_exist[last_pos3] <= 0;
                block_exist[last_pos4] <= 0;
            end
            ERASE_POS1:begin
                write_state <= ERASE_POS2;
                write_en <= 1;
                address <= last_pos1;
            end
            ERASE_POS2:begin
                write_state <= ERASE_POS3;
                write_en <= 1;
                address <= last_pos2;
            end
            ERASE_POS3:begin
                write_state <= ERASE_POS4;
                write_en <= 1;
                address <= last_pos3;
            end
            ERASE_POS4:begin
                write_state <= SET_BLOCK_EXIST_WRITE;
                write_en <= 1;
                address <= last_pos4;
            end
            SET_BLOCK_EXIST_WRITE:begin
                write_state <= WRITE_POS1;
                write_en <= 0;
                address <= 0;
                block_exist[color_pos1] <= 1;
                block_exist[color_pos2] <= 1;
                block_exist[color_pos3] <= 1;
                block_exist[color_pos4] <= 1;
            end
            WRITE_POS1:begin
                write_state <= WRITE_POS2;
                write_en <= 1;
                address <= color_pos1;
            end
            WRITE_POS2:begin
                write_state <= WRITE_POS3;
                write_en <= 1;
                address <= color_pos2;
            end
            WRITE_POS3:begin
                write_state <= WRITE_POS4;
                write_en <= 1;
                address <= color_pos3;
            end
            WRITE_POS4:begin
                write_state <= WAIT_WRITE;
                write_en <= 1;
                address <= color_pos4;
            end
            default:begin end
        endcase
    end
end
endmodule

/*
module putblock(outBackground,blockType,R_rotate,L_rotate,blockState,rst,clk,background,clkBlockDown,start_position,block_en);
input [2:0] blockType;
input R_rotate,L_rotate;
input [1:0] blockState;
input rst;
input clk;
input clkBlockDown;
input [7:0]background;
input [3:0]start_position;
input block_en;
output [7:0]outBackground;

reg [1:0] state;
reg [1:0] next_state;
reg block_settle;
reg [2:0]block;
reg [2:0]tmp_block;
reg [7:0]tmp_pos;
reg [7:0]pos;
reg [1:0]rotate_state;
reg [1:0]tmp_rotate_state;

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= `WAIT_BLOCK_EN;
        block <= 3'b111;
        pos   <= 0;
        rotate_state <= 0;
    end
end
always@(*)begin
    case(state)
        `WAIT_BLOCK_EN:begin
            if (block_en)begin
                next_state = `BLOCK_DOWN;
                tmp_block = blockType;
                tmp_pos = 199+start_position;
            end
            else begin
                next_state = state;
            end
        end
        `BLOCK_DOWN:begin
            if (block_settle)begin
                next_state = `BLOCK_SETTLE;
            end
            else begin
                next_state = state;

            end
        end
        `BLOCK_SETTLE:begin
            next_state = `WAIT_BLOCK_EN;
        end
        default:begin
        end
    endcase
end

endmodule*/
// module putblock(outBackground,blockType,R_rotate,L_rotate,blockState,rst,clk,background,clkBlockDown,start_position);
// input [3:0] blockType;
// input R_rotate,L_rotate;
// input [1:0] blockState;
// input rst;
// input clk;
// input clkBlockDown;
// input [7:0]background;
// input [3:0]start_position;
// output [7:0]outBackground;

// reg [1:0]now_block_state;

// reg [3:0]now_x;
// reg [4:0]now_y; 
// reg [7:0]kick_R_point1;
// reg [7:0]kick_R_point2;
// reg [7:0]kick_R_point3;
// reg [7:0]kick_L_point1;
// reg [7:0]kick_L_point2;
// reg [7:0]kick_L_point3;

// reg kick;
// reg rotate_test_en;
// reg [4:0]rotate_reg

// reg [2:0]count;
// reg rotate_fail;
// always@(posedge clk or rst)begin
//     if(rst)begin
//         rotate_test_en = 0;
        
//     end
//     else begin
//         if(R_rotate or L_rotate)begin
            
//         end
//     end
// end
// always@(*)begin
//     case(blockType)
//         `BLOCK_J:begin
//             case(now_block_state)
//                 `BLOCK_STATE_0:begin
//                     kick_R_point1 = (now_y+1)*10+now_x; 
//                     kick_R_point2 = (now_y+1)*10+now_x+1;
//                     kick_R_point3 = (now_y-1)*10+now_x;
//                     kick_L_point1 = (now_y+1)*10+now_x;
//                     kick_L_point2 = (now_y-1)*10+now_x-1;
//                     kick_L_point3 = (now_y-1)*10+now_x;
//                 end
//                 `BLOCK_STATE_R:begin
//                     kick_R_point1 = (now_y)*10+now_x-1; 
//                     kick_R_point2 = (now_y)*10+now_x+1;
//                     kick_R_point3 = (now_y-1)*10+now_x+1;
//                     kick_L_point1 = (now_y+1)*10+now_x-1;
//                     kick_L_point2 = (now_y)*10+now_x-1;
//                     kick_L_point3 = (now_y)*10+now_x+1;
//                 end
//                 `BLOCK_STATE_2:begin
//                     kick_R_point1 = (now_y+1)*10+now_x; 
//                     kick_R_point2 = (now_y-1)*10+now_x;
//                     kick_R_point3 = (now_y-1)*10+now_x-1;
//                     kick_L_point1 = (now_y+1)*10+now_x;
//                     kick_L_point2 = (now_y+1)*10+now_x+1;
//                     kick_L_point3 = (now_y-1)*10+now_x; 
//                 end
//                 `BLOCK_STATE_L:begin
//                     kick_R_point1 = (now_y+1)*10+now_x-1; 
//                     kick_R_point2 = (now_y)*10+now_x-1;
//                     kick_R_point3 = (now_y)*10+now_x+1;
//                     kick_L_point1 = (now_y-1)*10+now_x+1; 
//                     kick_L_point2 = (now_y)*10+now_x+1;
//                     kick_L_point3 = (now_y)*10+now_x-1;
//                 end
//                 default:begin
                    
//                 end
//             endcase
//         end
//         `BLOCK_L:begin
            
//         end
//         `BLOCK_S:begin
            
//         end
//         `BLOCK_T:begin
            
//         end
//         `BLOCK_Z:begin
            
//         end
//         `BLOCK_I:begin
            
//         end
//         `BLOCK_O:begin
            
//         end
//         default:begin
            
//         end
//     endcase
// end
// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         kick <= 0;
//         count <= 0;
//         rotate_fail <= 0;
//     end
//     else begin
//         if(!background[kick_R_point1]&&!background[kick_R_point2]&&!background[kick_R_point3])begin
//             kick <= 0;
//             count <= 0;
//             rotate_fail <= 0; 
//             now_x <= now_x;
//             now_y <= now_y;
//         end
//         else begin
//             kick <= 1;
//             count <= count + 1;
//             case(count)
//                 1:begin now_x <= now_x-1; now_y <= now_y  ; end
//                 2:begin now_x <= now_x-1; now_y <= now_y+1; end
//                 3:begin now_x <= now_x  ; now_y <= now_y-2; end
//                 4:begin now_x <= now_x-1; now_y <= now_y-2; end
//                 5:begin rotate_fail <= 1;end
//                 default:begin end
//             endcase
//         end
//     end
// end
// always@(posedge clk or posedge rst)begin
//     if(rst)begin
//         outBackground[7:0]<=8'b0000_0000;
//     end
//     else begin
//         case(blockType)
//             `BLOCK_J:begin
//                 case(now_block_state)
//                     `BLOCK_STATE_0:begin
//                         if(R_rotate)begin
//                             if(kick == 0)begin
//                                 now_block_state <= `BLOCK_STATE_R;
//                             end
//                             else begin
//                                 now_block_state <= now_block_state;
//                                 now_x <= now_x-1;
//                                 now_y <= now_y;
//                             end
//                         end
//                         else if(L_rotate)begin
                            
//                         end
//                         else begin
                            
//                         end
//                     end
//                     `BLOCK_STATE_R:begin
                        
//                     end
//                     `BLOCK_STATE_2:begin
                        
//                     end
//                     `BLOCK_STATE_L:begin
                        
//                     end
//                 endcase
//             end
//             `BLOCK_L:begin
                
//             end
//             `BLOCK_S:begin
                
//             end
//             `BLOCK_T:begin
                
//             end
//             `BLOCK_Z:begin
                
//             end
//             `BLOCK_I:begin
                
//             end
//             `BLOCK_O:begin
                
//             end
//             default:begin
                
//             end
//         endcase
//     end  
// end
// always@(posedge clkBlockDown or posedge rst)begin

// end
//endmodule
module random_num_generator(q,clk,rst);
input clk;
input rst;
output[15:0]q;
reg [15:0]q;
always@(posedge rst or posedge clk )begin
    if(rst)begin
        q[15:0]<=16'b1111_1111_1111_1111;
    end
    else begin
        q[0]<=q[3]^q[12]^q[14]^q[15];
        q[1]<=q[0];
        q[2]<=q[1];
        q[3]<=q[2];
        q[4]<=q[3];
        q[5]<=q[4];
        q[6]<=q[5];
        q[7]<=q[6];
        q[8]<=q[7];
        q[9]<=q[8];
        q[10]<=q[9];
        q[11]<=q[10];
        q[12]<=q[11];
        q[13]<=q[12];
        q[14]<=q[13];
        q[15]<=q[14];
    end
end

endmodule
module pixel_gen(vgaRed,vgaGreen,vgaBlue,h_cnt,v_cnt,valid,color);
input [9:0] h_cnt;
input [9:0] v_cnt;
input valid;
input [2399:0] color;
output reg [3:0] vgaRed;
output reg [3:0] vgaGreen;
output reg [3:0] vgaBlue;
wire [5:0]horizontal_mod_16;
wire [5:0]vertical_mod_16;
assign horizontal_mod_16 = h_cnt/16;
assign vertical_mod_16 = v_cnt/16;
always @(*)begin
    if(!valid)begin
       {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
    end
    else begin
        case(vertical_mod_16)
            24:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[11:0];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[23:12];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[35:24];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[47:36];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[59:48];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[71:60];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[83:72];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[95:84];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[107:96];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[119:108];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            23:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[131:120];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[143:132];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[155:144];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[167:156];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[179:168];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[191:180];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[203:192];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[215:204];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[227:216];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[239:228];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            22:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[251:240];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[263:252];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[275:264];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[287:276];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[299:288];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[311:300];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[323:312];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[335:324];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[347:336];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[359:348];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            21:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[371:360];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[383:372];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[395:384];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[407:396];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[419:408];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[431:420];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[443:432];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[455:444];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[467:456];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[479:468];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            20:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[491:480];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[503:492];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[515:504];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[527:516];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[539:528];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[551:540];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[563:552];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[575:564];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[587:576];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[599:588];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            19:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[611:600];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[623:612];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[635:624];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[647:636];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[659:648];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[671:660];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[683:672];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[695:684];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[707:696];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[719:708];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            18:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[731:720];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[743:732];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[755:744];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[767:756];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[779:768];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[791:780];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[803:792];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[815:804];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[827:816];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[839:828];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            17:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[851:840];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[863:852];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[875:864];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[887:876];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[899:888];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[911:900];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[923:912];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[935:924];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[947:936];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[959:948];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            16:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[971:960];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[983:972];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[995:984];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1007:996];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1019:1008];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1031:1020];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1043:1032];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1055:1044];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1067:1056];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1079:1068];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            15:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1091:1080];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1103:1092];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1115:1104];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1127:1116];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1139:1128];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1151:1140];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1163:1152];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1175:1164];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1187:1176];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1199:1188];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            14:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1211:1200];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1223:1212];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1235:1224];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1247:1236];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1259:1248];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1271:1260];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1283:1272];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1295:1284];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1307:1296];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1319:1308];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            13:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1331:1320];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1343:1332];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1355:1344];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1367:1356];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1379:1368];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1391:1380];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1403:1392];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1415:1404];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1427:1416];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1439:1428];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            12:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1451:1440];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1463:1452];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1475:1464];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1487:1476];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1499:1488];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1511:1500];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1523:1512];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1535:1524];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1547:1536];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1559:1548];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            11:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1571:1560];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1583:1572];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1595:1584];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1607:1596];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1619:1608];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1631:1620];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1643:1632];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1655:1644];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1667:1656];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1679:1668];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            10:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1691:1680];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1703:1692];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1715:1704];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1727:1716];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1739:1728];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1751:1740];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1763:1752];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1775:1764];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1787:1776];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1799:1788];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            9:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1811:1800];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1823:1812];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1835:1824];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1847:1836];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1859:1848];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1871:1860];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[1883:1872];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[1895:1884];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[1907:1896];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[1919:1908];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            8:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[1931:1920];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[1943:1932];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[1955:1944];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[1967:1956];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[1979:1968];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[1991:1980];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[2003:1992];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[2015:2004];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[2027:2016];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[2039:2028];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            7:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[2051:2040];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[2063:2052];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[2075:2064];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[2087:2076];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[2099:2088];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[2111:2100];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[2123:2112];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[2135:2124];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[2147:2136];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[2159:2148];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            6:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[2171:2160];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[2183:2172];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[2195:2184];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[2207:2196];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[2219:2208];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[2231:2220];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[2243:2232];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[2255:2244];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[2267:2256];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[2279:2268];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            5:begin
                case(horizontal_mod_16)
                    15 : {vgaRed, vgaGreen, vgaBlue} = color[2291:2280];
                    16 : {vgaRed, vgaGreen, vgaBlue} = color[2303:2292];
                    17 : {vgaRed, vgaGreen, vgaBlue} = color[2315:2304];
                    18 : {vgaRed, vgaGreen, vgaBlue} = color[2327:2316];
                    19 : {vgaRed, vgaGreen, vgaBlue} = color[2339:2328];
                    20 : {vgaRed, vgaGreen, vgaBlue} = color[2351:2340];
                    21 : {vgaRed, vgaGreen, vgaBlue} = color[2363:2352];
                    22 : {vgaRed, vgaGreen, vgaBlue} = color[2375:2364];
                    23 : {vgaRed, vgaGreen, vgaBlue} = color[2387:2376];
                    24 : {vgaRed, vgaGreen, vgaBlue} = color[2399:2388];
                    default:{vgaRed, vgaGreen, vgaBlue} = 12'hee8;
                endcase
            end
            default:begin 
                {vgaRed, vgaGreen, vgaBlue} = 12'hee8;
            end
        endcase
    end
end
endmodule

module vga_controller 
  (
    input wire pclk,reset,
    output wire hsync,vsync,valid,
    output wire [9:0]h_cnt,
    output wire [9:0]v_cnt
    );
    
    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;
    wire hsync_default, vsync_default;
    wire [9:0] HD, HF, HS, HB, HT, VD, VF, VS, VB, VT;

   
    assign HD = 640;
    assign HF = 16;
    assign HS = 96;
    assign HB = 48;
    assign HT = 800; 
    assign VD = 480;
    assign VF = 10;
    assign VS = 2;
    assign VB = 33;
    assign VT = 525;
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    always@(posedge pclk)
        if(reset)
            pixel_cnt <= 0;
        else if(pixel_cnt < (HT - 1))
                pixel_cnt <= pixel_cnt + 1;
             else
                pixel_cnt <= 0;

    always@(posedge pclk)
        if(reset)
            hsync_i <= hsync_default;
        else if((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
                hsync_i <= ~hsync_default;
            else
                hsync_i <= hsync_default; 
    
    always@(posedge pclk)
        if(reset)
            line_cnt <= 0;
        else if(pixel_cnt == (HT -1))
                if(line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
                    
    always@(posedge pclk)
        if(reset)
            vsync_i <= vsync_default; 
        else if((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 
                    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt:10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt:10'd0;
           
endmodule

module clock_divisor(clk1, clk,clkBlockDown,clk22);
input clk;
output clk1;
output clk22;
output clkBlockDown;
reg [21:0] num;
wire [21:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end


assign next_num = num + 1'b1;
assign clk1 = num[1];
assign clk22 = num[21];
assign clkBlockDown = num[25];
endmodule
// module mem_addr_gen(
//    input clk,
//    input rst,
//    input [9:0] h_cnt,
//    input [9:0] v_cnt,
//    output [16:0] pixel_addr
//    );
    
  
//    assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1))% 76800;  //640*480 --> 320*240 

    
// endmodule

module debounce(pb_debounced,pb,clk);
input pb;
input clk;
output pb_debounced;
reg [3:0]shift_reg;
always@(posedge clk)begin
    shift_reg[3:1] <= shift_reg[2:0];
    shift_reg[0] <= pb;
end
assign pb_debounced = (shift_reg == 4'b1111)? 1'b1:1'b0;
endmodule

module one_pulse(push_onepulse,rst,clk,push_debounced);
input rst,clk,push_debounced;
output push_onepulse;
reg push_onepulse;
reg push_onepulse_next;
reg push_debounced_delay;
always @(*) begin
    push_onepulse_next = push_debounced & ~push_debounced_delay;
end
always @(posedge clk or posedge rst)begin
    if (rst) begin
        push_onepulse <= 1'b0;
        push_debounced_delay <= 1'b0;
    end 
    else begin
        push_onepulse <= push_onepulse_next;
        push_debounced_delay <=push_debounced;
    end
end
endmodule

