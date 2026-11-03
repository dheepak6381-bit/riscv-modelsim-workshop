`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: full_adder_8bit_tb (SystemVerilog)
// Author:    Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module full_adder_8bit_tb;

    logic [7:0] A, B;
    logic Cin;
    logic [7:0] Sum;
    logic Cout;

    full_adder_8bit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        $display("==============================================");
        $display("   8-BIT FULL ADDER SYSTEMVERILOG SIMULATION  ");
        $display("   Author: Dheepak (github.com/dheepak6381-bit)");
        $display("==============================================");

        $monitor("Time=%0t | A=%d | B=%d | Cin=%b | Sum=%d | Cout=%b",
                 $time, A, B, Cin, Sum, Cout);

        // Test 1: 10 + 20 + 0 = 30
        A = 8'd10; B = 8'd20; Cin = 1'b0; #10;

        // Test 2: 100 + 50 + 0 = 150
        A = 8'd100; B = 8'd50; Cin = 1'b0; #10;

        // Test 3: 255 + 1 + 0 = 0 (carry = 1)
        A = 8'd255; B = 8'd1; Cin = 1'b0; #10;

        // Test 4: 255 + 255 + 1 = 255 (carry = 1)
        A = 8'd255; B = 8'd255; Cin = 1'b1; #10;

        // Test 5: 128 + 127 + 1 = 0 (carry = 1)
        A = 8'd128; B = 8'd127; Cin = 1'b1; #10;

        // Test 6: 50 + 25 + 1 = 76
        A = 8'd50; B = 8'd25; Cin = 1'b1; #10;

        $display("==============================================");
        $display("          SIMULATION COMPLETED                ");
        $display("==============================================");
        $finish;
    end

endmodule

