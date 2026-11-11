`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: program_counter
// Description: 32-bit Program Counter Register for RV32I Processor.
//              Synchronous register with active-low reset.
//////////////////////////////////////////////////////////////////////////////////

module program_counter (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] pc_next,
    output reg  [31:0] pc
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc <= 32'h00000000;
        else
            pc <= pc_next;
    end

endmodule
