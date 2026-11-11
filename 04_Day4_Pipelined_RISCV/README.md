# Day 4: Five-Stage Pipelined RISC-V CPU

**Author:** Dheepak ([@dheepak6381-bit](https://github.com/dheepak6381-bit))  
**Repository:** [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## Goal
Implement hazard handling in a 5-stage pipelined RISC-V processor (IF, ID, EX, MEM, WB), including data forwarding, load-use stall insertion, branch resolution and pipeline flushing, and benchmark performance metrics against the single-cycle implementation.

---

## Directory Structure

```
04_Day4_Pipelined_RISCV/
├── pipeline/
│   ├── pipeline_cpu.v         # 5-stage pipelined processor with forwarding & hazard unit
│   └── pipeline_tb.v          # Verification testbench for data/control hazards
└── README.md
```

---

## Architectural Highlights

1. **Pipeline Stages**:
   - **IF (Instruction Fetch)**: PC register, instruction memory fetch, branch target mux.
   - **ID (Instruction Decode)**: Register file read, immediate generation, hazard detection unit.
   - **EX (Execute)**: 32-bit ALU, forwarding multiplexers from MEM/WB stages, branch comparison.
   - **MEM (Memory Access)**: Data memory read/write.
   - **WB (Write-Back)**: Multiplexer routing ALU result or loaded data to the destination register.

2. **Hazard Handling**:
   - **Data Hazards**: EX/MEM $\rightarrow$ EX and MEM/WB $\rightarrow$ EX forwarding paths.
   - **Load-Use Dependency**: Detects load in EX followed by dependent instruction in ID; inserts one-cycle pipeline bubble/stall.
   - **Control Hazards**: Resolves branch conditions in EX/ID; flushes mispredicted instruction slots on branch taken.

