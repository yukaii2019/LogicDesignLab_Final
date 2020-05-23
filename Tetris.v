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
wire [199:0]change_en;


clock_divisor clk_wiz_0_inst(.clk(clk),.clk1(clk_25MHz),.clk22(clk_22),.clkBlockDown(clkBlockDown));
pixel_gen pg (.vgaRed(vgaRed),.vgaGreen(vgaGreen),.vgaBlue(vgaBlue),.h_cnt(h_cnt),.v_cnt(v_cnt),.valid(valid),.color(color));
vga_controller vga_inst(.pclk(clk_25MHz),.reset(rst),.hsync(hsync),.vsync(vsync),.valid(valid),.h_cnt(h_cnt),.v_cnt(v_cnt));
BackGroundMemory bm (.color(color),.clk(clk),.rst(rst),.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.change_en(change_en));
putBlock pb (.write_en(write_en),.address(address),.w_color(w_color),.block_exist(block_exist),.generate_block(generate_block),
             .block_type(`BLOCK_J),.block_status(`BLOCK_STATUS_0),.rst(rst),.clk(clk),.turn_right(op_btn_U),.turn_left(op_btn_D),
             .shift_left(op_btn_L),.shift_right(op_btn_R),.clkBlockDown(clkBlockDown),.change_en(change_en));
//putblock pb (.outBackground(),.blockType(),.R_rotate(),.L_rotate(),.blockState(),.rst(),.clk(),.background(),.clkBlockDown(),.start_position());

endmodule

module BackGroundMemory(color,clk,rst,write_en,address,w_color,block_exist,change_en);
output reg [2399:0]color;
input clk;
input rst;
input write_en;
input [7:0]address;
input [11:0]w_color;
input [199:0]block_exist;
input [199:0]change_en;
reg [2399:0]tmp_color;

always@(*)begin
    if(write_en)begin
        case(address)
            0 : begin tmp_color[11:0] = (change_en[0])?w_color:color[11:0]; end
