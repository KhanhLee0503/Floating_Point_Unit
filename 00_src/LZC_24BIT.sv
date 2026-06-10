module LZC_24BIT(
    input  logic [23:0] I_DATA_IN,
    output logic [4:0]  O_CNT,      // 24-bit cần 5 bit kết quả (đếm từ 0 đến 24)
    output logic        O_ALL_ZERO
);
    logic [3:0] cnt_h;              // Output của khối 8-bit là 4 bit
    logic [4:0] cnt_l;              // Output của khối 16-bit là 5 bit
    logic       all_zero_h, all_zero_l;

    // 1. Nửa cao (MSB side): Đưa 8 bit cao nhất vào khối LZC 8-bit
    LZC_8BIT lzc_h (
        .I_DATA(I_DATA_IN[23:16]), 
        .O_CNT(cnt_h), 
        .O_ALL_ZERO(all_zero_h)
    );

    // 2. Nửa thấp (LSB side): Đưa 16 bit còn lại vào khối LZC 16-bit
    LZC_16BIT lzc_l (
        .I_DATA(I_DATA_IN[15:0]),  
        .O_CNT(cnt_l), 
        .O_ALL_ZERO(all_zero_l)
    );

    // 3. Logic cờ ALL_ZERO: Chỉ bằng 1 khi cả khối trên và khối dưới đều bằng 1
    assign O_ALL_ZERO = all_zero_h & all_zero_l;

    // 4. Logic chọn bộ đếm (MUX Logic)
    // - Nếu 8 bit cao toàn 0 (all_zero_h = 1): Số lượng số 0 = 8 + số đếm được ở khối 16-bit
    // - Nếu 8 bit cao có chứa số 1: Số lượng số 0 chỉ nằm trong khối 8-bit cao (bỏ qua khối thấp)
    assign O_CNT = (all_zero_h) ? (5'd8 + cnt_l) : {1'b0, cnt_h};

endmodule: LZC_24BIT