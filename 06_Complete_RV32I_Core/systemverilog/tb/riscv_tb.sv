`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: riscv_tb (SystemVerilog)
// Description: Comprehensive verification testbench for RV32I Processor in SV
// Author:    Dheepak (github.com/dheepak6381-bit)
//////////////////////////////////////////////////////////////////////////////////

import riscv_pkg::*;

module riscv_tb;

    logic        clk;
    logic        rst_n;

    // Debug wires from CPU
    logic [31:0] debug_pc;
    logic [31:0] debug_instr;
    logic [31:0] debug_alu_result;
    logic [31:0] debug_reg_wdata;
    logic        debug_reg_write;
    logic        debug_mem_write;

    int cycle_count;
    int errors;
    bit sim_running;

    // Instantiate SystemVerilog Top Module
    riscv_top #(
        .INIT_HEX   ("program.hex"),
        .IMEM_DEPTH (256),
        .DMEM_DEPTH (256)
    ) uut (
        .clk              (clk),
        .rst_n            (rst_n),
        .debug_pc         (debug_pc),
        .debug_instr      (debug_instr),
        .debug_alu_result (debug_alu_result),
        .debug_reg_wdata  (debug_reg_wdata),
        .debug_reg_write  (debug_reg_write),
        .debug_mem_write  (debug_mem_write)
    );

    // Clock: 100 MHz (10ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $display("\n=======================================================");
        $display("   RISC-V RV32I SystemVerilog Simulation - ModelSim   ");
        $display("   Workshop: RISC-V Architecture & Simulation         ");
        $display("   Author:   Dheepak (github.com/dheepak6381-bit)     ");
        $display("=======================================================\n");

        rst_n       = 1'b0;
        cycle_count = 0;
        errors      = 0;
        sim_running = 1'b1;

        // Apply reset for 25ns
        #25;
        @(negedge clk);
        rst_n = 1'b1;
        $display("[INFO] System Reset De-asserted at time %0t ns", $time);
        $display("----------------------------------------------------------------------------------");
        $display(" Cycle |    PC    |   Instr   | ALU Result | RegWrite | Reg WData  | MemWrite");
        $display("----------------------------------------------------------------------------------");

        while (cycle_count < 60 && sim_running) begin
            @(posedge clk);
            #1;
            $display(" %5d | 0x%08h | 0x%08h | 0x%08h |    %b     | 0x%08h |    %b",
                     cycle_count, debug_pc, debug_instr, debug_alu_result,
                     debug_reg_write, debug_reg_wdata, debug_mem_write);

            // Halt loop detection at PC = 0x50
            if (debug_pc == 32'h00000050 && debug_instr == 32'h00000063) begin
                $display("\n[INFO] Reached Program Halt (Infinite Loop) at cycle %0d", cycle_count);
                sim_running = 1'b0;
            end else begin
                cycle_count++;
            end
        end

        repeat (4) @(posedge clk);

        // Verification Report
        $display("\n=======================================================");
        $display("       SV REGISTER FILE VERIFICATION REPORT           ");
        $display("=======================================================");

        check_reg(1,  32'd15,        uut.u_regfile.registers[1],  "x1  (addi 15)");
        check_reg(2,  32'd25,        uut.u_regfile.registers[2],  "x2  (addi 25)");
        check_reg(3,  32'd40,        uut.u_regfile.registers[3],  "x3  (add x1, x2)");
        check_reg(4,  32'd10,        uut.u_regfile.registers[4],  "x4  (sub x2, x1)");
        check_reg(5,  32'd9,         uut.u_regfile.registers[5],  "x5  (and x1, x2)");
        check_reg(6,  32'd31,        uut.u_regfile.registers[6],  "x6  (or  x1, x2)");
        check_reg(7,  32'd22,        uut.u_regfile.registers[7],  "x7  (xor x1, x2)");
        check_reg(8,  32'd60,        uut.u_regfile.registers[8],  "x8  (slli x1, 2)");
        check_reg(9,  32'd12,        uut.u_regfile.registers[9],  "x9  (srli x2, 1)");
        check_reg(10, 32'd40,        uut.u_regfile.registers[10], "x10 (lw from mem[4])");
        check_reg(11, 32'd15,        uut.u_regfile.registers[11], "x11 (loop sum 1..5)");
        check_reg(12, 32'd0,         uut.u_regfile.registers[12], "x12 (loop counter end)");
        check_reg(13, 32'h12345000,  uut.u_regfile.registers[13], "x13 (lui 0x12345)");
        check_reg(14, 32'h00000048,  uut.u_regfile.registers[14], "x14 (jal link PC+4)");
        check_reg(15, 32'd1,         uut.u_regfile.registers[15], "x15 (SUCCESS FLAG)");

        if (uut.u_dmem.ram[1] == 32'd40) begin
            $display("[PASS] Memory[4]   Expected: 40 | Actual: %0d", uut.u_dmem.ram[1]);
        end else begin
            $display("[FAIL] Memory[4]   Expected: 40 | Actual: %0d", uut.u_dmem.ram[1]);
            errors++;
        end

        $display("-------------------------------------------------------");
        if (errors == 0) begin
            $display(">>> ALL SYSTEMVERILOG TESTS PASSED! (0 Errors) <<<");
            $display(">>> RV32I SV Processor is fully operational!   <<<");
        end else begin
            $display(">>> VERIFICATION FAILED with %0d errors! <<<", errors);
        end
        $display("=======================================================\n");

        $finish;
    end

    task automatic check_reg(
        input int reg_num,
        input logic [31:0] expected,
        input logic [31:0] actual,
        input string description
    );
        if (actual === expected) begin
            $display("[PASS] %-28s Expected: 0x%08h | Actual: 0x%08h", description, expected, actual);
        end else begin
            $display("[FAIL] %-28s Expected: 0x%08h | Actual: 0x%08h", description, expected, actual);
            errors++;
        end
    endtask

endmodule

