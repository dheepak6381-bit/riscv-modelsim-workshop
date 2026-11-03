`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: imm_gen
// Description: Immediate Generator for RV32I Processor
//              Decodes sign-extended immediates for I, S, B, U, and J instruction formats.
//////////////////////////////////////////////////////////////////////////////////

module imm_gen (
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];

    localparam OPC_I_TYPE1 = 7'b0010011; // ADDI, SLTI, etc.
    localparam OPC_LOAD    = 7'b0000011; // LW
    localparam OPC_JALR    = 7'b1100111; // JALR
    localparam OPC_STORE   = 7'b0100011; // SW
    localparam OPC_BRANCH  = 7'b1100011; // BEQ, BNE, etc.
    localparam OPC_LUI     = 7'b0110111; // LUI
    localparam OPC_AUIPC   = 7'b0010111; // AUIPC
    localparam OPC_JAL     = 7'b1101111; // JAL

    always @(*) begin
        case (opcode)
            // I-Type Immediates
            OPC_I_TYPE1,
            OPC_LOAD,
            OPC_JALR: begin
                imm_out = {{20{instr[31]}}, instr[31:20]};
            end

            // S-Type Immediate (Store)
            OPC_STORE: begin
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end

            // B-Type Immediate (Branch)
            OPC_BRANCH: begin
                imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end

            // U-Type Immediate (LUI, AUIPC)
            OPC_LUI,
            OPC_AUIPC: begin
                imm_out = {instr[31:12], 12'b0};
            end

            // J-Type Immediate (JAL)
            OPC_JAL: begin
                imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            end

            default: begin
                imm_out = 32'd0;
            end
        endcase
    end

endmodule
