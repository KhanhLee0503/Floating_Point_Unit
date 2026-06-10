module CLA_4BIT(
    input logic [3:0]  I_A,
    input logic [3:0]  I_B,
    input logic        I_CARRY_IN,

    output logic [3:0] O_SUM,
    output logic       O_P_OUT,
    output logic       O_G_OUT
);

logic [3:0] P;
logic [3:0] G;
logic [4:0] carry;

assign P = I_A ^ I_B;
assign G = I_A & I_B;

assign carry[0] = I_CARRY_IN;
assign carry[1] = G[0] | (P[0] & carry[0]);
assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & carry[0]);
//assign carry[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry[0]);

assign O_SUM   = P ^ carry[3:0];
    //O_CARRY_OUT = carry[4];
assign O_P_OUT = &P;
assign O_G_OUT = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule : CLA_4BIT