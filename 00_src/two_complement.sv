module two_complement #(parameter DATA_WIDTH = 8)
(
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out
);

wire [DATA_WIDTH-1:0] data_in_pre;
wire [DATA_WIDTH-1:0] carry;

assign data_in_pre = ~(data_in);

assign carry[0] = data_in_pre[0];

genvar i;
generate
    for(i=1; i<DATA_WIDTH; i=i+1) begin
        assign data_out[i] = data_in_pre[i] ^ carry[i-1];
        assign carry[i] = data_in_pre[i] & carry[i-1];
    end
endgenerate

always @(*) begin
    data_out[0] = ~data_in_pre[0];
end

endmodule