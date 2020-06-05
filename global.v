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

`define WAIT_BLOCK_EN             5'b00000
`define BLOCK_DOWN                5'b00001
`define BLOCK_SETTLE              5'b00010
`define SET_START_WRITE0          5'b00011
`define ERASE_STATE               5'b00100
`define CAL_BLOCKDOWN             5'b00101
`define DET_ROTATE                5'b00110
`define SET_INIT_XY               5'b00111
`define WRITE_SPACE               5'b01000
`define WAIT_GAME_START           5'b01001
`define WRITE_FORESEE_BLOCK       5'b01010
`define SET_START_STORE_BLOCK     5'b01011
`define STORE_BLOCK               5'b01100
`define SET_START_STORE_BLOCK_TO1 5'b01101
`define CHECK_GAMEOVER            5'b01110
`define GAMEOVER                  5'b01111
`define CAL_BOTTOM_Y              5'b10000

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
`define KEY_CODE_SHIFT 9'h012