1 : begin tmp_color[23:12] = (change_en[1])?w_color:color[23:12]; end
2 : begin tmp_color[35:24] = (change_en[2])?w_color:color[35:24]; end
3 : begin tmp_color[47:36] = (change_en[3])?w_color:color[47:36]; end
4 : begin tmp_color[59:48] = (change_en[4])?w_color:color[59:48]; end
5 : begin tmp_color[71:60] = (change_en[5])?w_color:color[71:60]; end
6 : begin tmp_color[83:72] = (change_en[6])?w_color:color[83:72]; end
7 : begin tmp_color[95:84] = (change_en[7])?w_color:color[95:84]; end
8 : begin tmp_color[107:96] = (change_en[8])?w_color:color[107:96]; end
9 : begin tmp_color[119:108] = (change_en[9])?w_color:color[119:108]; end
10 : begin tmp_color[131:120] = (change_en[10])?w_color:color[131:120]; end
11 : begin tmp_color[143:132] = (change_en[11])?w_color:color[143:132]; end
12 : begin tmp_color[155:144] = (change_en[12])?w_color:color[155:144]; end
13 : begin tmp_color[167:156] = (change_en[13])?w_color:color[167:156]; end
14 : begin tmp_color[179:168] = (change_en[14])?w_color:color[179:168]; end
15 : begin tmp_color[191:180] = (change_en[15])?w_color:color[191:180]; end
16 : begin tmp_color[203:192] = (change_en[16])?w_color:color[203:192]; end
17 : begin tmp_color[215:204] = (change_en[17])?w_color:color[215:204]; end
18 : begin tmp_color[227:216] = (change_en[18])?w_color:color[227:216]; end
19 : begin tmp_color[239:228] = (change_en[19])?w_color:color[239:228]; end
20 : begin tmp_color[251:240] = (change_en[20])?w_color:color[251:240]; end
21 : begin tmp_color[263:252] = (change_en[21])?w_color:color[263:252]; end
22 : begin tmp_color[275:264] = (change_en[22])?w_color:color[275:264]; end
23 : begin tmp_color[287:276] = (change_en[23])?w_color:color[287:276]; end
24 : begin tmp_color[299:288] = (change_en[24])?w_color:color[299:288]; end
25 : begin tmp_color[311:300] = (change_en[25])?w_color:color[311:300]; end
26 : begin tmp_color[323:312] = (change_en[26])?w_color:color[323:312]; end
27 : begin tmp_color[335:324] = (change_en[27])?w_color:color[335:324]; end
28 : begin tmp_color[347:336] = (change_en[28])?w_color:color[347:336]; end
29 : begin tmp_color[359:348] = (change_en[29])?w_color:color[359:348]; end
30 : begin tmp_color[371:360] = (change_en[30])?w_color:color[371:360]; end
31 : begin tmp_color[383:372] = (change_en[31])?w_color:color[383:372]; end
32 : begin tmp_color[395:384] = (change_en[32])?w_color:color[395:384]; end
33 : begin tmp_color[407:396] = (change_en[33])?w_color:color[407:396]; end
34 : begin tmp_color[419:408] = (change_en[34])?w_color:color[419:408]; end
35 : begin tmp_color[431:420] = (change_en[35])?w_color:color[431:420]; end
36 : begin tmp_color[443:432] = (change_en[36])?w_color:color[443:432]; end
37 : begin tmp_color[455:444] = (change_en[37])?w_color:color[455:444]; end
38 : begin tmp_color[467:456] = (change_en[38])?w_color:color[467:456]; end
39 : begin tmp_color[479:468] = (change_en[39])?w_color:color[479:468]; end
40 : begin tmp_color[491:480] = (change_en[40])?w_color:color[491:480]; end
41 : begin tmp_color[503:492] = (change_en[41])?w_color:color[503:492]; end
42 : begin tmp_color[515:504] = (change_en[42])?w_color:color[515:504]; end
43 : begin tmp_color[527:516] = (change_en[43])?w_color:color[527:516]; end
44 : begin tmp_color[539:528] = (change_en[44])?w_color:color[539:528]; end
45 : begin tmp_color[551:540] = (change_en[45])?w_color:color[551:540]; end
46 : begin tmp_color[563:552] = (change_en[46])?w_color:color[563:552]; end
47 : begin tmp_color[575:564] = (change_en[47])?w_color:color[575:564]; end
48 : begin tmp_color[587:576] = (change_en[48])?w_color:color[587:576]; end
49 : begin tmp_color[599:588] = (change_en[49])?w_color:color[599:588]; end
50 : begin tmp_color[611:600] = (change_en[50])?w_color:color[611:600]; end
51 : begin tmp_color[623:612] = (change_en[51])?w_color:color[623:612]; end
52 : begin tmp_color[635:624] = (change_en[52])?w_color:color[635:624]; end
53 : begin tmp_color[647:636] = (change_en[53])?w_color:color[647:636]; end
54 : begin tmp_color[659:648] = (change_en[54])?w_color:color[659:648]; end
55 : begin tmp_color[671:660] = (change_en[55])?w_color:color[671:660]; end
56 : begin tmp_color[683:672] = (change_en[56])?w_color:color[683:672]; end
57 : begin tmp_color[695:684] = (change_en[57])?w_color:color[695:684]; end
58 : begin tmp_color[707:696] = (change_en[58])?w_color:color[707:696]; end
59 : begin tmp_color[719:708] = (change_en[59])?w_color:color[719:708]; end
60 : begin tmp_color[731:720] = (change_en[60])?w_color:color[731:720]; end
61 : begin tmp_color[743:732] = (change_en[61])?w_color:color[743:732]; end
62 : begin tmp_color[755:744] = (change_en[62])?w_color:color[755:744]; end
63 : begin tmp_color[767:756] = (change_en[63])?w_color:color[767:756]; end
64 : begin tmp_color[779:768] = (change_en[64])?w_color:color[779:768]; end
65 : begin tmp_color[791:780] = (change_en[65])?w_color:color[791:780]; end
66 : begin tmp_color[803:792] = (change_en[66])?w_color:color[803:792]; end
67 : begin tmp_color[815:804] = (change_en[67])?w_color:color[815:804]; end
68 : begin tmp_color[827:816] = (change_en[68])?w_color:color[827:816]; end
69 : begin tmp_color[839:828] = (change_en[69])?w_color:color[839:828]; end
70 : begin tmp_color[851:840] = (change_en[70])?w_color:color[851:840]; end
71 : begin tmp_color[863:852] = (change_en[71])?w_color:color[863:852]; end
72 : begin tmp_color[875:864] = (change_en[72])?w_color:color[875:864]; end
73 : begin tmp_color[887:876] = (change_en[73])?w_color:color[887:876]; end
74 : begin tmp_color[899:888] = (change_en[74])?w_color:color[899:888]; end
75 : begin tmp_color[911:900] = (change_en[75])?w_color:color[911:900]; end
76 : begin tmp_color[923:912] = (change_en[76])?w_color:color[923:912]; end
77 : begin tmp_color[935:924] = (change_en[77])?w_color:color[935:924]; end
78 : begin tmp_color[947:936] = (change_en[78])?w_color:color[947:936]; end
79 : begin tmp_color[959:948] = (change_en[79])?w_color:color[959:948]; end
80 : begin tmp_color[971:960] = (change_en[80])?w_color:color[971:960]; end
81 : begin tmp_color[983:972] = (change_en[81])?w_color:color[983:972]; end
82 : begin tmp_color[995:984] = (change_en[82])?w_color:color[995:984]; end
83 : begin tmp_color[1007:996] = (change_en[83])?w_color:color[1007:996]; end
84 : begin tmp_color[1019:1008] = (change_en[84])?w_color:color[1019:1008]; end
85 : begin tmp_color[1031:1020] = (change_en[85])?w_color:color[1031:1020]; end
86 : begin tmp_color[1043:1032] = (change_en[86])?w_color:color[1043:1032]; end
87 : begin tmp_color[1055:1044] = (change_en[87])?w_color:color[1055:1044]; end
88 : begin tmp_color[1067:1056] = (change_en[88])?w_color:color[1067:1056]; end
89 : begin tmp_color[1079:1068] = (change_en[89])?w_color:color[1079:1068]; end
90 : begin tmp_color[1091:1080] = (change_en[90])?w_color:color[1091:1080]; end
91 : begin tmp_color[1103:1092] = (change_en[91])?w_color:color[1103:1092]; end
92 : begin tmp_color[1115:1104] = (change_en[92])?w_color:color[1115:1104]; end
93 : begin tmp_color[1127:1116] = (change_en[93])?w_color:color[1127:1116]; end
94 : begin tmp_color[1139:1128] = (change_en[94])?w_color:color[1139:1128]; end
95 : begin tmp_color[1151:1140] = (change_en[95])?w_color:color[1151:1140]; end
96 : begin tmp_color[1163:1152] = (change_en[96])?w_color:color[1163:1152]; end
97 : begin tmp_color[1175:1164] = (change_en[97])?w_color:color[1175:1164]; end
98 : begin tmp_color[1187:1176] = (change_en[98])?w_color:color[1187:1176]; end
99 : begin tmp_color[1199:1188] = (change_en[99])?w_color:color[1199:1188]; end
100 : begin tmp_color[1211:1200] = (change_en[100])?w_color:color[1211:1200]; end
101 : begin tmp_color[1223:1212] = (change_en[101])?w_color:color[1223:1212]; end
102 : begin tmp_color[1235:1224] = (change_en[102])?w_color:color[1235:1224]; end
103 : begin tmp_color[1247:1236] = (change_en[103])?w_color:color[1247:1236]; end
104 : begin tmp_color[1259:1248] = (change_en[104])?w_color:color[1259:1248]; end
105 : begin tmp_color[1271:1260] = (change_en[105])?w_color:color[1271:1260]; end
106 : begin tmp_color[1283:1272] = (change_en[106])?w_color:color[1283:1272]; end
107 : begin tmp_color[1295:1284] = (change_en[107])?w_color:color[1295:1284]; end
108 : begin tmp_color[1307:1296] = (change_en[108])?w_color:color[1307:1296]; end
109 : begin tmp_color[1319:1308] = (change_en[109])?w_color:color[1319:1308]; end
110 : begin tmp_color[1331:1320] = (change_en[110])?w_color:color[1331:1320]; end
111 : begin tmp_color[1343:1332] = (change_en[111])?w_color:color[1343:1332]; end
112 : begin tmp_color[1355:1344] = (change_en[112])?w_color:color[1355:1344]; end
113 : begin tmp_color[1367:1356] = (change_en[113])?w_color:color[1367:1356]; end
114 : begin tmp_color[1379:1368] = (change_en[114])?w_color:color[1379:1368]; end
115 : begin tmp_color[1391:1380] = (change_en[115])?w_color:color[1391:1380]; end
116 : begin tmp_color[1403:1392] = (change_en[116])?w_color:color[1403:1392]; end
117 : begin tmp_color[1415:1404] = (change_en[117])?w_color:color[1415:1404]; end
118 : begin tmp_color[1427:1416] = (change_en[118])?w_color:color[1427:1416]; end
119 : begin tmp_color[1439:1428] = (change_en[119])?w_color:color[1439:1428]; end
120 : begin tmp_color[1451:1440] = (change_en[120])?w_color:color[1451:1440]; end
121 : begin tmp_color[1463:1452] = (change_en[121])?w_color:color[1463:1452]; end
122 : begin tmp_color[1475:1464] = (change_en[122])?w_color:color[1475:1464]; end
123 : begin tmp_color[1487:1476] = (change_en[123])?w_color:color[1487:1476]; end
124 : begin tmp_color[1499:1488] = (change_en[124])?w_color:color[1499:1488]; end
125 : begin tmp_color[1511:1500] = (change_en[125])?w_color:color[1511:1500]; end
126 : begin tmp_color[1523:1512] = (change_en[126])?w_color:color[1523:1512]; end
127 : begin tmp_color[1535:1524] = (change_en[127])?w_color:color[1535:1524]; end
128 : begin tmp_color[1547:1536] = (change_en[128])?w_color:color[1547:1536]; end
129 : begin tmp_color[1559:1548] = (change_en[129])?w_color:color[1559:1548]; end
130 : begin tmp_color[1571:1560] = (change_en[130])?w_color:color[1571:1560]; end
131 : begin tmp_color[1583:1572] = (change_en[131])?w_color:color[1583:1572]; end
132 : begin tmp_color[1595:1584] = (change_en[132])?w_color:color[1595:1584]; end
133 : begin tmp_color[1607:1596] = (change_en[133])?w_color:color[1607:1596]; end
134 : begin tmp_color[1619:1608] = (change_en[134])?w_color:color[1619:1608]; end
135 : begin tmp_color[1631:1620] = (change_en[135])?w_color:color[1631:1620]; end
136 : begin tmp_color[1643:1632] = (change_en[136])?w_color:color[1643:1632]; end
137 : begin tmp_color[1655:1644] = (change_en[137])?w_color:color[1655:1644]; end
138 : begin tmp_color[1667:1656] = (change_en[138])?w_color:color[1667:1656]; end
139 : begin tmp_color[1679:1668] = (change_en[139])?w_color:color[1679:1668]; end
140 : begin tmp_color[1691:1680] = (change_en[140])?w_color:color[1691:1680]; end
141 : begin tmp_color[1703:1692] = (change_en[141])?w_color:color[1703:1692]; end
142 : begin tmp_color[1715:1704] = (change_en[142])?w_color:color[1715:1704]; end
143 : begin tmp_color[1727:1716] = (change_en[143])?w_color:color[1727:1716]; end
144 : begin tmp_color[1739:1728] = (change_en[144])?w_color:color[1739:1728]; end
145 : begin tmp_color[1751:1740] = (change_en[145])?w_color:color[1751:1740]; end
146 : begin tmp_color[1763:1752] = (change_en[146])?w_color:color[1763:1752]; end
147 : begin tmp_color[1775:1764] = (change_en[147])?w_color:color[1775:1764]; end
148 : begin tmp_color[1787:1776] = (change_en[148])?w_color:color[1787:1776]; end
149 : begin tmp_color[1799:1788] = (change_en[149])?w_color:color[1799:1788]; end
150 : begin tmp_color[1811:1800] = (change_en[150])?w_color:color[1811:1800]; end
151 : begin tmp_color[1823:1812] = (change_en[151])?w_color:color[1823:1812]; end
152 : begin tmp_color[1835:1824] = (change_en[152])?w_color:color[1835:1824]; end
153 : begin tmp_color[1847:1836] = (change_en[153])?w_color:color[1847:1836]; end
154 : begin tmp_color[1859:1848] = (change_en[154])?w_color:color[1859:1848]; end
155 : begin tmp_color[1871:1860] = (change_en[155])?w_color:color[1871:1860]; end
156 : begin tmp_color[1883:1872] = (change_en[156])?w_color:color[1883:1872]; end
157 : begin tmp_color[1895:1884] = (change_en[157])?w_color:color[1895:1884]; end
158 : begin tmp_color[1907:1896] = (change_en[158])?w_color:color[1907:1896]; end
159 : begin tmp_color[1919:1908] = (change_en[159])?w_color:color[1919:1908]; end
160 : begin tmp_color[1931:1920] = (change_en[160])?w_color:color[1931:1920]; end
161 : begin tmp_color[1943:1932] = (change_en[161])?w_color:color[1943:1932]; end
162 : begin tmp_color[1955:1944] = (change_en[162])?w_color:color[1955:1944]; end
163 : begin tmp_color[1967:1956] = (change_en[163])?w_color:color[1967:1956]; end
164 : begin tmp_color[1979:1968] = (change_en[164])?w_color:color[1979:1968]; end
165 : begin tmp_color[1991:1980] = (change_en[165])?w_color:color[1991:1980]; end
166 : begin tmp_color[2003:1992] = (change_en[166])?w_color:color[2003:1992]; end
167 : begin tmp_color[2015:2004] = (change_en[167])?w_color:color[2015:2004]; end
168 : begin tmp_color[2027:2016] = (change_en[168])?w_color:color[2027:2016]; end
169 : begin tmp_color[2039:2028] = (change_en[169])?w_color:color[2039:2028]; end
170 : begin tmp_color[2051:2040] = (change_en[170])?w_color:color[2051:2040]; end
171 : begin tmp_color[2063:2052] = (change_en[171])?w_color:color[2063:2052]; end
172 : begin tmp_color[2075:2064] = (change_en[172])?w_color:color[2075:2064]; end
173 : begin tmp_color[2087:2076] = (change_en[173])?w_color:color[2087:2076]; end
174 : begin tmp_color[2099:2088] = (change_en[174])?w_color:color[2099:2088]; end
175 : begin tmp_color[2111:2100] = (change_en[175])?w_color:color[2111:2100]; end
176 : begin tmp_color[2123:2112] = (change_en[176])?w_color:color[2123:2112]; end
177 : begin tmp_color[2135:2124] = (change_en[177])?w_color:color[2135:2124]; end
178 : begin tmp_color[2147:2136] = (change_en[178])?w_color:color[2147:2136]; end
179 : begin tmp_color[2159:2148] = (change_en[179])?w_color:color[2159:2148]; end
180 : begin tmp_color[2171:2160] = (change_en[180])?w_color:color[2171:2160]; end
181 : begin tmp_color[2183:2172] = (change_en[181])?w_color:color[2183:2172]; end
182 : begin tmp_color[2195:2184] = (change_en[182])?w_color:color[2195:2184]; end
183 : begin tmp_color[2207:2196] = (change_en[183])?w_color:color[2207:2196]; end
184 : begin tmp_color[2219:2208] = (change_en[184])?w_color:color[2219:2208]; end
185 : begin tmp_color[2231:2220] = (change_en[185])?w_color:color[2231:2220]; end
186 : begin tmp_color[2243:2232] = (change_en[186])?w_color:color[2243:2232]; end
187 : begin tmp_color[2255:2244] = (change_en[187])?w_color:color[2255:2244]; end
188 : begin tmp_color[2267:2256] = (change_en[188])?w_color:color[2267:2256]; end
189 : begin tmp_color[2279:2268] = (change_en[189])?w_color:color[2279:2268]; end
190 : begin tmp_color[2291:2280] = (change_en[190])?w_color:color[2291:2280]; end
191 : begin tmp_color[2303:2292] = (change_en[191])?w_color:color[2303:2292]; end
192 : begin tmp_color[2315:2304] = (change_en[192])?w_color:color[2315:2304]; end
193 : begin tmp_color[2327:2316] = (change_en[193])?w_color:color[2327:2316]; end
194 : begin tmp_color[2339:2328] = (change_en[194])?w_color:color[2339:2328]; end
195 : begin tmp_color[2351:2340] = (change_en[195])?w_color:color[2351:2340]; end
196 : begin tmp_color[2363:2352] = (change_en[196])?w_color:color[2363:2352]; end
197 : begin tmp_color[2375:2364] = (change_en[197])?w_color:color[2375:2364]; end
198 : begin tmp_color[2387:2376] = (change_en[198])?w_color:color[2387:2376]; end
199 : begin tmp_color[2399:2388] = (change_en[199])?w_color:color[2399:2388]; end
            default:begin end
        endcase
    end
    else begin
            tmp_color[11:0] = (block_exist[0])?color[11:0]:12'h000;
            tmp_color[23:12] = (block_exist[1])?color[23:12]:12'h222;
            tmp_color[35:24] = (block_exist[2])?color[35:24]:12'h000;
            tmp_color[47:36] = (block_exist[3])?color[47:36]:12'h222;
            tmp_color[59:48] = (block_exist[4])?color[59:48]:12'h000;
            tmp_color[71:60] = (block_exist[5])?color[71:60]:12'h222;
            tmp_color[83:72] = (block_exist[6])?color[83:72]:12'h000;
            tmp_color[95:84] = (block_exist[7])?color[95:84]:12'h222;
            tmp_color[107:96] = (block_exist[8])?color[107:96]:12'h000;
            tmp_color[119:108] = (block_exist[9])?color[119:108]:12'h222;
            tmp_color[131:120] = (block_exist[10])?color[131:120]:12'h222;
            tmp_color[143:132] = (block_exist[11])?color[143:132]:12'h000;
            tmp_color[155:144] = (block_exist[12])?color[155:144]:12'h222;
            tmp_color[167:156] = (block_exist[13])?color[167:156]:12'h000;
            tmp_color[179:168] = (block_exist[14])?color[179:168]:12'h222;
            tmp_color[191:180] = (block_exist[15])?color[191:180]:12'h000;
            tmp_color[203:192] = (block_exist[16])?color[203:192]:12'h222;
            tmp_color[215:204] = (block_exist[17])?color[215:204]:12'h000;
            tmp_color[227:216] = (block_exist[18])?color[227:216]:12'h222;
            tmp_color[239:228] = (block_exist[19])?color[239:228]:12'h000;
            tmp_color[251:240] = (block_exist[20])?color[251:240]:12'h000;
            tmp_color[263:252] = (block_exist[21])?color[263:252]:12'h222;
            tmp_color[275:264] = (block_exist[22])?color[275:264]:12'h000;
            tmp_color[287:276] = (block_exist[23])?color[287:276]:12'h222;
            tmp_color[299:288] = (block_exist[24])?color[299:288]:12'h000;
            tmp_color[311:300] = (block_exist[25])?color[311:300]:12'h222;
            tmp_color[323:312] = (block_exist[26])?color[323:312]:12'h000;
            tmp_color[335:324] = (block_exist[27])?color[335:324]:12'h222;
            tmp_color[347:336] = (block_exist[28])?color[347:336]:12'h000;
            tmp_color[359:348] = (block_exist[29])?color[359:348]:12'h222;
            tmp_color[371:360] = (block_exist[30])?color[371:360]:12'h222;
            tmp_color[383:372] = (block_exist[31])?color[383:372]:12'h000;
            tmp_color[395:384] = (block_exist[32])?color[395:384]:12'h222;
            tmp_color[407:396] = (block_exist[33])?color[407:396]:12'h000;
            tmp_color[419:408] = (block_exist[34])?color[419:408]:12'h222;
            tmp_color[431:420] = (block_exist[35])?color[431:420]:12'h000;
            tmp_color[443:432] = (block_exist[36])?color[443:432]:12'h222;
            tmp_color[455:444] = (block_exist[37])?color[455:444]:12'h000;
            tmp_color[467:456] = (block_exist[38])?color[467:456]:12'h222;
            tmp_color[479:468] = (block_exist[39])?color[479:468]:12'h000;
            tmp_color[491:480] = (block_exist[40])?color[491:480]:12'h000;
            tmp_color[503:492] = (block_exist[41])?color[503:492]:12'h222;
            tmp_color[515:504] = (block_exist[42])?color[515:504]:12'h000;
            tmp_color[527:516] = (block_exist[43])?color[527:516]:12'h222;
            tmp_color[539:528] = (block_exist[44])?color[539:528]:12'h000;
            tmp_color[551:540] = (block_exist[45])?color[551:540]:12'h222;
            tmp_color[563:552] = (block_exist[46])?color[563:552]:12'h000;
            tmp_color[575:564] = (block_exist[47])?color[575:564]:12'h222;
            tmp_color[587:576] = (block_exist[48])?color[587:576]:12'h000;
            tmp_color[599:588] = (block_exist[49])?color[599:588]:12'h222;
            tmp_color[611:600] = (block_exist[50])?color[611:600]:12'h222;
            tmp_color[623:612] = (block_exist[51])?color[623:612]:12'h000;
            tmp_color[635:624] = (block_exist[52])?color[635:624]:12'h222;
            tmp_color[647:636] = (block_exist[53])?color[647:636]:12'h000;
            tmp_color[659:648] = (block_exist[54])?color[659:648]:12'h222;
            tmp_color[671:660] = (block_exist[55])?color[671:660]:12'h000;
            tmp_color[683:672] = (block_exist[56])?color[683:672]:12'h222;
            tmp_color[695:684] = (block_exist[57])?color[695:684]:12'h000;
            tmp_color[707:696] = (block_exist[58])?color[707:696]:12'h222;
            tmp_color[719:708] = (block_exist[59])?color[719:708]:12'h000;
            tmp_color[731:720] = (block_exist[60])?color[731:720]:12'h000;
            tmp_color[743:732] = (block_exist[61])?color[743:732]:12'h222;
            tmp_color[755:744] = (block_exist[62])?color[755:744]:12'h000;
            tmp_color[767:756] = (block_exist[63])?color[767:756]:12'h222;
            tmp_color[779:768] = (block_exist[64])?color[779:768]:12'h000;
            tmp_color[791:780] = (block_exist[65])?color[791:780]:12'h222;
            tmp_color[803:792] = (block_exist[66])?color[803:792]:12'h000;
            tmp_color[815:804] = (block_exist[67])?color[815:804]:12'h222;
            tmp_color[827:816] = (block_exist[68])?color[827:816]:12'h000;
            tmp_color[839:828] = (block_exist[69])?color[839:828]:12'h222;
            tmp_color[851:840] = (block_exist[70])?color[851:840]:12'h222;
            tmp_color[863:852] = (block_exist[71])?color[863:852]:12'h000;
            tmp_color[875:864] = (block_exist[72])?color[875:864]:12'h222;
            tmp_color[887:876] = (block_exist[73])?color[887:876]:12'h000;
            tmp_color[899:888] = (block_exist[74])?color[899:888]:12'h222;
            tmp_color[911:900] = (block_exist[75])?color[911:900]:12'h000;
            tmp_color[923:912] = (block_exist[76])?color[923:912]:12'h222;
            tmp_color[935:924] = (block_exist[77])?color[935:924]:12'h000;
            tmp_color[947:936] = (block_exist[78])?color[947:936]:12'h222;
            tmp_color[959:948] = (block_exist[79])?color[959:948]:12'h000;
            tmp_color[971:960] = (block_exist[80])?color[971:960]:12'h000;
            tmp_color[983:972] = (block_exist[81])?color[983:972]:12'h222;
            tmp_color[995:984] = (block_exist[82])?color[995:984]:12'h000;
            tmp_color[1007:996] = (block_exist[83])?color[1007:996]:12'h222; 
            tmp_color[1019:1008] = (block_exist[84])?color[1019:1008]:12'h000;
            tmp_color[1031:1020] = (block_exist[85])?color[1031:1020]:12'h222;
            tmp_color[1043:1032] = (block_exist[86])?color[1043:1032]:12'h000;
            tmp_color[1055:1044] = (block_exist[87])?color[1055:1044]:12'h222;
            tmp_color[1067:1056] = (block_exist[88])?color[1067:1056]:12'h000;
            tmp_color[1079:1068] = (block_exist[89])?color[1079:1068]:12'h222;
            tmp_color[1091:1080] = (block_exist[90])?color[1091:1080]:12'h222;
            tmp_color[1103:1092] = (block_exist[91])?color[1103:1092]:12'h000;
            tmp_color[1115:1104] = (block_exist[92])?color[1115:1104]:12'h222;
            tmp_color[1127:1116] = (block_exist[93])?color[1127:1116]:12'h000;
            tmp_color[1139:1128] = (block_exist[94])?color[1139:1128]:12'h222;
            tmp_color[1151:1140] = (block_exist[95])?color[1151:1140]:12'h000;
            tmp_color[1163:1152] = (block_exist[96])?color[1163:1152]:12'h222;
            tmp_color[1175:1164] = (block_exist[97])?color[1175:1164]:12'h000;
            tmp_color[1187:1176] = (block_exist[98])?color[1187:1176]:12'h222;
            tmp_color[1199:1188] = (block_exist[99])?color[1199:1188]:12'h000;
            tmp_color[1211:1200] = (block_exist[100])?color[1211:1200]:12'h000;
            tmp_color[1223:1212] = (block_exist[101])?color[1223:1212]:12'h222;
            tmp_color[1235:1224] = (block_exist[102])?color[1235:1224]:12'h000;
            tmp_color[1247:1236] = (block_exist[103])?color[1247:1236]:12'h222;
            tmp_color[1259:1248] = (block_exist[104])?color[1259:1248]:12'h000;
            tmp_color[1271:1260] = (block_exist[105])?color[1271:1260]:12'h222;
            tmp_color[1283:1272] = (block_exist[106])?color[1283:1272]:12'h000;
            tmp_color[1295:1284] = (block_exist[107])?color[1295:1284]:12'h222;
            tmp_color[1307:1296] = (block_exist[108])?color[1307:1296]:12'h000;
            tmp_color[1319:1308] = (block_exist[109])?color[1319:1308]:12'h222;
            tmp_color[1331:1320] = (block_exist[110])?color[1331:1320]:12'h222;
            tmp_color[1343:1332] = (block_exist[111])?color[1343:1332]:12'h000;
            tmp_color[1355:1344] = (block_exist[112])?color[1355:1344]:12'h222;
            tmp_color[1367:1356] = (block_exist[113])?color[1367:1356]:12'h000;
            tmp_color[1379:1368] = (block_exist[114])?color[1379:1368]:12'h222;
            tmp_color[1391:1380] = (block_exist[115])?color[1391:1380]:12'h000;
            tmp_color[1403:1392] = (block_exist[116])?color[1403:1392]:12'h222;
            tmp_color[1415:1404] = (block_exist[117])?color[1415:1404]:12'h000;
            tmp_color[1427:1416] = (block_exist[118])?color[1427:1416]:12'h222;
            tmp_color[1439:1428] = (block_exist[119])?color[1439:1428]:12'h000;
            tmp_color[1451:1440] = (block_exist[120])?color[1451:1440]:12'h000;
            tmp_color[1463:1452] = (block_exist[121])?color[1463:1452]:12'h222;
            tmp_color[1475:1464] = (block_exist[122])?color[1475:1464]:12'h000;
            tmp_color[1487:1476] = (block_exist[123])?color[1487:1476]:12'h222;
            tmp_color[1499:1488] = (block_exist[124])?color[1499:1488]:12'h000;
            tmp_color[1511:1500] = (block_exist[125])?color[1511:1500]:12'h222;
            tmp_color[1523:1512] = (block_exist[126])?color[1523:1512]:12'h000;
            tmp_color[1535:1524] = (block_exist[127])?color[1535:1524]:12'h222;
            tmp_color[1547:1536] = (block_exist[128])?color[1547:1536]:12'h000;
            tmp_color[1559:1548] = (block_exist[129])?color[1559:1548]:12'h222;
            tmp_color[1571:1560] = (block_exist[130])?color[1571:1560]:12'h222;
            tmp_color[1583:1572] = (block_exist[131])?color[1583:1572]:12'h000;
            tmp_color[1595:1584] = (block_exist[132])?color[1595:1584]:12'h222;
            tmp_color[1607:1596] = (block_exist[133])?color[1607:1596]:12'h000;
            tmp_color[1619:1608] = (block_exist[134])?color[1619:1608]:12'h222;
            tmp_color[1631:1620] = (block_exist[135])?color[1631:1620]:12'h000;
            tmp_color[1643:1632] = (block_exist[136])?color[1643:1632]:12'h222;
            tmp_color[1655:1644] = (block_exist[137])?color[1655:1644]:12'h000;
            tmp_color[1667:1656] = (block_exist[138])?color[1667:1656]:12'h222;
            tmp_color[1679:1668] = (block_exist[139])?color[1679:1668]:12'h000;
            tmp_color[1691:1680] = (block_exist[140])?color[1691:1680]:12'h000;
            tmp_color[1703:1692] = (block_exist[141])?color[1703:1692]:12'h222;
            tmp_color[1715:1704] = (block_exist[142])?color[1715:1704]:12'h000;
            tmp_color[1727:1716] = (block_exist[143])?color[1727:1716]:12'h222;
            tmp_color[1739:1728] = (block_exist[144])?color[1739:1728]:12'h000;
            tmp_color[1751:1740] = (block_exist[145])?color[1751:1740]:12'h222;
            tmp_color[1763:1752] = (block_exist[146])?color[1763:1752]:12'h000;
            tmp_color[1775:1764] = (block_exist[147])?color[1775:1764]:12'h222;
            tmp_color[1787:1776] = (block_exist[148])?color[1787:1776]:12'h000;
            tmp_color[1799:1788] = (block_exist[149])?color[1799:1788]:12'h222;
            tmp_color[1811:1800] = (block_exist[150])?color[1811:1800]:12'h222;
            tmp_color[1823:1812] = (block_exist[151])?color[1823:1812]:12'h000;
            tmp_color[1835:1824] = (block_exist[152])?color[1835:1824]:12'h222;
            tmp_color[1847:1836] = (block_exist[153])?color[1847:1836]:12'h000;
            tmp_color[1859:1848] = (block_exist[154])?color[1859:1848]:12'h222;
            tmp_color[1871:1860] = (block_exist[155])?color[1871:1860]:12'h000;
            tmp_color[1883:1872] = (block_exist[156])?color[1883:1872]:12'h222;
            tmp_color[1895:1884] = (block_exist[157])?color[1895:1884]:12'h000;
            tmp_color[1907:1896] = (block_exist[158])?color[1907:1896]:12'h222;
            tmp_color[1919:1908] = (block_exist[159])?color[1919:1908]:12'h000;
            tmp_color[1931:1920] = (block_exist[160])?color[1931:1920]:12'h000;
            tmp_color[1943:1932] = (block_exist[161])?color[1943:1932]:12'h222;
            tmp_color[1955:1944] = (block_exist[162])?color[1955:1944]:12'h000;
            tmp_color[1967:1956] = (block_exist[163])?color[1967:1956]:12'h222;
            tmp_color[1979:1968] = (block_exist[164])?color[1979:1968]:12'h000;
            tmp_color[1991:1980] = (block_exist[165])?color[1991:1980]:12'h222;
            tmp_color[2003:1992] = (block_exist[166])?color[2003:1992]:12'h000;
            tmp_color[2015:2004] = (block_exist[167])?color[2015:2004]:12'h222;
            tmp_color[2027:2016] = (block_exist[168])?color[2027:2016]:12'h000;
            tmp_color[2039:2028] = (block_exist[169])?color[2039:2028]:12'h222;
            tmp_color[2051:2040] = (block_exist[170])?color[2051:2040]:12'h222;
            tmp_color[2063:2052] = (block_exist[171])?color[2063:2052]:12'h000;
            tmp_color[2075:2064] = (block_exist[172])?color[2075:2064]:12'h222;
            tmp_color[2087:2076] = (block_exist[173])?color[2087:2076]:12'h000;
            tmp_color[2099:2088] = (block_exist[174])?color[2099:2088]:12'h222;
            tmp_color[2111:2100] = (block_exist[175])?color[2111:2100]:12'h000;
            tmp_color[2123:2112] = (block_exist[176])?color[2123:2112]:12'h222;
            tmp_color[2135:2124] = (block_exist[177])?color[2135:2124]:12'h000;
            tmp_color[2147:2136] = (block_exist[178])?color[2147:2136]:12'h222;
            tmp_color[2159:2148] = (block_exist[179])?color[2159:2148]:12'h000;
            tmp_color[2171:2160] = (block_exist[180])?color[2171:2160]:12'h000;
            tmp_color[2183:2172] = (block_exist[181])?color[2183:2172]:12'h222;
            tmp_color[2195:2184] = (block_exist[182])?color[2195:2184]:12'h000;
            tmp_color[2207:2196] = (block_exist[183])?color[2207:2196]:12'h222;
            tmp_color[2219:2208] = (block_exist[184])?color[2219:2208]:12'h000;
            tmp_color[2231:2220] = (block_exist[185])?color[2231:2220]:12'h222;
            tmp_color[2243:2232] = (block_exist[186])?color[2243:2232]:12'h000;
            tmp_color[2255:2244] = (block_exist[187])?color[2255:2244]:12'h222;
            tmp_color[2267:2256] = (block_exist[188])?color[2267:2256]:12'h000;
            tmp_color[2279:2268] = (block_exist[189])?color[2279:2268]:12'h222;
            tmp_color[2291:2280] = (block_exist[190])?color[2291:2280]:12'h222;
            tmp_color[2303:2292] = (block_exist[191])?color[2303:2292]:12'h000;
            tmp_color[2315:2304] = (block_exist[192])?color[2315:2304]:12'h222;
            tmp_color[2327:2316] = (block_exist[193])?color[2327:2316]:12'h000;
            tmp_color[2339:2328] = (block_exist[194])?color[2339:2328]:12'h222;
            tmp_color[2351:2340] = (block_exist[195])?color[2351:2340]:12'h000;
            tmp_color[2363:2352] = (block_exist[196])?color[2363:2352]:12'h222;
            tmp_color[2375:2364] = (block_exist[197])?color[2375:2364]:12'h000;
            tmp_color[2387:2376] = (block_exist[198])?color[2387:2376]:12'h222;
            tmp_color[2399:2388] = (block_exist[199])?color[2399:2388]:12'h000;
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

