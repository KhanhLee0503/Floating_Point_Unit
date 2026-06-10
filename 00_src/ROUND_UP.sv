module ROUND_UP(
  input logic  [26:0] I_MANTISSA,   // 27-bit mantissa (24 bit + Guard, Round, Sticky)
  output logic [22:0] O_MANTISSA,   // 23-bit mantissa (Fraction) ngõ ra cuối cùng
  output logic        O_EXP_ADJUST  // Cờ báo tràn, cần nối để cộng 1 vào Exponent ở ngoài
);

logic        round_up;
logic [24:0] w_rounded_mantissa; // Cần 25 bit để chứa cả bit tràn carry-out nếu có

// 1. Công thức làm tròn chuẩn IEEE 754 (Round to Nearest, Ties to Even)
// Guard = bit 2, Round = bit 1, Sticky = bit 0, LSB = bit 3
assign round_up = I_MANTISSA[2] & (I_MANTISSA[1] | I_MANTISSA[0] | I_MANTISSA[3]);

// 2. Thực hiện cộng trên toàn bộ 24 bit nguyên bản (chèn thêm bit 0 ở đầu để hứng carry)
assign w_rounded_mantissa = {1'b0, I_MANTISSA[26:3]} + round_up;

// 3. Kiểm tra tràn: Nếu bit thứ 24 (MSB của w_rounded_mantissa) bằng 1 
// nghĩa là phép làm tròn làm tràn số (ví dụ 1.111 + 1 = 10.000)
assign O_EXP_ADJUST = w_rounded_mantissa[24];

// 4. Trả về đúng 23 bit fraction cho ngõ ra
assign O_MANTISSA = w_rounded_mantissa[22:0];

endmodule: ROUND_UP