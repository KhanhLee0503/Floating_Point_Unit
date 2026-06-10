module LZC_2BIT(
  input logic  [1:0] I_DATA,
  output logic [1:0] O_CNT,
  output logic       O_ALL_ZERO 
);

assign O_ALL_ZERO = ~(I_DATA[1] | I_DATA[0]);
assign O_CNT[1]   = O_ALL_ZERO; 
assign O_CNT[0]   = ~I_DATA[1] & I_DATA[0];

endmodule: LZC_2BIT