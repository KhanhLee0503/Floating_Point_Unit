module ADDSUB_BLOCK(
    input logic [23:0]  I_A_IN,
    input logic [23:0]  I_B_IN,

    input logic         I_SEL,         //0 - ADD | 1 - SUB

    output logic [23:0] O_SUM,
    output logic        O_C_OUT
);

logic [23:0] b_internal;
logic [3:0] P_internal;
logic [3:0] G_internal;
logic [3:0] c_internal;

LCU LCU_16bit(
    .I_P_GROUP(P_internal),
    .I_G_GROUP(G_internal),
    .I_C_IN(I_SEL),

    .O_C_INTERNAL(c_internal[2:0]),
    .O_C_OUT(c_internal[3])
);

CLA_4BIT CLA_1(
    .I_A(I_A_IN[3:0]),
    .I_B(b_internal[3:0]),
    .I_CARRY_IN(I_SEL),

    .O_SUM(O_SUM[3:0]),
    
    .O_P_OUT(P_internal[0]),
    .O_G_OUT(G_internal[0])
);

CLA_4BIT CLA_2(
    .I_A(I_A_IN[7:4]),
    .I_B(b_internal[7:4]),
    .I_CARRY_IN(c_internal[0]),

    .O_SUM(O_SUM[7:4]),
    
    .O_P_OUT(P_internal[1]),
    .O_G_OUT(G_internal[1])
);

CLA_4BIT CLA_3(
    .I_A(I_A_IN[11:8]),
    .I_B(b_internal[11:8]),
    .I_CARRY_IN(c_internal[1]),

    .O_SUM(O_SUM[11:8]),
    
    .O_P_OUT(P_internal[2]),
    .O_G_OUT(G_internal[2])
);

CLA_4BIT CLA_4(
    .I_A(I_A_IN[15:12]),
    .I_B(b_internal[15:12]),
    .I_CARRY_IN(c_internal[2]),

    .O_SUM(O_SUM[15:12]),
    
    .O_P_OUT(P_internal[3]),
    .O_G_OUT(G_internal[3])
);

RPA RPA_8bit(
    .I_A_IN(I_A_IN[23:16]),
    .I_B_IN(b_internal[23:16]),
    .I_C_IN(c_internal[3]),

    .O_SUM(O_SUM[23:16]),
    .O_C_OUT(O_C_OUT)
);

assign b_internal = I_B_IN ^ {24{I_SEL}};

endmodule : ADDSUB_BLOCK


//------------------------------LCU Sub Module------------------------------------------
module LCU(
    input logic [3:0]  I_P_GROUP,
    input logic [3:0]  I_G_GROUP,
    input logic        I_C_IN,

    output logic [2:0] O_C_INTERNAL,
    output logic       O_C_OUT
);

always_comb begin
    O_C_INTERNAL[0] = I_G_GROUP[0] | (I_P_GROUP[0] & I_C_IN);
    O_C_INTERNAL[1] = I_G_GROUP[1] | (I_P_GROUP[1] & I_G_GROUP[0]) | (I_P_GROUP[1] & I_P_GROUP[0] & I_C_IN);
    O_C_INTERNAL[2] = I_G_GROUP[2] | (I_P_GROUP[2] & I_G_GROUP[1]) | (I_P_GROUP[2] & I_P_GROUP[1] & I_G_GROUP[0]) | (I_P_GROUP[2] & I_P_GROUP[1] & I_P_GROUP[0] & I_C_IN);
    O_C_OUT         = I_G_GROUP[3] | (I_P_GROUP[3] & I_G_GROUP[2]) | (I_P_GROUP[3] & I_P_GROUP[2] & I_G_GROUP[1]) | (I_P_GROUP[3] & I_P_GROUP[2] & I_P_GROUP[1] & I_G_GROUP[0]) | (I_P_GROUP[3] & I_P_GROUP[2] & I_P_GROUP[1] & I_P_GROUP[0] & I_C_IN);
end 

endmodule : LCU