`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: register_file (SystemVerilog)
// Description: 32 x 32-bit Register File for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module register_file (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        reg_write,
    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,
    input  logic [31:0] wdata,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);

    logic [31:0] registers [31:0];

    // Asynchronous reads (x0 hardwired to zero)
    assign rdata1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign rdata2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

    // Synchronous write with active-low reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 32; i++) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= wdata;
        end
    end

endmodule

