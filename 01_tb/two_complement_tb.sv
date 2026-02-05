`timescale  1ns/1ns
module two_complement_tb();
reg [7:0] data_in;
wire [7:0] data_out;

two_complement DUT (.*);

initial begin
    data_in = 8'h0;
    #10;
    $display("-----------Testing Operations--------------");
    data_in = 8'heb;
    $display("Data input is: %h", data_in);
    #10;
    $display("==> Complemented Result: %h", data_out);

    #10;
    data_in = 8'h5a;
    $display("Data input is: %h", data_in);
    #10;
    $display("==> Complemented Result: %h", data_out);


    #10;
    data_in = 8'h12;
    $display("Data input is: %h", data_in);
    #10;
    $display("==> Complemented Result: %h", data_out);

#100;
$finish;
end

endmodule 