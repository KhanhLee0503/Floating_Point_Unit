module CORNER_CASE_CHECK(
    input  logic        I_ADD_SUB,
    input  logic        I_SIGN_A,         // Bổ sung bit dấu A
    input  logic        I_SIGN_B,         // Bổ sung bit dấu B
    input  logic [22:0] I_MANTISSA,       
    input  logic [7:0]  I_EXPONENT,       
    input  logic [7:0]  I_PRE_A_EXPONENT, 
    input  logic [7:0]  I_PRE_B_EXPONENT, 
    input  logic [22:0] I_PRE_A_MANTISSA, 
    input  logic [22:0] I_PRE_B_MANTISSA, 

    output logic        O_ZERO,
    output logic        O_SUBNORMAL,
    output logic        O_INFINITY,
    output logic        O_NOT_A_NUMBER
);

    // 1. Phân loại chi tiết thuộc tính toán hạng đầu vào
    logic w_a_is_inf, w_b_is_inf;
    logic w_a_is_nan, w_b_is_nan;
    logic w_a_is_zero, w_b_is_zero;

    logic [7:0] w_exponent_addsub;

    assign w_a_is_inf = (I_PRE_A_EXPONENT == 8'hFF) & (I_PRE_A_MANTISSA == 23'b0);
    assign w_b_is_inf = (I_PRE_B_EXPONENT == 8'hFF) & (I_PRE_B_MANTISSA == 23'b0);
    
    assign w_a_is_nan = (I_PRE_A_EXPONENT == 8'hFF) & (I_PRE_A_MANTISSA != 23'b0);
    assign w_b_is_nan = (I_PRE_B_EXPONENT == 8'hFF) & (I_PRE_B_MANTISSA != 23'b0);

    assign w_a_is_zero = (I_PRE_A_EXPONENT == 8'h00) & (I_PRE_A_MANTISSA == 23'b0);
    assign w_b_is_zero = (I_PRE_B_EXPONENT == 8'h00) & (I_PRE_B_MANTISSA == 23'b0);

    // 2. Xác định phép trừ thực tế (Effective Subtraction)
    // Phép tính mang bản chất trừ khi: Cùng dấu làm phép trừ HOẶC Khác dấu làm phép cộng
    logic w_effective_sub;
    assign w_effective_sub = I_SIGN_A ^ I_SIGN_B ^ I_ADD_SUB;

    // Phát hiện trường hợp đặc biệt: Vô cực trừ Vô cực sinh ra NaN
    logic w_inf_sub_inf;
    assign w_inf_sub_inf = w_a_is_inf & w_b_is_inf & w_effective_sub;

    assign w_exponent_addsub = (w_effective_sub) ? (I_PRE_A_EXPONENT - I_PRE_B_EXPONENT) : (I_PRE_A_EXPONENT + I_PRE_B_EXPONENT);

    // ====================================================================
    // CÁC CỜ TRẠNG THÁI ĐẦU RA (Được thiết kế loại trừ nhau - Mutual Exclusive)
    // ====================================================================

    // Cờ NaN: Bật khi bản thân đầu vào chứa NaN HOẶC phép toán sinh ra NaN (Inf - Inf)
    // HOẶC Datapath sau tính toán bị rơi vào vùng NaN.
    assign O_NOT_A_NUMBER = w_a_is_nan | w_b_is_nan | w_inf_sub_inf |
                            ((I_EXPONENT == 8'hFF) & (I_MANTISSA != 23'b0));

    // Cờ Infinity: Đầu vào có Inf HOẶC kết quả tràn số, và PHẢI loại trừ trường hợp Inf - Inf (NaN)
    assign O_INFINITY     = ((w_a_is_inf | w_b_is_inf) | ((I_EXPONENT == 8'hFF) & (I_MANTISSA == 23'b0))) 
                            & ~O_NOT_A_NUMBER;

    // Cờ Zero: Chỉ bật khi không phải NaN/Inf và kết quả cuối cùng thực sự bằng 0
    assign O_ZERO         = ~O_NOT_A_NUMBER & ~O_INFINITY & 
                            (w_exponent_addsub == 8'h00) & (I_MANTISSA == 23'b0);

    // Cờ Subnormal: Chỉ bật khi không phải NaN/Inf và số mũ cuối cùng bằng 0 (phần phân số khác 0)
    assign O_SUBNORMAL    = ~O_NOT_A_NUMBER & ~O_INFINITY & 
                            (w_exponent_addsub == 8'h00) & (I_MANTISSA != 23'b0);

endmodule: CORNER_CASE_CHECK