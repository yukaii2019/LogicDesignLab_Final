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

`define WAIT_BLOCK_EN 4'b0000
`define BLOCK_DOWN 4'b0001
`define BLOCK_SETTLE 4'b0010
`define SET_START_WRITE0 4'b0011
`define ERASE_STATE 4'b0100
`define CAL_BLOCKDOWN 4'b0101
`define DET_ROTATE 4'b0110
`define SET_INIT_XY 4'b0111
`define WRITE_SPACE 4'b1000

`define COLOR_J 12'h00f
`define COLOR_L 12'hf60
`define COLOR_S 12'h0f0
`define COLOR_T 12'hd7d
`define COLOR_Z 12'hf00
`define COLOR_I 12'h0ff
`define COLOR_O 12'hff0

`define INIT 2'b00
`define WAIT_FOR_SIGNAL 2'b01
`define GET_SIGNAL_DOWN 2'b10
`define WAIT_RELEASE 2'b11
`define IS_INIT 8'hAA
`define IS_EXTEND 8'hE0
`define IS_BREAK 8'hF0

`define KEY_CODE_UP 9'h075
`define KEY_CODE_DOWN 9'h072
`define KEY_CODE_LEFT 9'h06b
`define KEY_CODE_RIGHT 9'h174
`define KEY_CODE_SPACE 9'h029