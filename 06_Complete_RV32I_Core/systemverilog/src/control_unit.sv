`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: control_unit (SystemVerilog)
// Description: Main Control Unit for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic [1:0] mem_to_reg,
    output logic       branch,
    output logic       jump,
    output logic       jalr,
    output logic [1:0] alu_op,
    output logic       is_i_type
);

    always_comb begin
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 2'b00;
        branch     = 1'b0;
        jump       = 1'b0;
        jalr       = 1'b0;
        alu_op     = 2'b00;
        is_i_type  = 1'b0;

        case (opcode)
            OPC_R_TYPE: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 2'b10;
            end

            OPC_I_TYPE: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
                is_i_type = 1'b1;
            end

            OPC_LOAD: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 2'b01;
                alu_op     = 2'b00;
            end

            OPC_STORE: begin
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00;
            end

            OPC_BRANCH: begin
                branch = 1'b1;
                alu_src = 1'b0;
                alu_op  = 2'b01;
            end

            OPC_JAL: begin
                reg_write  = 1'b1;
                jump       = 1'b1;
                mem_to_reg = 2'b10;
            end

            OPC_JALR: begin
                reg_write  = 1'b1;
                jump       = 1'b1;
                jalr       = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 2'b10;
                alu_op     = 2'b00;
            end

            OPC_LUI: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b11;
            end

            OPC_AUIPC: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end

            default: begin
                // No-operation
            end
        endcase
    end

endmodule

