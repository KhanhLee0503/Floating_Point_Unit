module BARREL_LEFT_SHIFTER_32BIT(
    input logic  [31:0] I_DATA_IN,
    input logic  [4:0]  I_SHIFT_AMOUNT,
    output logic [31:0] O_DATA_OUT
);

// Khai báo các đường tín hiệu trung gian 32-bit
logic [31:0] P0;
logic [31:0] P1;
logic [31:0] P2;
logic [31:0] P3;

// Tầng 4: Kiểm tra bit thứ 4, nếu bằng 1 thì dịch trái 16 bit
// Giữ lại 16 bit cuối (15:0) và chèn 16 bit 0 vào vị trí LSB
assign P3         = (I_SHIFT_AMOUNT[4]) ? {I_DATA_IN[15:0], 16'b0} : I_DATA_IN;
// Tầng 3: Kiểm tra bit thứ 3, nếu bằng 1 thì dịch trái 8 bit
// Giữ lại 24 bit cuối (23:0) và chèn 8 bit 0 vào vị trí LSB
assign P2         = (I_SHIFT_AMOUNT[3]) ? {P3[23:0], 8'b0}         : P3;
// Tầng 2: Kiểm tra bit thứ 2, nếu bằng 1 thì dịch trái 4 bit
// Giữ lại 28 bit cuối (27:0) và chèn 4 bit 0 vào vị trí LSB
assign P1         = (I_SHIFT_AMOUNT[2]) ? {P2[27:0], 4'b0}         : P2;
// Tầng 1: Kiểm tra bit thứ 1, nếu bằng 1 thì dịch trái 2 bit
// Giữ lại 30 bit cuối (29:0) và chèn 2 bit 0 vào vị trí LSB
assign P0         = (I_SHIFT_AMOUNT[1]) ? {P1[29:0], 2'b0}         : P1;
// Tầng 0: Kiểm tra bit thứ 0, nếu bằng 1 thì dịch trái 1 bit
// Giữ lại 31 bit cuối (30:0) và chèn 1 bit 0 vào vị trí LSB
assign O_DATA_OUT = (I_SHIFT_AMOUNT[0]) ? {P0[30:0], 1'b0}         : P0;

endmodule : BARREL_LEFT_SHIFTER_32BIT