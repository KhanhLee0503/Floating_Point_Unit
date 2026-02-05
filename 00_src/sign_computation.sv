module sign_computation(
    input wire ex_a_gt_b,
    input wire [7:0] ex_diff,
    input wire mantissa_a_gt_b,

    input wire i_add_sub,

    input wire sign_a,
    input wire sign_b,

    output reg sign_out
);
wire ex_equal;

assign ex_equal = (ex_diff == 0);  

always@(*) begin
    if(sign_a == sign_b)
        sign_out = sign_a;
    else begin
        if(ex_equal) begin
            if (mantissa_a_gt_b)
                sign_out = sign_a;
            else 
                sign_out = sign_b;
        end
        else if(ex_a_gt_b)
            sign_out = sign_a;
        else
            sign_out = sign_b;
    end
end
endmodule