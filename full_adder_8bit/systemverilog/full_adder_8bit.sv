`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: full_adder_8bit (SystemVerilog)
// Description: 8-Bit Ripple Carry Adder built from 1-Bit Full Adders
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module full_adder_1bit (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);

    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule


module full_adder_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic       Cin,
    output logic [7:0] Sum,
    output logic       Cout
);

    logic [8:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_fa
            full_adder_1bit fa_inst (
                .a    (A[i]),
                .b    (B[i]),
                .cin  (carry[i]),
                .sum  (Sum[i]),
                .cout (carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[8];

endmodule

