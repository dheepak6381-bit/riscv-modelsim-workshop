`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: program_counter (SystemVerilog)
// Description: 32-bit Program Counter Register for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module program_counter (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] pc_next,
    output logic [31:0] pc
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc <= 32'h00000000;
        else
            pc <= pc_next;
    end

endmodule

