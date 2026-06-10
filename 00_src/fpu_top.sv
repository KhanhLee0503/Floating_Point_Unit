module FPU_TOP(
    input logic  [31:0]  I_FP_DATA_A,
    input logic  [31:0]  I_FP_DATA_B,
    input logic          I_ADD_SUB, // 1: Subtraction, 0: Addition
    output logic         O_FP_SIGN,
    output logic [30:23] O_FP_EXPONENT,
    output logic [22:0]  O_FP_MANTISSA,
    output logic         O_FP_ZERO,
    output logic         O_FP_INFINITY,
    output logic         O_FP_SUBNORMAL,
    output logic         O_FP_NOT_A_NUMBER
);

//====================================
//              SIGNALS
//====================================
//** Mantissa Comparison
    logic        w_mantissa_a_gt_b;
    logic        w_mantissa_a_eq_b;
    logic [22:0] w_mantissa_difference;
//** Exponent
    logic        w_exponent_a_gt_b;
    logic        w_exponent_a_eq_b;
    logic [7:0]  w_exponent_difference_sub;
    logic [7:0]  w_exponent_difference;
//** First Branch
    logic [23:0] w_in_roundgen_1;
    logic [26:0] w_roundgen_two_complements_1;
    logic [28:0] w_two_complements_1_adder;
    logic [28:0] w_adder_in_a;
    logic [28:0] w_mux_adder_in_a_1;
    logic [28:0] w_mux_adder_in_a_2;
//** Second Branch 
    logic [23:0] w_in_roundgen_2;
    logic [26:0] w_roundgen_two_complements_2;
    logic [28:0] w_two_complements_2_adder;
    logic [47:0] w_shifter_roundgen_2;
    logic [28:0] w_adder_in_b;
    logic [28:0] w_mux_adder_in_b_1;
    logic [28:0] w_mux_adder_in_b_2;
//** Normalization
    logic [27:0] w_adder_normalize;
    logic [28:0] w_adder_normalize_sub;
    logic [28:0] w_adder_normalize_sub_n;
    logic [7:0]  w_exponent_normalize_sub;
//** Roundup
    logic [26:0] w_normalized_roundup;
    logic        w_exponent_adjust_roundup;

//====================================
//          SIGN COMPUTATION 
//====================================
SIGN_COMPUTATION sign_computation_inst
(
    .I_ADD_SUB     ( I_ADD_SUB),
    .I_SIGN_A      ( I_FP_DATA_A[31]),
    .I_SIGN_B      ( I_FP_DATA_B[31]),
    .I_EXPONENT_GT ( w_exponent_a_gt_b),
    .I_EXPONENT_EQ ( w_exponent_a_eq_b),
    .I_MANTISSA_GT ( w_mantissa_a_gt_b),
    .I_MANTISSA_EQ ( w_mantissa_a_eq_b),
    .O_SIGN_OUT    ( O_FP_SIGN)
);

//====================================
//              EXPONENT
//====================================
COMPARISION #(.DATA_WIDTH(8)) rpa_exponent_comparator
(
    .I_A_IN  ( I_FP_DATA_A[30:23]),
    .I_B_IN  ( I_FP_DATA_B[30:23]),
    .O_SUM   ( w_exponent_difference_sub),
    .O_C_OUT ( w_exponent_a_gt_b)
);

