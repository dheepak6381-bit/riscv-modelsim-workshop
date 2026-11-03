`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu_control
// Description: ALU Control Unit for RV32I Processor
//              Decodes alu_op, funct3, and funct7 to drive alu_ctrl.
//////////////////////////////////////////////////////////////////////////////////

module alu_control (
    input  wire [1:0] alu_op,       // 2-bit ALUOp from Main Control Unit
    input  wire [2:0] funct3,       // funct3 field from instruction [14:12]
    input  wire [6:0] funct7,       // funct7 field from instruction [31:25]
    input  wire       is_i_type,    // Flag indicating I-type arithmetic instruction
    output reg  [3:0] alu_ctrl      // 4-bit control code to ALU
);

    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLL  = 4'b0101;
    localparam ALU_SRL  = 4'b0110;
    localparam ALU_SRA  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    localparam ALU_LUI  = 4'b1010;

    always @(*) begin
        case (alu_op)
            2'b00: begin
                // Loads, Stores, AUIPC, JAL, JALR: Always perform ADD
                alu_ctrl = ALU_ADD;
            end

            2'b01: begin
                // Branches: Compare operands using SUB or branch condition
                case (funct3)
                    3'b000, 3'b001: alu_ctrl = ALU_SUB;  // BEQ, BNE
                    3'b100, 3'b101: alu_ctrl = ALU_SLT;  // BLT, BGE (signed)
                    3'b110, 3'b111: alu_ctrl = ALU_SLTU; // BLTU, BGEU (unsigned)
                    default:        alu_ctrl = ALU_SUB;
                endcase
            end

            2'b10: begin
                // R-type or I-type arithmetic / logical
                case (funct3)
                    3'b000: begin
                        // For R-type: funct7[5] selects between ADD (0) and SUB (1)
                        // For I-type (ADDI): Always ADD
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
                        // SRA (funct7[5] = 1) vs SRL (funct7[5] = 0)
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
                // LUI: Pass immediate
                alu_ctrl = ALU_LUI;
            end

            default: alu_ctrl = ALU_ADD;
        endcase
    end

endmodule
