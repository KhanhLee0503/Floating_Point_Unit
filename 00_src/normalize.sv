module normalize (
    input wire [7:0] exponent_in,
    input wire [24:0] mantissa_in,
    output reg [23:0] normalized_out,
    output reg [7:0] exponent_out
);

reg [4:0] shift_amt;
wire [4:0] shift_amt_wire;
reg [23:0] shiftR_out;
reg [23:0] shiftL_out;

always@(*) begin
    if(mantissa_in[22])
        shift_amt = 5'd1;
    else if(mantissa_in[21])
        shift_amt = 5'd2;
    else if(mantissa_in[20])
        shift_amt = 5'd3;
    else if(mantissa_in[19])
        shift_amt = 5'd4;
    else if(mantissa_in[18])
        shift_amt = 5'd5;
    else if(mantissa_in[17])
        shift_amt = 5'd6;
    else if(mantissa_in[16])
        shift_amt = 5'd7;
    else if(mantissa_in[15])
        shift_amt = 5'd8;
    else if(mantissa_in[14])
        shift_amt = 5'd9;
    else if(mantissa_in[13])
        shift_amt = 5'd10;
    else if(mantissa_in[12])
        shift_amt = 5'd11;
    else if(mantissa_in[11])
        shift_amt = 5'd12;
    else if(mantissa_in[10])
        shift_amt = 5'd13;
    else if(mantissa_in[9])
        shift_amt = 5'd14;
    else if(mantissa_in[8])
        shift_amt = 5'd15;
    else if(mantissa_in[7])
        shift_amt = 5'd16;
    else if(mantissa_in[6])
        shift_amt = 5'd17;
    else if(mantissa_in[5])
        shift_amt = 5'd18;
    else if(mantissa_in[4])
        shift_amt = 5'd19;
    else if(mantissa_in[3])
        shift_amt = 5'd20;
    else if(mantissa_in[2])
        shift_amt = 5'd21;
    else if(mantissa_in[1])
        shift_amt = 5'd22;
    else 
        shift_amt = 5'd23;
end

assign shift_amt_wire = shift_amt;

Barrel_Shifter_Left normalize_shifter(
    .data_in(mantissa_in[23:0]),
    .shift_amount(shift_amt_wire),

    .data_out(shiftL_out)
);

always @(*) begin
    if(mantissa_in[24])
        shiftR_out = mantissa_in[24:1];
    else 
        shiftR_out = normalized_out;
end

always @(*) begin
    case({mantissa_in[24],mantissa_in[23]})
        2'b00: normalized_out = shiftL_out;
        2'b01: normalized_out = mantissa_in[23:0];
        2'b10: normalized_out = shiftR_out; 
        2'b11: normalized_out = shiftR_out; 
        default: normalized_out = mantissa_in[23:0];
    endcase
end

always@(*) begin
    if(mantissa_in[24])
    exponent_out = exponent_in + shift_amt;   
    case({mantissa_in[24],mantissa_in[23]})
        2'b00: exponent_out     = (exponent_in - {3'b000,shift_amt});
        2'b01: exponent_out     = exponent_in;
        2'b10: exponent_out     = exponent_in + 7'h1; 
        2'b11: exponent_out     = exponent_in + 7'h1; 
        default: exponent_out   = exponent_in;
    endcase
end

endmodule




module Barrel_Shifter_Left(
    input wire [23:0] data_in,
    input wire [4:0] shift_amount,

    output wire [23:0] data_out
);

wire [23:0] P0;
wire [23:0] P1;
wire [23:0] P2;
wire [23:0] P3;

assign P3       = (shift_amount[4]) ? {data_in[7:0],16'b0} : data_in;
assign P2       = (shift_amount[3]) ? {P3[15:0],8'b0} : P3;
assign P1       = (shift_amount[2]) ? {P2[19:0],4'b0} : P2;
assign P0       = (shift_amount[1]) ? {P1[21:0],2'b0} : P1;
assign data_out = (shift_amount[0]) ? {P0[22:0],1'b0} : P0;

endmodule