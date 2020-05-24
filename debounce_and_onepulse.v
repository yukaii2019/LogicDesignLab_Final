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