module LZC_4BIT(
    input  logic [3:0] I_DATA,
    output logic [2:0] O_CNT,       // 4-bit thì đếm tối đa là 4 (cần 3 bit)
    output logic       O_ALL_ZERO
);
    logic [1:0] cnt_h, cnt_l;
    logic       all_zero_h, all_zero_l;

    // Chia 4-bit thành 2 cụm 2-bit
    LZC_2BIT lzc_h (.I_DATA(I_DATA[3:2]), .O_CNT(cnt_h), .O_ALL_ZERO(all_zero_h));
    LZC_2BIT lzc_l (.I_DATA(I_DATA[1:0]), .O_CNT(cnt_l), .O_ALL_ZERO(all_zero_l));

    assign O_ALL_ZERO = all_zero_h & all_zero_l;

    // Logic ghép: Nếu cụm cao toàn 0, kết quả = 2 + cụm thấp. Ngược lại lấy cụm cao.
    assign O_CNT = (all_zero_h) ? (3'd2 + cnt_l) : {1'b0, cnt_h};

endmodule: LZC_4BIT