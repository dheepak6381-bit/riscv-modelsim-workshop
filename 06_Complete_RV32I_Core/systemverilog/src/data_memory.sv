`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: data_memory (SystemVerilog)
// Description: Synchronous RAM Data Memory for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module data_memory #(
    parameter int MEM_DEPTH = 256
)(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
);

    logic [31:0] ram [0:MEM_DEPTH-1];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < MEM_DEPTH; i++) begin
                ram[i] <= 32'd0;
            end
        end else if (mem_write && (addr[31:2] < MEM_DEPTH)) begin
            ram[addr[31:2]] <= wdata;
        end
    end

    assign rdata = (mem_read && (addr[31:2] < MEM_DEPTH)) ? ram[addr[31:2]] : 32'd0;

endmodule

