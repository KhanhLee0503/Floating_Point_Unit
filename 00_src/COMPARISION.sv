module COMPARISION #( parameter DATA_WIDTH = 8 )
(
    input logic [DATA_WIDTH-1:0]  I_A_IN,
    input logic [DATA_WIDTH-1:0]  I_B_IN,

    output logic [DATA_WIDTH-1:0] O_SUM,
    output logic                  O_C_OUT
);

logic [DATA_WIDTH:0] carry;
logic [DATA_WIDTH-1:0] b_inverted;

assign b_inverted = ~I_B_IN;

genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i = i + 1) begin : gen_fa
        FA FullAdder(
            .I_A_IN(I_A_IN[i]),
            .I_B_IN(b_inverted[i]),
            .I_C_IN(carry[i]),

            .O_SUM(O_SUM[i]),
            .O_C_OUT(carry[i+1])
        );
    end
endgenerate

assign O_C_OUT = carry[DATA_WIDTH] & ~(O_SUM == 0);
assign carry[0] = 1'b1;

endmodule : COMPARISION
