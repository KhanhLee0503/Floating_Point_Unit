`timescale 1ns/1ns
module fpu_top_tb();
reg [31:0] i_32_a;  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  
reg [31:0] i_32_b;  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  

reg  i_add_sub;
    
wire [31:0] o_32_s;
wire o_ov_flag;
wire o_un_flag;

fpu_top DUT (.*);

shortreal a_real;
shortreal  b_real;
reg [31:0] expected_bits;
shortreal expected_real;
integer i;

reg [6:0] fail_num;

initial begin
    i_32_a = 32'b0; 
    i_32_b = 32'b0; 
    i_add_sub = 1'b0;
    fail_num = 7'b0; 
/*    
    #10;
    $display(" ");
    $display("-----------------ITEM1: Adding 2 floating point numbers (28 + 3.75) !!--------------");
    $display("A: (28) 11100");
    $display("B: (3.75) 11.11");
    i_32_a = 32'b0_10000011_11000000000000000000000;
    i_32_b = 32'b0_10000000_11100000000000000000000;
    i_add_sub = 1'b0;
    #10;
    if(o_32_s == 32'b0_10000011_11111100000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 0_10000011_11111100000000000000000", o_32_s);

    
    #10;
    $display(" ");
    $display("-----------------ITEM2: Adding 2 floating point numbers (15 + 9.125) !!--------------");
    $display("A: (15) 1111");
    $display("B: (9.125) 1001.001");
    i_32_a = 32'b0_10000010_11100000000000000000000;
    i_32_b = 32'b0_10000010_00100100000000000000000;
    i_add_sub = 1'b0;
    #10;
    if(o_32_s == 32'b0_10000011_10000010000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 0_10000011_10000010000000000000000", o_32_s);   #10;


    $display(" ");
    $display("-----------------ITEM3: Adding 2 floating point numbers (13) + (-0.0625) !!--------------");
    $display("A: (13) 1101");
    $display("B: (-0.0625) -0.0001");
    i_32_a = 32'b0_10000010_10100000000000000000000;
    i_32_b = 32'b1_01111011_00000000000000000000000;
    i_add_sub = 1'b0;
    #10;
    if(o_32_s == 32'b0_10000010_10011110000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 0_10000010_10011110000000000000000", o_32_s);


    $display(" ");
    $display("-----------------ITEM4: Adding 2 floating point numbers (-10.125) + (5.25) !!--------------");
    $display("A: (-10.125) -1010.001");
    $display("B: (5.25) 101.01");
    i_32_a = 32'b1_10000010_01000100000000000000000;
    i_32_b = 32'b0_10000001_01010000000000000000000;
    i_add_sub = 1'b0;
    #10;
    if(o_32_s == 32'b1_10000001_00111000000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 1_10000001_0011100000000000000000", o_32_s);


        
    $display(" ");
    $display("-----------------ITEM5: Subtracting 2 floating point numbers (0.75) - (11.125) !!--------------");
    $display("A: (0.75) 0.11");
    $display("B: (11.125) 1011.001");
    i_32_a = 32'b0_01111110_10000000000000000000000;
    i_32_b = 32'b0_10000010_01100100000000000000000;
    i_add_sub = 1'b1;
    #10;
    if(o_32_s == 32'b1_10000010_01001100000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 1 10000010 01001100000000000000000", o_32_s);


    $display(" ");
    $display("-----------------ITEM6: Subtracting 2 floating point numbers (-8.875) - (-25.25) !!--------------");
    $display("A: (-8.875) -1000.111");
    $display("B: (-25.25) -11001.01");
    i_32_a = 32'b1_10000010_00011100000000000000000;
    i_32_b = 32'b1_10000011_10010100000000000000000;
    i_add_sub = 1'b1;
    #10;
    if(o_32_s == 32'b0_10000011_00000110000000000000000)
        $display("PASSED: Adding Successfully | result: %b", o_32_s);
    else
        $display("==> FAILED: Adding Failed | result: %b | expected: 0_10000011_00000110000000000000000", o_32_s);
*/
    
    $display(" ");
    $display("################## Testing random 100 generated input combinations (ADDING) ####################");

    i_add_sub = 1'b0; // Test phép cộng

    for(i=0; i<100; i=i+1) begin
        $display(" ");
        // Tạo số thực ngẫu nhiên chuẩn hơn
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
            
            // Kiểm tra logic cờ Overflow (Ví dụ đơn giản)
            if (expected_bits[30:23] == 8'hFF && o_ov_flag !== 1'b1)
                $display("[%t ns] WARNING: Overflow occurred but o_ov_flag is NOT set!", $time);
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
    i_add_sub = 1'b1; // Test subtraction 

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

        // So sánh kết quả và kiểm tra các cờ đặc biệt
        if((o_32_s - expected_bits == 1) ||  (o_32_s - expected_bits == -1) || (o_32_s == expected_bits)) begin
            $display("[%t ns] PASSED: Result = %h", $time, o_32_s);
            
            // Kiểm tra logic cờ Overflow (Ví dụ đơn giản)
            if (expected_bits[30:23] == 8'hFF && o_ov_flag !== 1'b1)
                $display("[%t ns] WARNING: Overflow occurred but o_ov_flag is NOT set!", $time);
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
    $display("*** Adding Infinity(A) to a random number(B) ***");
    i_add_sub = 1'b0;
    i_32_a = 32'b0_11111111_00000000000000000000000;
    i_32_b = 32'b0_10000010_01100100000000000000000;

    #10;
    if(o_ov_flag)
        $display("PASSED: The overflow flag has been set !!"); 
    else
        $display("==> FAILED: The overflow flag is not working !!");


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


    #10; 
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


#80000;
$finish;
end

endmodule