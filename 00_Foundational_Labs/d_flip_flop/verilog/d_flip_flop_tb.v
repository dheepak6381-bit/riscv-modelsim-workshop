`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: d_flip_flop_tb (Verilog HDL)
// Author:    Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module d_flip_flop_tb;

    reg clk;
    reg reset;
    reg d;
    wire q;
    wire q_bar;

    d_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        d = 0;

        $display("==============================================");
        $display("      D FLIP-FLOP VERILOG SIMULATION          ");
        $display("      Author: Dheepak (github.com/dheepak6381-bit)");
        $display("==============================================");

        $monitor("Time=%0t | clk=%b | reset=%b | d=%b | q=%b | q_bar=%b",
                 $time, clk, reset, d, q, q_bar);

        #12; reset = 0; // Release reset
        #10; d = 1;
        #10; d = 0;
        #10; d = 1;
        #10; reset = 1; // Assert async reset
        #10; reset = 0;
        #15;

        $display("==============================================");
        $display("          SIMULATION COMPLETED                ");
        $display("==============================================");
        $finish;
    end

endmodule

