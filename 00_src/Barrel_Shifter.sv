module Barrel_Shifter(
    input wire [22:0] data_in,
    input wire [4:0] shift_amount,

    output wire [22:0] data_out
);

wire [22:0] P0;
wire [22:0] P1;
wire [22:0] P2;
wire [22:0] P3;

assign P3       = (shift_amount[4]) ? {16'b0,data_in[22:16]} : data_in;
assign P2       = (shift_amount[3]) ? {8'b0,P3[22:8]} : P3;
assign P1       = (shift_amount[2]) ? {4'b0,P2[22:4]} : P2;
assign P0       = (shift_amount[1]) ? {2'b0,P1[22:2]} : P1;
assign data_out = (shift_amount[0]) ? {1'b0,P0[22:1]} : P0;

endmodule