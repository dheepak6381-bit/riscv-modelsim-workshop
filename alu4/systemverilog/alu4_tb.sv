`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: alu4_tb (SystemVerilog)
// Author:    Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module alu4_tb;

    logic [3:0] A;
    logic [3:0] B;
    logic [2:0] opcode;
    logic [3:0] result;
    logic       carry_borrow;
    logic       zero;

    alu4 uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry_borrow(carry_borrow),
        .zero(zero)
    );

    initial begin
        $display("==============================================");
        $display("     4-BIT ALU SYSTEMVERILOG SIMULATION       ");
        $display("     Author: Dheepak (github.com/dheepak6381-bit)");
        $display("==============================================");

        $monitor("Time=%0t | A=%b (%0d) | B=%b (%0d) | OP=%b | RES=%b (%0d) | C/B=%b | ZERO=%b",
                 $time, A, A, B, B, opcode, result, result, carry_borrow, zero);

        // ADD: 5 + 3 = 8
        A = 4'd5; B = 4'd3; opcode = 3'b000; #20;

        // ADD with carry: 15 + 1 = 0 (carry=1)
        A = 4'd15; B = 4'd1; opcode = 3'b000; #20;

        // SUB: 5 - 3 = 2
        A = 4'd5; B = 4'd3; opcode = 3'b001; #20;

        // SUB with borrow: 3 - 5 = 14 (borrow=1)
        A = 4'd3; B = 4'd5; opcode = 3'b001; #20;

        // AND: 5 & 3 = 1
        A = 4'd5; B = 4'd3; opcode = 3'b010; #20;

        // OR: 5 | 3 = 7
        A = 4'd5; B = 4'd3; opcode = 3'b011; #20;

        // XOR: 5 ^ 3 = 6
        A = 4'd5; B = 4'd3; opcode = 3'b100; #20;

        // SUB Zero: 5 - 5 = 0 (zero=1)
        A = 4'd5; B = 4'd5; opcode = 3'b001; #20;

        $display("==============================================");
        $display("          SIMULATION COMPLETED                ");
        $display("==============================================");
        $finish;
    end

endmodule