module eraseROW(generate_block,eraseROW_en,block_exist,clk,rst);
input rst;
input clk;
input [199:0]block_exist;
input eraseROW_en;
output generate_block;

wire [19:0] row;

reg [4:0]state;
reg [2:0]count;
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

find_rows_should_be_earsed frsbe (.row(row),.block_exist(block_exist));

always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= INIT;
        count <= 0;
    end
    else begin
        state <= state;
        count <= count;
        case(state)
            INIT:begin
                count <= 0;
            end
            CHECK_ROW1:begin
                state <= CHECK_ROW1;
                count <= (row[0]==1)?count+1:count;

            end
            default: begin end
        endcase
    end
end
endmodule


module putBlock(change_en,write_en,address,w_color,block_exist,generate_block,block_type,block_status,rst,clk,turn_right,turn_left,shift_left,shift_right,clkBlockDown);
input generate_block;
input rst;
input clk;
input [2:0]block_type;
input [1:0]block_status;
input turn_right,turn_left;
input shift_right,shift_left;
input clkBlockDown;
output reg[199:0]change_en;
output reg write_en;
output reg [7:0]address;
output reg [11:0]w_color;
output reg[199:0]block_exist;

wire [11:0]last_w_color; // redundant
reg [1:0]state;
reg [2:0]block;
reg [1:0]status;
reg [4:0]pos_x,pos_y;
reg [4:0]last_pos_x,last_pos_y;
reg start_write;
reg block_settle ;
reg write_new_block;

