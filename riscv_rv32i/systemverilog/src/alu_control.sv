`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu_control (SystemVerilog)
// Description: ALU Control Unit for RV32I Processor
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module alu_control (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic       is_i_type,
    output alu_op_e    alu_ctrl
);

    always_comb begin
        case (alu_op)
            2'b00: begin
                // Loads, Stores, AUIPC, JAL, JALR
                alu_ctrl = ALU_ADD;
            end

            2'b01: begin
                // Branches
                case (funct3)
                    3'b000, 3'b001: alu_ctrl = ALU_SUB;
                    3'b100, 3'b101: alu_ctrl = ALU_SLT;
                    3'b110, 3'b111: alu_ctrl = ALU_SLTU;
                    default:        alu_ctrl = ALU_SUB;
                endcase
            end

            2'b10: begin
                // R-type or I-type arithmetic / logical
                case (funct3)
                    3'b000: begin
                        if (!is_i_type && funct7[5])
                            alu_ctrl = ALU_SUB;
                        else
                            alu_ctrl = ALU_ADD;
                    end
                    3'b001: alu_ctrl = ALU_SLL;
                    3'b010: alu_ctrl = ALU_SLT;
                    3'b011: alu_ctrl = ALU_SLTU;
                    3'b100: alu_ctrl = ALU_XOR;
                    3'b101: begin
                        if (funct7[5])
                            alu_ctrl = ALU_SRA;
                        else
                            alu_ctrl = ALU_SRL;
                    end
                    3'b110: alu_ctrl = ALU_OR;
                    3'b111: alu_ctrl = ALU_AND;
                    default: alu_ctrl = ALU_ADD;
                endcase
            end

            2'b11: begin
                // LUI
                alu_ctrl = ALU_LUI;
            end

            default: alu_ctrl = ALU_ADD;
        endcase
    end

endmodule

