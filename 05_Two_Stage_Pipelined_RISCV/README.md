# 2-Stage Pipelined RISC-V Processor (Fetch | Execute)

**Author:** Dheepak ([@dheepak6381-bit](https://github.com/dheepak6381-bit))  
**Repository:** [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## Overview

A compact 2-stage pipelined RISC-V core dividing execution into:
1. **Stage 1 (IF - Instruction Fetch)**: Fetches the instruction at `PC` and advances the program counter.
2. **Stage 2 (EX - Decode, Execute & Write-Back)**: Decodes the instruction, performs register reads, executes the ALU operation, accesses memory, and completes register write-back.

---

## Directory Structure

```
05_Two_Stage_Pipelined_RISCV/
├── riscv_2stage.v             # 2-stage pipelined processor design
├── tb_riscv_2stage.v          # Simulation testbench
└── README.md
```

---

## Simulation

```bash
# In ModelSim or Icarus Verilog
vlog riscv_2stage.v tb_riscv_2stage.v
vsim -c tb_riscv_2stage -do "run -all; quit -f"
```

