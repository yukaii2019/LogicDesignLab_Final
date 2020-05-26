`include "C:\Users\ACER\Desktop\logic_design_lab\FINAL\FinalProjectRepo\global.v"
module keyboardSignal(space,right,left,up,down,clk,rst,PS2_DATA,PS2_CLK);
output reg right;
output reg left;
output reg up;
output reg down;
output reg space;
input clk ,rst;
inout PS2_DATA;
inout PS2_CLK;

wire ready;
wire [8:0]now_pressing;
keyboard k(.ready(ready),.now_pressing(now_pressing),.PS2_DATA(PS2_DATA),.PS2_CLK(PS2_CLK),.clk(clk),.rst(rst));

always@(posedge clk or posedge rst)begin
	if(rst)begin
		right <= 0;
		left <= 0;
		up <= 0;
		down <= 0;
		space <= 0;
	end
	else begin
		right <= right;
		left <= left;
		up <= up;
		down <= down;
		space <= space;
		if(ready)begin
			up <= (now_pressing==`KEY_CODE_UP)?1:0;
			down <= (now_pressing==`KEY_CODE_DOWN)?1:0;
			left <= (now_pressing==`KEY_CODE_LEFT)?1:0;
			right <=(now_pressing==`KEY_CODE_RIGHT)?1:0;
			space <= (now_pressing==`KEY_CODE_SPACE)?1:0;
		end
		else begin 
			up <= 0;
			down <= 0;
			left <= 0;
			right <= 0;
			space <= 0;
		end
	end
end

endmodule
module keyboard(ready,now_pressing,PS2_DATA,PS2_CLK,clk,rst);
inout  PS2_DATA;
inout  PS2_CLK;
input clk;
input rst;
wire[511:0]key_down;
wire[8:0] last_change;
wire been_ready;
output reg ready;
output reg [8:0]now_pressing;
reg valid;

KeyboardDecoder key_de (.key_down(key_down),.last_change(last_change),.key_valid(been_ready),.PS2_DATA(PS2_DATA),
	                    .PS2_CLK(PS2_CLK),.rst(rst),.clk(clk));
always@(*)begin
    case(last_change)
        `KEY_CODE_UP    : begin valid = 1;end
        `KEY_CODE_DOWN  : begin valid = 1;end
        `KEY_CODE_LEFT  : begin valid = 1;end
        `KEY_CODE_RIGHT : begin valid = 1;end
        `KEY_CODE_SPACE : begin valid = 1;end
        default         : begin valid = 0;end 
    endcase
end 

always@(posedge clk or posedge rst)begin
    if(rst)begin
        now_pressing <= 0;
		ready <= 0;
    end
    else begin
        now_pressing <= now_pressing;
		ready <= ready;
        if(been_ready && key_down[last_change] == 1)begin
            if(valid == 1)begin
                now_pressing <= last_change;
				ready <= 1;
            end    
        end
        else if(been_ready && key_down[now_pressing] == 0 && valid == 1)begin
            now_pressing <= 0;
			ready <= 0;
        end
    end
end
endmodule

module KeyboardDecoder(key_down,last_change,key_valid,PS2_DATA,PS2_CLK,rst,clk);

output [511:0]  key_down;
output [8:0] last_change;
output key_valid;
inout  PS2_DATA;
inout  PS2_CLK;
input  rst;
input  clk;

reg [511:0] key_down;
reg key_valid;
reg [9:0] key;		// key = {been_extend, been_break, key_in}
reg [1:0] state;
reg been_ready, been_extend, been_break;
wire [7:0] key_in;
wire is_extend;
wire is_break;
wire valid;
wire err;
wire [511:0] key_decode = 1 << last_change;
wire pulse_been_ready;
assign last_change = {key[9], key[7:0]};

KeyboardCtrl_0 inst (.key_in(key_in),.is_extend(is_extend),.is_break(is_break),.valid(valid),
	                 .err(err),.PS2_DATA(PS2_DATA),.PS2_CLK(PS2_CLK),.rst(rst),.clk(clk));

One_pulse op (.one_pulse_signal(pulse_been_ready),.signal(been_ready),.clk(clk));
always @ (posedge clk, posedge rst) begin
if (rst) begin
	state <= `INIT;
	been_ready  <= 1'b0;
	been_extend <= 1'b0;
	been_break  <= 1'b0;
	key <= 10'b0_0_0000_0000;
end 
else begin
	state <= state;
	been_ready  <= been_ready;
	been_extend <= (is_extend) ? 1'b1 : been_extend;
	been_break  <= (is_break) ? 1'b1 : been_break;
	key <= key;
	case (state)
		`INIT:begin
			if (key_in == `IS_INIT) begin
				state <= `WAIT_FOR_SIGNAL;
				been_ready  <= 1'b0;
				been_extend <= 1'b0;
				been_break  <= 1'b0;
				key <= 10'b0_0_0000_0000;
			end 
            else begin
				state <= `INIT;
			end
		end
		`WAIT_FOR_SIGNAL : begin
			if (valid == 0) begin
				state <= `WAIT_FOR_SIGNAL;
				been_ready <= 1'b0;
			end 
            else begin
				state <= `GET_SIGNAL_DOWN;
			end
		end
		`GET_SIGNAL_DOWN : begin
			state <= `WAIT_RELEASE;
			key <= {been_extend, been_break, key_in};
			been_ready  <= 1'b1;
		end
		`WAIT_RELEASE : begin
			if (valid == 1) begin
				state <= `WAIT_RELEASE;
			end 
            else begin
				state <= `WAIT_FOR_SIGNAL;
				been_extend <= 1'b0;
				been_break  <= 1'b0;
			end
		end
		default : begin
			state <= `INIT;
			been_ready  <= 1'b0;
			been_extend <= 1'b0;
			been_break  <= 1'b0;
			key <= 10'b0_0_0000_0000;
		end
	endcase
end
end
always @ (posedge clk, posedge rst) begin
	if (rst) begin
		key_valid <= 1'b0;
		key_down <= 511'b0;
	end 
    else if (key_decode[last_change] && pulse_been_ready) begin
		key_valid <= 1'b1;
		if (key[8] == 0) begin
			key_down <= key_down | key_decode;
		end 
        else begin
			key_down <= key_down & (~key_decode);
		end
	end 
    else 
    begin
		key_valid <= 1'b0;
		key_down <= key_down;
	end
end
endmodule
module One_pulse(one_pulse_signal,signal,clk);
output  one_pulse_signal;
input signal ,clk;
reg one_pulse_signal;
reg delay_signal;
always @(posedge clk)begin
    if(signal == 1 & delay_signal == 0)begin
        one_pulse_signal <= 1;
    end
    else begin
        one_pulse_signal <= 0;
    end
    delay_signal <= signal;
end
endmodule