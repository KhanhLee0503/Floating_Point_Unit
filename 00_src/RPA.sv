module RPA #( parameter DATA_WIDTH = 8 )
(
    input logic [DATA_WIDTH-1:0] I_A_IN,
    input logic [DATA_WIDTH-1:0] I_B_IN,
    input logic                  I_C_IN,

    output logic [DATA_WIDTH-1:0] O_SUM,
    output logic                  O_C_OUT
);

logic [DATA_WIDTH:0] carry;

genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i = i + 1) begin : gen_fa
        FA FullAdder(
            .I_A_IN(I_A_IN[i]),
            .I_B_IN(I_B_IN[i]),
            .I_C_IN(carry[i]),

            .O_SUM(O_SUM[i]),
            .O_C_OUT(carry[i+1])
        );
    end
endgenerate

assign O_C_OUT = carry[DATA_WIDTH];
assign carry[0] = I_C_IN;

endmodule : RPA


//------------------------------Full Adder Sub Modules------------------------------------------
module FA(
    input logic  I_A_IN,
    input logic  I_B_IN,
    input logic  I_C_IN,

    output logic O_SUM,
    output logic O_C_OUT
);

assign O_SUM = I_A_IN ^ I_B_IN ^ I_C_IN;
assign O_C_OUT = ((I_A_IN ^ I_B_IN) & I_C_IN) | (I_A_IN & I_B_IN);

endmodule : FA