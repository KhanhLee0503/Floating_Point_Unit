module BARREL_RIGHT_SHIFTER_48BIT (
    input  logic [47:0] I_DATA,        // Dữ liệu vào 48-bit
    input  logic [5:0]  I_SHAMT,       // Số bit cần dịch (0-63, nhưng thực tế dùng đến 47)
    input  logic        I_SHIFT_IN,    // Bit chèn vào (thường là I_DATA[47] nếu dịch số học)
    output logic [47:0] O_DATA         // Dữ liệu sau khi dịch
);

    logic [47:0] s5, s4, s3, s2, s1;

    assign s5 = I_SHAMT[5] ? { {32{I_SHIFT_IN}}, I_DATA[47:32] } : I_DATA;
    assign s4 = I_SHAMT[4] ? { {16{I_SHIFT_IN}}, s5[47:16] } : s5;
    assign s3 = I_SHAMT[3] ? { {8{I_SHIFT_IN}}, s4[47:8] } : s4;
    assign s2 = I_SHAMT[2] ? { {4{I_SHIFT_IN}}, s3[47:4] } : s3;
    assign s1 = I_SHAMT[1] ? { {2{I_SHIFT_IN}}, s2[47:2] } : s2;
    assign O_DATA = I_SHAMT[0] ? { {1{I_SHIFT_IN}}, s1[47:1] } : s1;

endmodule: BARREL_RIGHT_SHIFTER_48BIT