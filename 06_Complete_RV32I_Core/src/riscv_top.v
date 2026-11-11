`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: riscv_top
// Description: Top-Level RV32I Single-Cycle Processor
//              Integrates PC, Instruction Memory, Register File, Imm Gen,
//              ALU, Control Unit, and Data Memory.
//////////////////////////////////////////////////////////////////////////////////

module riscv_top #(
    parameter INIT_HEX  = "program.hex",
    parameter IMEM_DEPTH = 256,
    parameter DMEM_DEPTH = 256
)(
    input  wire        clk,
    input  wire        rst_n,

    // Debug / Monitoring outputs for ModelSim inspection
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr,
    output wire [31:0] debug_alu_result,
    output wire [31:0] debug_reg_wdata,
    output wire        debug_reg_write,
    output wire        debug_mem_write
);

    // =========================================================================
    // Internal Wires & Buses
    // =========================================================================
    wire [31:0] pc;
    reg  [31:0] pc_next;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire [31:0] jalr_target;

    wire [31:0] instr;
    wire [6:0]  opcode   = instr[6:0];
    wire [4:0]  rd       = instr[11:7];
    wire [2:0]  funct3   = instr[14:12];
    wire [4:0]  rs1      = instr[19:15];
    wire [4:0]  rs2      = instr[24:20];
    wire [6:0]  funct7   = instr[31:25];

    // Control signals
    wire        reg_write;
    wire        alu_src;
    wire        mem_read;
    wire        mem_write;
    wire [1:0]  mem_to_reg;
    wire        branch;
    wire        jump;
    wire        jalr;
    wire [1:0]  alu_op;
    wire        is_i_type;
    wire [3:0]  alu_ctrl;

    // Datapath signals
    wire [31:0] imm_val;
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    wire [31:0] alu_in1;
    wire [31:0] alu_in2;
    wire [31:0] alu_result;
    wire        alu_zero;
    wire [31:0] mem_rdata;
    reg  [31:0] reg_wdata;

    // Branch condition evaluation
    reg         take_branch;

    // =========================================================================
    // Program Counter Logic
    // =========================================================================
    assign pc_plus_4     = pc + 32'd4;
    assign branch_target = pc + imm_val;
    assign jalr_target   = (reg_rdata1 + imm_val) & ~32'd1;

    always @(*) begin
        case (funct3)
            3'b000: take_branch = alu_zero;                                      // BEQ
            3'b001: take_branch = ~alu_zero;                                     // BNE
            3'b100: take_branch = ($signed(reg_rdata1) < $signed(reg_rdata2));   // BLT
            3'b101: take_branch = ($signed(reg_rdata1) >= $signed(reg_rdata2));  // BGE
            3'b110: take_branch = (reg_rdata1 < reg_rdata2);                     // BLTU
            3'b111: take_branch = (reg_rdata1 >= reg_rdata2);                    // BGEU
            default: take_branch = 1'b0;
        endcase
    end

    // Next PC selection
    always @(*) begin
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
    // Main Control Unit & ALU Control Unit
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
    // ALU Multiplexers & Core
    // =========================================================================
    // AUIPC uses PC as operand A; all other instructions use rs1
    assign alu_in1 = (opcode == 7'b0010111) ? pc : reg_rdata1;
    // ALUSrc selects between rs2 and immediate
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
    always @(*) begin
        case (mem_to_reg)
            2'b00:   reg_wdata = alu_result;
            2'b01:   reg_wdata = mem_rdata;
            2'b10:   reg_wdata = pc_plus_4;
            default: reg_wdata = alu_result;
        endcase
    end

    // =========================================================================
    // Debug Output Assignments
    // =========================================================================
    assign debug_pc         = pc;
    assign debug_instr      = instr;
    assign debug_alu_result = alu_result;
    assign debug_reg_wdata  = reg_wdata;
    assign debug_reg_write  = reg_write;
    assign debug_mem_write  = mem_write;

endmodule
