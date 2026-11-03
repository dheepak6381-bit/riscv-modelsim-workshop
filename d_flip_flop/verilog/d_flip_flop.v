`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: d_flip_flop (Verilog HDL)
// Description: Positive-Edge Triggered D Flip-Flop with Active-High Async Reset
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module d_flip_flop (
    input  wire clk,
    input  wire reset,
    input  wire d,
    output reg  q,
    output wire q_bar
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

    assign q_bar = ~q;

endmodule

