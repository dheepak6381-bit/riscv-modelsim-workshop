`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: control_unit
// Description: Main Control Unit for RV32I Processor
//              Decodes the 7-bit opcode to generate datapath control signals.
//////////////////////////////////////////////////////////////////////////////////

module control_unit (
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg  [1:0] mem_to_reg,  // 00: ALU result, 01: Mem data, 10: PC + 4
    output reg        branch,
    output reg        jump,
    output reg        jalr,
    output reg  [1:0] alu_op,
    output reg        is_i_type
);

    // Standard RISC-V 7-bit Opcodes
    localparam OPC_R_TYPE  = 7'b0110011; // ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
    localparam OPC_I_TYPE  = 7'b0010011; // ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU
    localparam OPC_LOAD    = 7'b0000011; // LW
    localparam OPC_STORE   = 7'b0100011; // SW
    localparam OPC_BRANCH  = 7'b1100011; // BEQ, BNE, BLT, BGE, BLTU, BGEU
    localparam OPC_JAL     = 7'b1101111; // JAL
    localparam OPC_JALR    = 7'b1100111; // JALR
    localparam OPC_LUI     = 7'b0110111; // LUI
    localparam OPC_AUIPC   = 7'b0010111; // AUIPC

    always @(*) begin
        // Default values to prevent latches
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
                reg_write  = 1'b1;
                alu_src    = 1'b0; // Operand B is rs2
                alu_op     = 2'b10;
            end

            OPC_I_TYPE: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1; // Operand B is immediate
                alu_op     = 2'b10;
                is_i_type  = 1'b1;
            end

            OPC_LOAD: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1; // Address = rs1 + offset
                mem_read   = 1'b1;
                mem_to_reg = 2'b01; // Data from memory
                alu_op     = 2'b00; // ADD
            end

            OPC_STORE: begin
                alu_src    = 1'b1; // Address = rs1 + offset
                mem_write  = 1'b1;
                alu_op     = 2'b00; // ADD
            end

            OPC_BRANCH: begin
                branch     = 1'b1;
                alu_src    = 1'b0; // Compare rs1 and rs2
                alu_op     = 2'b01; // Branch compare
            end

            OPC_JAL: begin
                reg_write  = 1'b1; // Save return address (PC+4) in rd
                jump       = 1'b1;
                mem_to_reg = 2'b10; // PC + 4 to register
            end

            OPC_JALR: begin
                reg_write  = 1'b1; // Save return address (PC+4) in rd
                jump       = 1'b1;
                jalr       = 1'b1;
                alu_src    = 1'b1; // Base + offset
                mem_to_reg = 2'b10; // PC + 4 to register
                alu_op     = 2'b00; // ADD
            end

            OPC_LUI: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1; // Pass immediate
                alu_op     = 2'b11; // LUI direct
            end

            OPC_AUIPC: begin
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                alu_op     = 2'b00; // PC + imm
            end

            default: begin
                // No-op / safe state
            end
        endcase
    end

endmodule
