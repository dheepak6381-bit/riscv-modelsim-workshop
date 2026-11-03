`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: instruction_memory (SystemVerilog)
// Description: ROM initialized with RV32I instructions via $readmemh
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory #(
    parameter int MEM_DEPTH = 256,
    parameter string INIT_HEX = "program.hex"
)(
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] rom [0:MEM_DEPTH-1];

    initial begin
        for (int i = 0; i < MEM_DEPTH; i++) begin
            rom[i] = 32'h00000013; // Default to NOP (addi x0, x0, 0)
        end
        $readmemh(INIT_HEX, rom);
    end

    // Word-aligned addressing: addr[31:2]
    assign instr = (addr[31:2] < MEM_DEPTH) ? rom[addr[31:2]] : 32'h00000013;

endmodule

