`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu_32bit (SystemVerilog)
// Description: 32-bit ALU for RV32I Processor using SystemVerilog
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module alu_32bit (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  alu_op_e     alu_ctrl,
    output logic [31:0] result,
    output logic        zero
);

    always_comb begin
        case (alu_ctrl)
            ALU_ADD:  result = a + b;
            ALU_SUB:  result = a - b;
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_SLL:  result = a << b[4:0];
            ALU_SRL:  result = a >> b[4:0];
            ALU_SRA:  result = $signed(a) >>> b[4:0];
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            ALU_SLTU: result = (a < b) ? 32'd1 : 32'd0;
            ALU_LUI:  result = b;
            default:  result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule

