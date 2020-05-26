module pixel_gen(vgaRed,vgaGreen,vgaBlue,h_cnt,v_cnt,valid,color);
input [9:0] h_cnt;
input [9:0] v_cnt;
input valid;
input [2879:0] color;
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
