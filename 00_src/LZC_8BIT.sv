module LZC_8BIT(
    input  logic [7:0] I_DATA,
    output logic [3:0] O_CNT,       // 8-bit đếm tối đa là 8 (cần 4 bit)
    output logic       O_ALL_ZERO
);
    logic [2:0] cnt_h, cnt_l;
    logic       all_zero_h, all_zero_l;

    LZC_4BIT lzc_h (.I_DATA(I_DATA[7:4]), .O_CNT(cnt_h), .O_ALL_ZERO(all_zero_h));
    LZC_4BIT lzc_l (.I_DATA(I_DATA[3:0]), .O_CNT(cnt_l), .O_ALL_ZERO(all_zero_l));

    assign O_ALL_ZERO = all_zero_h & all_zero_l;
    
    // Nếu nửa cao (4-bit đầu) toàn 0, kết quả = 4 + nửa thấp
    assign O_CNT = (all_zero_h) ? (4'd4 + cnt_l) : {1'b0, cnt_h};

endmodule: LZC_8BIT