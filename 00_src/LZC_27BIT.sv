module LZC_27BIT(
    input  logic [26:0] I_DATA_IN,
    output logic [4:0]  O_CNT,      // 27-bit cần 5 bit kết quả (đếm từ 0 đến 27)
    output logic        O_ALL_ZERO
);

    logic [1:0] cnt_h;              // Đếm tối đa 3 cho 3 bit cao (cần 2 bit)
    logic       all_zero_h;
    
    logic [4:0] cnt_l;              // Output của khối 24-bit là 5 bit 
    logic       all_zero_l;

    // ==========================================
    // 1. Nửa cao (MSB side): Xử lý 3 bit [26:24]
    // ==========================================
    assign all_zero_h = ~(I_DATA_IN[26] | I_DATA_IN[25] | I_DATA_IN[24]);

    // Bộ mã hóa ưu tiên (Priority Encoder) đếm số 0 dẫn đầu cho 3 bit
    always_comb begin
        if      (I_DATA_IN[26]) cnt_h = 2'd0;
        else if (I_DATA_IN[25]) cnt_h = 2'd1;
        else if (I_DATA_IN[24]) cnt_h = 2'd2;
        else                    cnt_h = 2'd3; // Trường hợp all_zero_h = 1
    end

    // ==========================================
    // 2. Nửa thấp (LSB side): Dùng LZC 24-bit đã có
    // ==========================================
    LZC_24BIT lzc_l (
        .I_DATA_IN(I_DATA_IN[23:0]), 
        .O_CNT(cnt_l), 
        .O_ALL_ZERO(all_zero_l)
    );

    // ==========================================
    // 3. Logic ghép nối kết quả
    // ==========================================
    // Cờ ALL_ZERO chỉ bằng 1 khi cả phần cao và thấp đều toàn 0
    assign O_ALL_ZERO = all_zero_h & all_zero_l;

    // Logic chọn bộ đếm:
    // - Nếu 3 bit cao toàn 0: Tổng số bit 0 = 3 + số lượng bit 0 đếm được ở khối 24-bit thấp
    // - Nếu 3 bit cao có số 1: Số lượng bit 0 dẫn đầu chỉ nằm trong phần 3 bit cao
    assign O_CNT = (all_zero_h) ? (5'd3 + cnt_l) : {3'b000, cnt_h};

endmodule: LZC_27BIT