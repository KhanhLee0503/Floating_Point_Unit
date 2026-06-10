module LZC_16BIT(
    input  logic [15:0] I_DATA,
    output logic [4:0]  O_CNT,      // 16-bit đếm tối đa là 16 (cần 5 bit)
    output logic        O_ALL_ZERO
);
    logic [3:0] cnt_h, cnt_l;
    logic       all_zero_h, all_zero_l;

    LZC_8BIT lzc_h (.I_DATA(I_DATA[15:8]), .O_CNT(cnt_h), .O_ALL_ZERO(all_zero_h));
    LZC_8BIT lzc_l (.I_DATA(I_DATA[7:0]),  .O_CNT(cnt_l), .O_ALL_ZERO(all_zero_l));

    assign O_ALL_ZERO = all_zero_h & all_zero_l;

    // Nếu nửa cao (8-bit đầu) toàn 0, kết quả = 8 + nửa thấp
    assign O_CNT = (all_zero_h) ? (5'd8 + cnt_l) : {1'b0, cnt_h};

endmodule: LZC_16BIT