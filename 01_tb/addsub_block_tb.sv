`timescale 1ns/1ns
module addsub_block_tb();
reg [23:0] a_in;
reg [23:0] b_in;
reg sel;

wire [23:0] sum;
wire c_out;

integer i;

addsub_block DUT(.*);

initial begin
    a_in = 24'h0;
    b_in = 24'h0;
    sel = 1'b0;

    $display("---------------------Adding Random Numbers------------------");
    for(i=0; i<=10; i=i+1) begin
        #10;
        a_in = $random();
        b_in = $random();
        #10;
        $display("[%d] - Adding %h + %h !!!", i, a_in, b_in);
        if(sum == a_in + b_in)
            $display("PASSED: The result is %h", sum);
        else
            $display("==> FAILED: The result is %h | Expected : %h", sum, a_in + b_in);
    end


    $display(" ");
    $display("---------------------Subtracting Random Numbers------------------");
    sel = 1'b1;
    for(i=0; i<=10; i=i+1) begin
        #10;
        a_in = $random();
        b_in = $random();
        #10;
        $display("[%d] - Subtracting %h - %h !!!", i, a_in, b_in);
        if(sum == a_in - b_in)
            $display("PASSED: The result is %h", sum);
        else
            $display("==> FAILED: The result is %h | Expected : %h", sum, a_in - b_in);
    end
    
#5000;
end



endmodule