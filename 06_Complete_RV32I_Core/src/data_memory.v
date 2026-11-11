`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: data_memory
// Description: RAM / Data Memory for RV32I Processor.
//              Synchronous write, asynchronous read.
//              Provides 256 words (1 KB) with address mapping.
//////////////////////////////////////////////////////////////////////////////////

module data_memory #(
    parameter MEM_DEPTH = 256
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    reg [31:0] ram [0:MEM_DEPTH-1];
    integer i;

    // Synchronous write & asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1) begin
                ram[i] <= 32'd0;
            end
        end else if (mem_write && (addr[31:2] < MEM_DEPTH)) begin
            ram[addr[31:2]] <= wdata;
        end
    end

    // Asynchronous read
    assign rdata = (mem_read && (addr[31:2] < MEM_DEPTH)) ? ram[addr[31:2]] : 32'd0;

endmodule
