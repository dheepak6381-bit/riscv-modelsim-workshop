`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: d_flip_flop_tb (SystemVerilog)
// Author:    Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module d_flip_flop_tb;

    logic clk;
    logic reset;
    logic d;
    logic q;
    logic q_bar;

    d_flip_flop uut (
        .clk   (clk),
        .reset (reset),
        .d     (d),
        .q     (q),
        .q_bar (q_bar)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 1'b0;
        reset = 1'b1;
        d     = 1'b0;

        $display("==============================================");
        $display("   D FLIP-FLOP SYSTEMVERILOG SIMULATION       ");
        $display("   Author: Dheepak (github.com/dheepak6381-bit)");
        $display("==============================================");

        $monitor("Time=%0t | clk=%b | reset=%b | d=%b | q=%b | q_bar=%b",
                 $time, clk, reset, d, q, q_bar);

        #12; reset = 1'b0; // De-assert reset
        #10; d = 1'b1;
        #10; d = 1'b0;
        #10; d = 1'b1;
        #10; reset = 1'b1; // Test asynchronous reset assertion
        #10; reset = 1'b0;
        #15;

        $display("==============================================");
        $display("          SIMULATION COMPLETED                ");
        $display("==============================================");
        $finish;
    end

endmodule

