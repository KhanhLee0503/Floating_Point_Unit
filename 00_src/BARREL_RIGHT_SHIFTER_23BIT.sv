module BARREL_RIGHT_SHIFTER_23BIT(
    input logic  [22:0] I_DATA_IN,
    input logic  [4:0]  I_SHIFT_AMOUNT,

    output logic [22:0] O_DATA_OUT
);

logic [22:0] P0;
logic [22:0] P1;
logic [22:0] P2;
logic [22:0] P3;

assign P3         = (I_SHIFT_AMOUNT[4]) ? {16'b0,I_DATA_IN[22:16]} : I_DATA_IN;
assign P2         = (I_SHIFT_AMOUNT[3]) ? {8'b0,P3[22:8]} : P3;
assign P1         = (I_SHIFT_AMOUNT[2]) ? {4'b0,P2[22:4]} : P2;
assign P0         = (I_SHIFT_AMOUNT[1]) ? {2'b0,P1[22:2]} : P1;
assign O_DATA_OUT = (I_SHIFT_AMOUNT[0]) ? {1'b0,P0[22:1]} : P0;

endmodule : BARREL_RIGHT_SHIFTER_23BIT