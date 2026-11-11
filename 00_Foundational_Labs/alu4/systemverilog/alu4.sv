`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu4 (SystemVerilog)
// Description: 4-bit Arithmetic Logic Unit in SystemVerilog
// Author:      Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

module alu4 (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [2:0] opcode,
    output logic [3:0] result,
    output logic       carry_borrow,
    output logic       zero
);

    typedef enum logic [2:0] {
        OP_ADD = 3'b000,
        OP_SUB = 3'b001,
        OP_AND = 3'b010,
        OP_OR  = 3'b011,
        OP_XOR = 3'b100
    } alu_op_e;

    logic [4:0] temp;

    always_comb begin
        result       = 4'b0000;
        carry_borrow = 1'b0;
        temp         = 5'b00000;

        case (opcode)
            OP_ADD: begin
                temp         = {1'b0, A} + {1'b0, B};
                result       = temp[3:0];
                carry_borrow = temp[4];
            end

            OP_SUB: begin
                result       = A - B;
                carry_borrow = (A < B);
            end

            OP_AND: begin
                result = A & B;
            end

            OP_OR: begin
                result = A | B;
            end

            OP_XOR: begin
                result = A ^ B;
            end

            default: begin
                result       = 4'b0000;
                carry_borrow = 1'b0;
            end
        endcase

        zero = (result == 4'b0000);
    end

endmodule