assign w_exponent_a_eq_b     = (w_exponent_difference_sub == 8'b0);
assign w_exponent_difference = w_exponent_a_gt_b ? w_exponent_difference_sub : ~w_exponent_difference_sub + 1;

//====================================
//              MANTISSA
//====================================
//** Mantissa Comparision
COMPARISION #(.DATA_WIDTH(23)) rpa_mantissa_comparator
(
    .I_A_IN  ( I_FP_DATA_A[22:0]),
    .I_B_IN  ( I_FP_DATA_B[22:0]),
    .O_SUM   ( w_mantissa_difference),
    .O_C_OUT ( w_mantissa_a_gt_b)
);
assign w_mantissa_a_eq_b = (w_mantissa_difference == 23'b0);

//** First Branch
assign w_in_roundgen_1 = w_exponent_a_gt_b ? {1'b1,I_FP_DATA_A[22:0]} : {1'b1,I_FP_DATA_B[22:0]};

ROUND_GEN round_gen_1(
    .I_MANTISSA ( {w_in_roundgen_1, 24'b0}),
    .O_MANTISSA ( w_roundgen_two_complements_1)
);

TWO_COMPLEMENTS #(.DATA_WIDTH(29)) two_complements_1
(
    .I_DATA_IN  ( {2'b00, w_roundgen_two_complements_1}),
    .O_DATA_OUT ( w_two_complements_1_adder)
);

//** Second Branch
assign w_in_roundgen_2 = w_exponent_a_gt_b ? {1'b1,I_FP_DATA_B[22:0]} : {1'b1,I_FP_DATA_A[22:0]};

BARREL_RIGHT_SHIFTER_48BIT barrel_right_shifter_48bit(
    .I_DATA     ( {w_in_roundgen_2, 24'b0}),
    .I_SHAMT    ( w_exponent_difference[5:0]),
    .I_SHIFT_IN ( 1'b0),
    .O_DATA     ( w_shifter_roundgen_2)
);

ROUND_GEN round_gen_2(
    .I_MANTISSA ( w_shifter_roundgen_2),
    .O_MANTISSA ( w_roundgen_two_complements_2)
);

TWO_COMPLEMENTS #(.DATA_WIDTH(29)) two_complements_2
(
    .I_DATA_IN  ( {2'b00, w_roundgen_two_complements_2}),
    .O_DATA_OUT ( w_two_complements_2_adder)
);

//**Adder Input
assign w_mux_adder_in_a_1 = (I_FP_DATA_A[31]) ? (w_two_complements_1_adder) : ({2'b00, w_roundgen_two_complements_1});
assign w_mux_adder_in_a_2 = (I_FP_DATA_B[31] ^ I_ADD_SUB) ? (w_two_complements_1_adder) : ({2'b00, w_roundgen_two_complements_1});
assign w_adder_in_a       = w_exponent_a_gt_b ? w_mux_adder_in_a_1 : w_mux_adder_in_a_2;

assign w_mux_adder_in_b_2 = (I_FP_DATA_A[31]) ? (w_two_complements_2_adder) : ({2'b00, w_roundgen_two_complements_2});
assign w_mux_adder_in_b_1 = (I_FP_DATA_B[31] ^ I_ADD_SUB) ? (w_two_complements_2_adder) : ({2'b00, w_roundgen_two_complements_2});
assign w_adder_in_b       = w_exponent_a_gt_b ? w_mux_adder_in_b_1 : w_mux_adder_in_b_2;

RPA #(.DATA_WIDTH(29)) rpa_adder
(
    .I_A_IN  ( w_adder_in_a),
    .I_B_IN  ( w_adder_in_b),
    .I_C_IN  ( 1'b0),
    .O_SUM   ( w_adder_normalize_sub),
    .O_C_OUT ( )
);

assign w_adder_normalize_sub_n = ~w_adder_normalize_sub + 1;
assign w_adder_normalize       = w_adder_normalize_sub[28] ? w_adder_normalize_sub_n[27:0] : w_adder_normalize_sub[27:0];

//====================================
//     NORMALIZATION AND ROUNDING   
//===================================
NORMALIZE normalize(
    .I_DATA_IN  ( w_adder_normalize),
    .I_EXPONENT ( w_exponent_a_gt_b ? I_FP_DATA_A[30:23] : I_FP_DATA_B[30:23]),
    .O_MANTISSA ( w_normalized_roundup),
    .O_EXPONENT ( w_exponent_normalize_sub)
);

ROUND_UP round_up(
    .I_MANTISSA ( w_normalized_roundup),
    .O_MANTISSA ( O_FP_MANTISSA),
    .O_EXP_ADJUST ( w_exponent_adjust_roundup )
);

//====================================
//        CORNER CASE CHECKING 
//====================================
CORNER_CASE_CHECK corner_case_check(
    .I_ADD_SUB      ( I_ADD_SUB),
    .I_SIGN_A       ( I_FP_DATA_A[31]),
    .I_SIGN_B       ( I_FP_DATA_B[31]),
    .I_PRE_A_EXPONENT ( I_FP_DATA_A[30:23]),
    .I_PRE_B_EXPONENT ( I_FP_DATA_B[30:23]),
    .I_PRE_A_MANTISSA ( I_FP_DATA_A[22:0]),
    .I_PRE_B_MANTISSA ( I_FP_DATA_B[22:0]),
    .I_MANTISSA     ( O_FP_MANTISSA),
    .I_EXPONENT     ( O_FP_EXPONENT),
    .O_ZERO         ( O_FP_ZERO),
    .O_SUBNORMAL    ( O_FP_SUBNORMAL),
    .O_INFINITY     ( O_FP_INFINITY),
    .O_NOT_A_NUMBER ( O_FP_NOT_A_NUMBER)
);

assign O_FP_EXPONENT = w_exponent_normalize_sub + w_exponent_adjust_roundup;

endmodule: FPU_TOP