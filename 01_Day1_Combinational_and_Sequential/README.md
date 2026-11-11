# Day 1: Combinational & Sequential Building Blocks

**Author:** Dheepak ([@dheepak6381-bit](https://github.com/dheepak6381-bit))  
**Repository:** [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## Overview

This module contains foundational Verilog activities covering essential combinational and sequential building blocks required for processor datapath design.

### Directory Structure & Modules

```
01_Day1_Combinational_and_Sequential/
├── 1.1_alu/
│   ├── alu.v                  # 8-operation ALU
│   ├── alu_tb.v               # ALU testbench
│   └── 1.1alu.png             # Simulation waveform screenshot
├── 1.2_counter/
│   ├── counter.v              # Up/Down counter with sync reset & parallel load
│   ├── counter_tb.v           # Counter testbench
│   └── 1.2counter.png         # Simulation waveform screenshot
├── 1.3_shifter/
│   ├── shifter.v              # Combinational barrel shifter (SLL, SRL, SRA)
│   ├── shifter_tb.v           # Shifter testbench
│   └── 1.3shifter waveform.png# Simulation waveform screenshot
├── 1.4_regfile/
│   ├── regfile.v              # Dual-read, single-write register file (x0 = 0)
│   ├── regfile_tb.v           # Register file testbench
│   └── 1.4regfile waveform.png# Simulation waveform screenshot
└── README.md
```

### Module Specifications

1. **1.1 ALU (`alu.v`)**:
   - `3'b000`: ADD
   - `3'b001`: SUB
   - `3'b010`: AND
   - `3'b011`: OR
   - `3'b100`: XOR
   - `3'b101`: SLT (Set Less Than)
   - `3'b110`: SLL (Shift Left Logical)
   - `3'b111`: SRL (Shift Right Logical)

2. **1.2 Counter (`counter.v`)**:
   - Priority: Synchronous reset $\rightarrow$ parallel load $\rightarrow$ enabled count (up/down).

3. **1.3 Shifter (`shifter.v`)**:
   - Combinational barrel shifter supporting Logical Left Shift (SLL), Logical Right Shift (SRL), and Arithmetic Right Shift (SRA, sign bit preserved).

4. **1.4 Register File (`regfile.v`)**:
   - Asynchronous read ports, synchronous write port with same-cycle bypass, register `x0` hardwired to zero.

