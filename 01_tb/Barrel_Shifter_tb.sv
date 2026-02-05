module Barrel_Shifter_tb();
reg [22:0] data_in;
reg [4:0] shift_amount;

wire [22:0] data_out;
integer i;

Barrel_Shifter DUT(.*);

initial begin
    data_in      = 23'h0;
    shift_amount = 5'h0;
    

    $display("---------------------Shifting Random Numbers------------------");
    for(i=0; i<=10; i=i+1) begin
        #10;
        data_in = $random();
        shift_amount = $random();
        #10;
        $display("[%d] - Shifting %h by %d !!!", i, data_in, shift_amount);
        if(data_out == (data_in >> shift_amount))
            $display("PASSED: The result is %h", data_out);
        else
            $display("==> FAILED: The result is %h | Expected : %h", data_out, data_in >> shift_amount);
    end

end

endmodule