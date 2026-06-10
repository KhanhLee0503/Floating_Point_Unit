`timescale 1ns/1ns
module fpu_top_tb();
reg [31:0] i_32_a;  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  
reg [31:0] i_32_b;  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  

reg  i_add_sub;
    
wire [31:0] o_32_s;
wire o_ov_flag;     // Kết nối với O_FP_INFINITY
wire o_un_flag;     // Kết nối với O_FP_SUBNORMAL
wire o_zero_flag;   // Kết nối với O_FP_ZERO
wire o_nan_flag;    // Kết nối với O_FP_NOT_A_NUMBER

// --- KHAI BÁO CÁC WIRE TRUNG GIAN ---
wire        w_sign;
wire [7:0]  w_exponent;
wire [22:0] w_mantissa;

// Khởi tạo module FPU_TOP và nối ĐỦ các port
FPU_TOP DUT (
    .I_FP_DATA_A     (i_32_a),
    .I_FP_DATA_B     (i_32_b),
    .I_ADD_SUB       (i_add_sub),
    .O_FP_SIGN       (w_sign),
    .O_FP_EXPONENT   (w_exponent),
    .O_FP_MANTISSA   (w_mantissa),
    .O_FP_ZERO       (o_zero_flag), 
    .O_FP_INFINITY   (o_ov_flag),  
    .O_FP_SUBNORMAL  (o_un_flag),  
    .O_FP_NOT_A_NUMBER(o_nan_flag)
);

// Gộp các thành phần lại thành kết quả 32-bit theo đúng kỳ vọng của testbench
assign o_32_s = {w_sign, w_exponent, w_mantissa};

shortreal a_real;
shortreal b_real;
reg [31:0] expected_bits;
shortreal expected_real;
integer i;
reg [6:0] fail_num;

initial begin
    i_32_a = 32'b0; 
    i_32_b = 32'b0; 
    i_add_sub = 1'b0;
    fail_num = 7'b0;
   
    $display(" ");
    $display("################## Testing random 100 generated input combinations (ADDING) ####################");
    i_add_sub = 1'b0; // Test phép cộng

    for(i=0; i<100; i=i+1) begin
        $display(" ");
        // Tạo số thực ngẫu nhiên
        a_real = $itor($random) / 1000.0;
        b_real = $itor($random) / 1000.0;

        // Chuyển đổi sang bits để nạp vào Input
        i_32_a = $shortrealtobits(a_real);
        i_32_b = $shortrealtobits(b_real);

        // Tính toán kết quả kỳ vọng
        expected_real = a_real + b_real;
        expected_bits = $shortrealtobits(expected_real);

        #20; // Chờ module phản hồi

        $display("----------Test [%0d]: Adding (%f) + (%f) !!--------------", i, a_real, b_real);
        // So sánh kết quả và kiểm tra các cờ đặc biệt
        if((o_32_s - expected_bits == 1) ||  (o_32_s - expected_bits == -1) || (o_32_s == expected_bits)) begin
            $display("[%t ns] PASSED: Result = %h", $time, o_32_s);
            
            // Theo dõi và in ra các cờ special cases nếu chúng được bật
            if (o_ov_flag)   $display("  -> FLAG ON: Infinity / Overflow detected!");
            if (o_un_flag)   $display("  -> FLAG ON: Subnormal / Underflow detected!");
            if (o_zero_flag) $display("  -> FLAG ON: Zero result detected!");
            if (o_nan_flag)  $display("  -> FLAG ON: Not-A-Number (NaN) detected!");

        end
        else begin
            $display("[%t ns] ==>FAILED: Got %h, Expected %h", $time, o_32_s, expected_bits);
            $display("   Real Got: %f | Real Exp: %f", $bitstoshortreal(o_32_s), expected_real);
            fail_num = fail_num + 1;
        end
    end

    $display(" ");
    $display("==> Numbers of failed cases: %d", fail_num);
  
    $display(" ");
    $display("################## Testing random 100 generated input combinations (SUBTRACTING) ####################");
    fail_num  = 7'b0;
    i_add_sub = 1'b1;
    // Test subtraction 

    for(i=0; i<100; i=i+1) begin
        $display(" ");
        // Tạo số thực ngẫu nhiên chuẩn hơn
        a_real = $itor($random) / 1000.0;
        b_real = $itor($random) / 1000.0;

        // Chuyển đổi sang bits để nạp vào Input
        i_32_a = $shortrealtobits(a_real);
        i_32_b = $shortrealtobits(b_real);

        // Tính toán kết quả kỳ vọng
        expected_real = a_real - b_real;
        expected_bits = $shortrealtobits(expected_real);

        #50; // Chờ module phản hồi

        $display("----------Test [%0d]: Subtracting (%f) - (%f) !!--------------", i, a_real, b_real);
        if((o_32_s - expected_bits == 1) ||  (o_32_s - expected_bits == -1) || (o_32_s == expected_bits)) begin
            $display("[%t ns] PASSED: Result = %h", $time, o_32_s);
            
            // Theo dõi cờ special cases
            if (o_ov_flag)   $display("  -> FLAG ON: Infinity / Overflow detected!");
            if (o_un_flag)   $display("  -> FLAG ON: Subnormal / Underflow detected!");
            if (o_zero_flag) $display("  -> FLAG ON: Zero result detected!");
            if (o_nan_flag)  $display("  -> FLAG ON: Not-A-Number (NaN) detected!");

        end
        else begin
            $display("[%t ns] ==>FAILED: Got %h, Expected %h", $time, o_32_s, expected_bits);
            $display("   Real Got: %f | Real Exp: %f", $bitstoshortreal(o_32_s), expected_real);
            fail_num = fail_num + 1;
        end
    end

    $display(" ");
    $display("==> Numbers of failed cases: %d", fail_num);

    $display(" ");
    $display("################## Testing Special Cases ####################");
    $display(" ");
    #100;
    
    // --- SPECIAL CASE: ZERO ---
    $display("*** Subtracting a number by itself (Zero test) ***");
    i_add_sub = 1'b1;
    i_32_a = 32'b0_10000010_01100100000000000000000;
    i_32_b = 32'b0_10000010_01100100000000000000000;
    #100;
    if(o_zero_flag)
        $display("PASSED: The Zero flag has been set !!");
    else
        $display("==> FAILED: The Zero flag is not working !!");
    $display(" ");

    #10;
    // --- SPECIAL CASE: INFINITY / OVERFLOW ---
    $display("*** Adding Infinity(A) to a random number(B) ***");
    i_add_sub = 1'b0;
    i_32_a = 32'b0_11111111_00000000000000000000000;
    i_32_b = 32'b0_10000010_01100100000000000000000;

    #10;
    if(o_ov_flag)
        $display("PASSED: The overflow flag has been set !!");
    else
        $display("==> FAILED: The overflow flag is not working !!");
    $display(" ");

    #10;
    $display(" ");
    $display("*** Adding Infinity(B) to a random number(A) ***");
    i_add_sub = 1'b0;
    i_32_b = 32'b0_11111111_00000000000000000000000;
    i_32_a = 32'b1_10000111_01000110000000000000000;

    #10;
    if(o_ov_flag)
        $display("PASSED: The overflow flag has been set !!");
    else
        $display("==> FAILED: The overflow flag is not working !!");
    $display(" ");

    #10;
    $display(" ");
    $display("*** Adding exponent 254 to exponent 254 ***");
    i_add_sub = 1'b0;
    i_32_a = 32'b0_11111110_00001100000000000000000;
    i_32_b = 32'b0_11111110_11000000000000000000000;

    #10;
    if(o_ov_flag)
        $display("PASSED: The overflow flag has been set !!");
    else
        $display("==> FAILED: The overflow flag is not working !!");
    $display(" ");

    #10; 
    // --- SPECIAL CASE: SUBNORMAL / UNDERFLOW ---
    $display(" ");
    $display("*** Checking Underflow ***");
    i_add_sub = 1'b1;
    i_32_a = 32'b0_00000001_00000000000000000000010;
    i_32_b = 32'b0_00000000_10000000000000000000001;

    #10;
    if(o_un_flag)
        $display("PASSED: The underflow flag has been set !!");
    else
        $display("==> FAILED: The underflow flag is not working !!");
    $display(" ");

    #10;
    // --- SPECIAL CASE: NaN (Not a Number) ---
    $display(" ");
    $display("*** Checking NaN (Infinity - Infinity) ***");
    i_add_sub = 1'b1;
    i_32_a = 32'b0_11111111_00000000000000000000000; // +Inf
    i_32_b = 32'b0_11111111_00000000000000000000000; // +Inf

    #10;
    if(o_nan_flag)
        $display("PASSED: The NaN flag has been set !!");
    else
        $display("==> FAILED: The NaN flag is not working !!");
    $display(" ");

#80000;
$finish;
end

endmodule