module ROUND_GEN(
    input logic [47:0]  I_MANTISSA,  // 48-bit mantissa (bao gồm bit 24 bit cuối là bit ẩn)
    output logic [26:0] O_MANTISSA // 27-bit mantissa sau khi làm tròn (24 bit + 3 bit guard, round, sticky
);

assign O_MANTISSA[0] = |I_MANTISSA[21:0];   //Sticky Bit: OR tất cả bit thấp hơn bit Round
assign O_MANTISSA[1] = I_MANTISSA[22];      //Round Bit
assign O_MANTISSA[2] = I_MANTISSA[23];      //Guard Bit
assign O_MANTISSA[26:3] = I_MANTISSA[47:24];

endmodule : ROUND_GEN