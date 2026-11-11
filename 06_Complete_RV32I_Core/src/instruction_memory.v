`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: instruction_memory
// Description: ROM / Instruction Memory for RV32I Processor.
//              32-bit wide memory pre-initialized via $readmemh.
//              Word-aligned addressing (addr[9:2] accesses 256 words).
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory #(
    parameter MEM_DEPTH = 256,
    parameter INIT_HEX  = "program.hex"
)(
    input  wire [31:0] addr,
    output wire [31:0] instr
);

    reg [31:0] rom [0:MEM_DEPTH-1];
    integer i;

    initial begin
        // Initialize with NOPs (addi x0, x0, 0 = 0x00000013)
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            rom[i] = 32'h00000013;
        end
        // Attempt to load hex file
        $readmemh(INIT_HEX, rom);
    end

    // Word-aligned read: addr[9:2]
    assign instr = (addr[31:2] < MEM_DEPTH) ? rom[addr[31:2]] : 32'h00000013;

endmodule
