module clock_divisor(clk1, clk,clkBlockDown_slow,clkBlockDown_fast,clk22);
input clk;
output clk1;
output clk22;
output clkBlockDown_slow;
output clkBlockDown_fast;
reg [27:0] num;
wire [27:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end
assign next_num = num + 1'b1;
assign clk1 = num[1];
assign clk22 = num[21];
assign clkBlockDown_slow = num[25];
assign clkBlockDown_fast = num[22];
endmodule