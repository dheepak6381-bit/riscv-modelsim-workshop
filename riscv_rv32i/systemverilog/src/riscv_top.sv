`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: riscv_top (SystemVerilog)
// Description: Top-Level RV32I Processor in SystemVerilog
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module riscv_top #(
    parameter string INIT_HEX    = "program.hex",
    parameter int    IMEM_DEPTH  = 256,
    parameter int    DMEM_DEPTH  = 256
)(
    input  logic        clk,
    input  logic        rst_n,

    // Debug / Monitoring outputs for ModelSim Waveform inspection
    output logic [31:0] debug_pc,
    output logic [31:0] debug_instr,
    output logic [31:0] debug_alu_result,
    output logic [31:0] debug_reg_wdata,
    output logic        debug_reg_write,
    output logic        debug_mem_write
);

    // =========================================================================
    // Internal Signals
    // =========================================================================
    logic [31:0] pc;
    logic [31:0] pc_next;
    logic [31:0] pc_plus_4;
    logic [31:0] branch_target;
    logic [31:0] jalr_target;

    logic [31:0] instr;
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [6:0]  funct7;

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // Control Signals
    logic        reg_write;
    logic        alu_src;
    logic        mem_read;
    logic        mem_write;
    logic [1:0]  mem_to_reg;
    logic        branch;
    logic        jump;
    logic        jalr;
    logic [1:0]  alu_op;
    logic        is_i_type;
    alu_op_e     alu_ctrl;

    // Datapath Signals
    logic [31:0] imm_val;
    logic [31:0] reg_rdata1;
    logic [31:0] reg_rdata2;
    logic [31:0] alu_in1;
    logic [31:0] alu_in2;
    logic [31:0] alu_result;
    logic        alu_zero;
    logic [31:0] mem_rdata;
    logic [31:0] reg_wdata;
    logic        take_branch;

    // =========================================================================
    // Program Counter Logic
    // =========================================================================
    assign pc_plus_4     = pc + 32'd4;
    assign branch_target = pc + imm_val;
    assign jalr_target   = (reg_rdata1 + imm_val) & ~32'd1;

    always_comb begin
        case (funct3)
            BR_BEQ:  take_branch = alu_zero;
            BR_BNE:  take_branch = ~alu_zero;
            BR_BLT:  take_branch = ($signed(reg_rdata1) < $signed(reg_rdata2));
            BR_BGE:  take_branch = ($signed(reg_rdata1) >= $signed(reg_rdata2));
            BR_BLTU: take_branch = (reg_rdata1 < reg_rdata2);
            BR_BGEU: take_branch = (reg_rdata1 >= reg_rdata2);
            default: take_branch = 1'b0;
        endcase
    end

    always_comb begin
        if (jalr)
            pc_next = jalr_target;
        else if (jump || (branch && take_branch))
            pc_next = branch_target;
        else
            pc_next = pc_plus_4;
    end

    program_counter u_pc (
        .clk     (clk),
        .rst_n   (rst_n),
        .pc_next (pc_next),
        .pc      (pc)
    );

    // =========================================================================
    // Instruction Memory
    // =========================================================================
    instruction_memory #(
        .MEM_DEPTH (IMEM_DEPTH),
        .INIT_HEX  (INIT_HEX)
    ) u_imem (
        .addr  (pc),
        .instr (instr)
    );

    // =========================================================================
    // Control Units
    // =========================================================================
    control_unit u_control (
        .opcode     (opcode),
        .reg_write  (reg_write),
        .alu_src    (alu_src),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .mem_to_reg (mem_to_reg),
        .branch     (branch),
        .jump       (jump),
        .jalr       (jalr),
        .alu_op     (alu_op),
        .is_i_type  (is_i_type)
    );

    alu_control u_alu_control (
        .alu_op    (alu_op),
        .funct3    (funct3),
        .funct7    (funct7),
        .is_i_type (is_i_type),
        .alu_ctrl  (alu_ctrl)
    );

    // =========================================================================
    // Register File
    // =========================================================================
    register_file u_regfile (
        .clk       (clk),
        .rst_n     (rst_n),
        .reg_write (reg_write),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (rd),
        .wdata     (reg_wdata),
        .rdata1    (reg_rdata1),
        .rdata2    (reg_rdata2)
    );

    // =========================================================================
    // Immediate Generator
    // =========================================================================
    imm_gen u_imm_gen (
        .instr   (instr),
        .imm_out (imm_val)
    );

    // =========================================================================
    // ALU
    // =========================================================================
    assign alu_in1 = (opcode == OPC_AUIPC) ? pc : reg_rdata1;
    assign alu_in2 = alu_src ? imm_val : reg_rdata2;

    alu_32bit u_alu (
        .a        (alu_in1),
        .b        (alu_in2),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // =========================================================================
    // Data Memory
    // =========================================================================
    data_memory #(
        .MEM_DEPTH (DMEM_DEPTH)
    ) u_dmem (
        .clk       (clk),
        .rst_n     (rst_n),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .addr      (alu_result),
        .wdata     (reg_rdata2),
        .rdata     (mem_rdata)
    );

    // =========================================================================
    // Write-Back Multiplexer
    // =========================================================================
    always_comb begin
        case (mem_to_reg)
            2'b00:   reg_wdata = alu_result;
            2'b01:   reg_wdata = mem_rdata;
            2'b10:   reg_wdata = pc_plus_4;
            default: reg_wdata = alu_result;
        endcase
    end

    // =========================================================================
    // Debug Outputs
    // =========================================================================
    assign debug_pc         = pc;
    assign debug_instr      = instr;
    assign debug_alu_result = alu_result;
    assign debug_reg_wdata  = reg_wdata;
    assign debug_reg_write  = reg_write;
    assign debug_mem_write  = mem_write;

endmodule