reg [1:0]tmp_state;
reg [2:0]tmp_block;
reg [1:0]tmp_status;
reg [4:0]tmp_pos_x,tmp_pos_y;
reg [4:0]tmp_last_pos_x,tmp_last_pos_y;
reg tmp_start_write;
reg tmp_block_settle;
reg tmp_write_new_block;

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
reg [3:0]write_state;

reg [199:0]tmp_block_exist;
reg [11:0] tmp_w_color;
reg [7:0]tmp_address;
reg [3:0]tmp_write_state;
reg tmp_write_en;
reg tmp_write_complete;


parameter [3:0] WAIT_WRITE = 4'b0000;
parameter [3:0] WRITE_POS1 = 4'b0001;
parameter [3:0] WRITE_POS2 = 4'b0010;
parameter [3:0] WRITE_POS3 = 4'b0011;
parameter [3:0] WRITE_POS4 = 4'b0100;
parameter [3:0] WRITE_COMPLETE = 4'b0101;
parameter [3:0] SET_BLOCK_EXIST1 = 4'b0110;
parameter [3:0] SET_BLOCK_EXIST2 = 4'b0111;

parameter [3:0] TEST_STATE_1 = 4'b1000;
parameter [3:0] TEST_STATE_2 = 4'b1001;
parameter [3:0] TEST_STATE_3 = 4'b1010;
parameter [3:0] TEST_STATE_4 = 4'b1011;

shape s_now  (.w_color(block_color),.color_pos1(color_pos1),.color_pos2(color_pos2),.color_pos3(color_pos3),
              .color_pos4(color_pos4),.block(block),.status(status),.pos_x(pos_x),.pos_y(pos_y));
shape s_last (.w_color(last_w_color),.color_pos1(last_pos1),.color_pos2(last_pos2),.color_pos3(last_pos3),
              .color_pos4(last_pos4),.block(block),.status(status),.pos_x(last_pos_x),.pos_y(last_pos_y));

one_pulse op1 (.push_onepulse(one_pulse_BlockDown),.rst(rst),.clk(clk),.push_debounced(clkBlockDown));

judgeIFContinueShift jich (.left_en(left_en),.right_en(right_en),.down_en(down_en),.block(block),.status(status),
                           .pos_x(pos_x),.pos_y(pos_y),.block_exist(block_exist));
random_num_generator rng (.q(rondom_num),.clk(clk),.rst(rst));


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
        write_new_block <= 0;
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
        write_new_block <= tmp_write_new_block;
    end
end

always@(*)begin
    case(state)
        `WAIT_BLOCK_EN:begin
            if (generate_block)begin
                tmp_state = `BLOCK_DOWN;
                tmp_block = rondom_num%7;
                tmp_status = rondom_num%4;
                tmp_pos_x = 4;
                tmp_pos_y = 17;
                tmp_start_write = 0;
                tmp_last_pos_x = pos_x;
                tmp_last_pos_y = pos_y;
                tmp_block_settle = 1;
                tmp_write_new_block = 1;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
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
                tmp_write_new_block = 0;
            end 
        end
        `BLOCK_SETTLE:begin
                tmp_state = `WAIT_BLOCK_EN;
                tmp_block = block;
                tmp_status = status;
                tmp_pos_x = pos_x;
                tmp_pos_y = pos_y;                
                tmp_start_write = 0;
                tmp_last_pos_x = last_pos_x;
                tmp_last_pos_y = last_pos_y; 
                tmp_block_settle = 0;    
                tmp_write_new_block = 0;
        end
        default:begin
        end
    endcase
