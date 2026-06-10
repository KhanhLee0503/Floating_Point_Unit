module NORMALIZE(
    input logic [27:0] I_DATA_IN,
    input logic [7:0]  I_EXPONENT,
    output logic [26:0] O_MANTISSA,
    output logic [7:0]  O_EXPONENT
);

logic [4:0]  w_leading_zero_count;
logic [31:0] w_barrel_shifter_data;
logic [26:0] w_data_out;

LZC_27BIT leading_zero_counter(
    .I_DATA_IN(I_DATA_IN[26:0]),
    .O_CNT(w_leading_zero_count),
    .O_ALL_ZERO()
);

BARREL_LEFT_SHIFTER_32BIT barrel_shifter(
   .I_DATA_IN({5'h0, I_DATA_IN[26:0]}), 
   .I_SHIFT_AMOUNT(w_leading_zero_count),
   .O_DATA_OUT(w_barrel_shifter_data)
);

assign w_data_out = { I_DATA_IN[27:2], (I_DATA_IN[1] | I_DATA_IN[0]) };

assign O_EXPONENT = I_DATA_IN[27] ? (I_EXPONENT + 1) : (I_EXPONENT - {3'h0, w_leading_zero_count});
assign O_MANTISSA = I_DATA_IN[27] ? w_data_out : w_barrel_shifter_data[26:0];

endmodule: NORMALIZE