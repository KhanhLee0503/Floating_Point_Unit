module addsub_block(
    input wire [23:0] a_in,
    input wire [23:0] b_in,

    input wire sel,         //0 - ADD | 1 - SUB

    output wire [23:0] sum,
    output wire c_out
);

wire [23:0] b_internal;
wire [3:0] P_internal;
wire [3:0] G_internal;
wire [3:0] c_internal;


assign b_internal = b_in ^ {24{sel}};



LCU LCU_16bit(
    .P_Group(P_internal),
    .G_Group(G_internal),
    .c_in(sel),

    .c_internal(c_internal[2:0]),
    .c_out(c_internal[3])
);

CLA_4bit CLA_1(
    .a(a_in[3:0]),
    .b(b_internal[3:0]),
    .carry_in(sel),

    .sum(sum[3:0]),
    
    .P_Out(P_internal[0]),
    .G_Out(G_internal[0])
);

CLA_4bit CLA_2(
    .a(a_in[7:4]),
    .b(b_internal[7:4]),
    .carry_in(c_internal[0]),

    .sum(sum[7:4]),
    
    .P_Out(P_internal[1]),
    .G_Out(G_internal[1])
);

CLA_4bit CLA_3(
    .a(a_in[11:8]),
    .b(b_internal[11:8]),
    .carry_in(c_internal[1]),

    .sum(sum[11:8]),
    
    .P_Out(P_internal[2]),
    .G_Out(G_internal[2])
);

CLA_4bit CLA_4(
    .a(a_in[15:12]),
    .b(b_internal[15:12]),
    .carry_in(c_internal[2]),

    .sum(sum[15:12]),
    
    .P_Out(P_internal[3]),
    .G_Out(G_internal[3])
);

RPA RPA_8bit (
    .a_in(a_in[23:16]),
    .b_in(b_internal[23:16]),
    .c_in(c_internal[3]),

    .sum(sum[23:16]),
    .c_out(c_out)
);

endmodule


module LCU(
    input wire [3:0] P_Group,
    input wire [3:0] G_Group,
    input wire c_in,

    output reg [2:0] c_internal,
    output reg c_out
);

always@(*) begin
    c_internal[0]   = G_Group[0] | (P_Group[0] & c_in);
    c_internal[1]   = G_Group[1] | (P_Group[1] & G_Group[0]) | (P_Group[1] & P_Group[0] & c_in);
    c_internal[2]   = G_Group[2] | (P_Group[2] & G_Group[1]) | (P_Group[2] & P_Group[1] & G_Group[0]) | (P_Group[2] & P_Group[1] & P_Group[0] & c_in);
    c_out           = G_Group[3] | (P_Group[3] & G_Group[2]) | (P_Group[3] & P_Group[2] & G_Group[1]) | (P_Group[3] & P_Group[2] & P_Group[1] & G_Group[0]) | (P_Group[3] & P_Group[2] & P_Group[1] & P_Group[0] & c_in);
end 

endmodule