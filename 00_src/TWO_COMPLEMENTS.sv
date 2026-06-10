module TWO_COMPLEMENTS #(parameter DATA_WIDTH = 8)
(
    input logic  [DATA_WIDTH-1:0] I_DATA_IN,
    output logic [DATA_WIDTH-1:0] O_DATA_OUT
);

assign O_DATA_OUT = ~I_DATA_IN + 1;

endmodule : TWO_COMPLEMENTS