end
/*always@(posedge clk or posedge rst)begin
    if(rst)begin
        write_state <= WAIT_WRITE;                    
        write_en <= 0;
        address <= 0;
        block_exist <= 0;
        w_color <= 0;
        write_complete<=0;
    end
    else begin
        write_state <= tmp_write_state;                    
        write_en <= tmp_write_en;
        address <= tmp_address;
        block_exist <= tmp_block_exist;
        w_color <= tmp_w_color;
        write_complete<=tmp_write_complete;
    end
end
always@(*)begin
    tmp_write_state = write_state;                    
    tmp_write_en = write_en;
    tmp_address = address;
    tmp_block_exist = block_exist;
    tmp_w_color = w_color;
    tmp_write_complete =write_complete;
    case(write_state)
        WAIT_WRITE:begin
            if(start_write)begin
                tmp_write_state = SET_BLOCK_EXIST1;
                tmp_write_en = 0;
                tmp_address = 0;
                tmp_w_color = 0;
                tmp_write_complete = 0;
            end
            else if (write_new_block)begin
                tmp_write_state = SET_BLOCK_EXIST2;
                tmp_write_en = 0;
                tmp_address = 0;
                tmp_w_color = 0;
                tmp_write_complete = 0;
            end
            else begin
                tmp_write_state = WAIT_WRITE;
                tmp_write_en = 0;
                tmp_address = 0;
                tmp_w_color = 0;
                tmp_write_complete = 0;
            end
        end
        SET_BLOCK_EXIST1:begin
            tmp_write_state = WRITE_POS1;
            tmp_block_exist[last_pos1] =  0;
            tmp_block_exist[last_pos2] =  0;
            tmp_block_exist[last_pos3] =  0;
            tmp_block_exist[last_pos4] =  0;
            tmp_block_exist[color_pos1] = 1;
            tmp_block_exist[color_pos2] = 1;
            tmp_block_exist[color_pos3] = 1;
            tmp_block_exist[color_pos4] = 1;
        end
        SET_BLOCK_EXIST2:begin
            tmp_write_state = WRITE_POS1;
            tmp_block_exist[last_pos1] =  1;
            tmp_block_exist[last_pos2] =  1;
            tmp_block_exist[last_pos3] =  1;
            tmp_block_exist[last_pos4] =  1;
            tmp_block_exist[color_pos1] = 1;
            tmp_block_exist[color_pos2] = 1;
            tmp_block_exist[color_pos3] = 1;
            tmp_block_exist[color_pos4] = 1;
        end
        WRITE_POS1:begin
            tmp_write_state = WRITE_POS2;
            tmp_write_en = 1;
            tmp_address = color_pos1;
            tmp_w_color = block_color;
            tmp_write_complete = 0;
        end
        WRITE_POS2:begin
            tmp_write_state = WRITE_POS3;
            tmp_write_en = 1;
            tmp_address = color_pos2;
            tmp_w_color = block_color;
            tmp_write_complete = 0;
        end
        WRITE_POS3:begin
            tmp_write_state = WRITE_POS4;
            tmp_write_en = 1;
            tmp_address = color_pos3;
            tmp_w_color = block_color;
            tmp_write_complete = 0;
        end
        WRITE_POS4:begin
            tmp_write_state = WRITE_COMPLETE;
            tmp_write_en = 1;
            tmp_address = color_pos4;
            tmp_w_color = block_color;
            tmp_write_complete = 0;
        end
        WRITE_COMPLETE:begin
            tmp_write_state = WAIT_WRITE;
            tmp_write_en = 0;
            tmp_address = 0;
            tmp_w_color = 0;
            tmp_write_complete = 1;
        end
        default:begin
            
        end
    endcase
end*/
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
                else if(write_new_block)begin
                    write_state <= SET_BLOCK_EXIST2;
                    write_en <= 0;
                    address <= 0;
                    w_color <= 0;
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
            SET_BLOCK_EXIST2:begin
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
reg [27:0] num;
wire [27:0] next_num;

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


