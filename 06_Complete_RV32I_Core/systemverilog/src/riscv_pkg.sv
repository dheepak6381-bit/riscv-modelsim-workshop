`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Package Name: riscv_pkg (SystemVerilog)
// Description:  Type definitions, enums, and constants for RV32I Processor
// Author:       Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

package riscv_pkg;

    // RV32I Standard 7-Bit Opcodes
    typedef enum logic [6:0] {
        OPC_R_TYPE = 7'b0110011, // Register-Register ALU
        OPC_I_TYPE = 7'b0010011, // Register-Immediate ALU
        OPC_LOAD   = 7'b0000011, // Load Word (LW)
        OPC_STORE  = 7'b0100011, // Store Word (SW)
        OPC_BRANCH = 7'b1100011, // Branch (BEQ, BNE, BLT, BGE, BLTU, BGEU)
        OPC_JAL    = 7'b1101111, // Jump and Link
        OPC_JALR   = 7'b1100111, // Jump and Link Register
        OPC_LUI    = 7'b0110111, // Load Upper Immediate
        OPC_AUIPC  = 7'b0010111  // Add Upper Immediate to PC
    } rv32i_opcode_e;

    // ALU Operation Codes
    typedef enum logic [3:0] {
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_AND  = 4'b0010,
        ALU_OR   = 4'b0011,
        ALU_XOR  = 4'b0100,
        ALU_SLL  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_SLT  = 4'b1000,
        ALU_SLTU = 4'b1001,
        ALU_LUI  = 4'b1010
    } alu_op_e;

    // Branch Condition Funct3
    typedef enum logic [2:0] {
        BR_BEQ  = 3'b000,
        BR_BNE  = 3'b001,
        BR_BLT  = 3'b100,
        BR_BGE  = 3'b101,
        BR_BLTU = 3'b110,
        BR_BGEU = 3'b111
    } branch_funct3_e;

endpackage : riscv_pkg

