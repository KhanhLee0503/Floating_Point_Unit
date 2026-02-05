module CLA_4bit(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire carry_in,

    output reg [3:0] sum,
    //output reg carry_out,
    output reg P_Out,
    output reg G_Out
);

wire [3:0] P;
wire [3:0] G;
wire [4:0] carry;

assign P = a^b;
assign G = a&b;

assign carry[0] = carry_in;
assign carry[1] = G[0] | (P[0] & carry[0]);
assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & carry[0]);
assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & carry[0]);
//assign carry[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & carry[0]);

always@(*) begin
    sum = P ^ carry[3:0];
    //carry_out = carry[4];
    P_Out = &P;
    G_Out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
end


endmodule