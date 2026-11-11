`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: imm_gen (SystemVerilog)
// Description: Immediate Generator for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module imm_gen (
    input  logic [31:0] instr,
    output logic [31:0] imm_out
);

    logic [6:0] opcode;
    assign opcode = instr[6:0];

    always_comb begin
        case (opcode)
            OPC_I_TYPE,
            OPC_LOAD,
            OPC_JALR: begin
                imm_out = {{20{instr[31]}}, instr[31:20]};
            end

            OPC_STORE: begin
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            OPC_BRANCH: begin
                imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end

            OPC_LUI,
            OPC_AUIPC: begin
                imm_out = {instr[31:12], 12'b0};
            end

            OPC_JAL: begin
                imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            end

            default: begin
                imm_out = 32'd0;
            end
        endcase
    end

endmodule

