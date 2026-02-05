module fpu_top(
    input wire [31:0] i_32_a,  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  
    input wire [31:0] i_32_b,  //bit 31: sign | bit 30 -> Bit 23: Exponent | Bit 22 -> Bit 0: Mantissa  

    input wire i_add_sub,
    
    output wire [31:0] o_32_s,

    output reg o_ov_flag,
    output reg o_un_flag 
);

//****Adder Signals***
reg [25:0] adder_in1;
wire [25:0] adder_in1_pre;

reg [25:0] adder_in2;
wire [23:0] adder_in2_shifted;
wire [22:0] adder_in2_pre1;
wire [25:0] adder_in2_pre2;

wire [25:0] adder_in1_complemented;
wire [25:0] adder_in2_complemented;

wire [25:0] adder_IN1;
wire [25:0] adder_IN2;


//***Exponent Difference Signals***
wire [7:0] ex_b_inverted; 
wire [7:0] difference_pre1;
wire [7:0] difference_pre2;
wire [7:0] difference;
wire a_gt_b;

//***Mantissa Comparator Signals***
wire mantissa_a_gt_b;

//***Normalize Module Signals***
wire [25:0] mantissa_out_pre;
wire [25:0] mantissa_out_complemented;
wire [23:0] mantissa_out;
wire [7:0] exponent_normalize;

//-----------------------------Internal Connections-----------------------------------

assign ex_b_inverted = ~i_32_b[30:23];

RPA Exponent_Difference(
    .a_in(i_32_a[30:23]),
    .b_in(ex_b_inverted),
    .c_in(1'b1),

    .sum(difference_pre1),
    .c_out(a_gt_b)
);
   
two_complement two_complement(
    .data_in(difference_pre1),
    .data_out(difference_pre2)
);
 
assign difference = (a_gt_b) ? difference_pre1 : difference_pre2;

Barrel_Shifter Right_Shifter( 
    .data_in({1'b1,adder_in2_pre1}),
    .shift_amount(difference[4:0]),

    .data_out(adder_in2_shifted)
);

assign adder_in2_pre1 = (a_gt_b) ? i_32_b[22:0] : i_32_a[22:0];
assign adder_in2_pre2 = {2'b0,adder_in2_shifted};
assign adder_in1_pre = (a_gt_b) ? {3'b001,i_32_a[22:0]} : {3'b001,i_32_b[22:0]};

two_complement #(.DATA_WIDTH(26)) two_complement_adder_in1(
    .data_in(adder_in1_pre),
    .data_out(adder_in1_complemented)
);

two_complement #(.DATA_WIDTH(26)) two_complement_adder_in2(
    .data_in(adder_in2_pre2),
    .data_out(adder_in2_complemented)
);

always@(*) begin
    if(a_gt_b) begin
        if(i_32_b[31] ^ i_add_sub)
            adder_in2 = adder_in2_complemented; 

        else
            adder_in2 = adder_in2_pre2;
    end 
    else begin
        if(i_32_a[31])
            adder_in2 = adder_in2_complemented; 
        else
            adder_in2 = adder_in2_pre2;
    end
end


always@(*) begin
    if(a_gt_b) begin
        if(i_32_a[31])
            adder_in1 = adder_in1_complemented; 
        else
            adder_in1 = adder_in1_pre;
    end 
    else begin
        if(i_32_b[31] ^ i_add_sub)
            adder_in1 = adder_in1_complemented; 
        else
            adder_in1 = adder_in1_pre;
    end
end

assign adder_IN1 = adder_in1;
assign adder_IN2 = adder_in2;

addsub_block ADDER( 
    .a_in({adder_IN1}),
    .b_in({adder_IN2}),

    .sel(1'b0),         //0 - ADD | 1 - SUB

    .sum(mantissa_out_pre),
    .c_out()
);


assign mantissa_out_complemented = (mantissa_out_pre[25]) ? ~(mantissa_out_pre) + 25'h1 : mantissa_out_pre;


addsub_block #(.DATA_WIDTH(23)) Mantissa_Compare(
    .a_in(i_32_a[22:0]),
    .b_in(i_32_b[22:0]),

    .sel(1'b1),         //0 - ADD | 1 - SUB
    .sum(),
    .c_out(mantissa_a_gt_b)
);

sign_computation sign_computation(
    .ex_a_gt_b(a_gt_b),
    .ex_diff(difference),
    .mantissa_a_gt_b(mantissa_a_gt_b),

    .i_add_sub(i_add_sub),

    .sign_a(i_32_a[31]),
    .sign_b(i_32_b[31] ^ i_add_sub),

    .sign_out(o_32_s[31])
);


assign exponent_normalize = (a_gt_b) ? i_32_a[30:23] : i_32_b[30:23];
   

normalize Normalize(
    .exponent_in(exponent_normalize),
    .mantissa_in(mantissa_out_complemented[24:0]),
    .normalized_out(mantissa_out),
    .exponent_out(o_32_s[30:23])
);

assign o_32_s[22:0] = mantissa_out[22:0];

always@(*) begin
    o_ov_flag = (o_32_s[30:23] == 8'b1111_1111);
end

always @(*) begin
    o_un_flag = (o_32_s[30:23] == 8'b0000_0000);
end

endmodule