# Day 3: Single-Cycle RISC-V CPU

**Author:** Dheepak ([@dheepak6381-bit](https://github.com/dheepak6381-bit))  
**Repository:** [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## Goal
Implement a functional single-cycle RISC-V CPU supporting fundamental RV32I integer instructions, execute assembly programs, verify results with self-checking testbenches, and analyze simulation waveforms.

---

## Directory Structure

```
03_Day3_Single_Cycle_RISCV/
├── ALU/
│   ├── alu.v                  # 32-bit ALU supporting ADD, SUB, AND, OR, XOR, SLT, shifts
│   └── alu_tb.v               # ALU testbench
├── Assembly_Programs/
│   ├── program1_sum.asm       # Sum of integers from 1 to N
│   ├── program2_fibonacci.asm # Generate first 10 Fibonacci numbers
│   └── program3_max.asm       # Maximum element in an array of 8 words
├── Control_Unit/
│   ├── control_unit.v         # Opcode and funct3/funct7 decoder
│   └── control_unit_tb.v      # Control unit testbench
├── CPU/
│   ├── cpu.v                  # Integrated single-cycle RISC-V CPU top module
│   └── cpu_tb.v               # Self-checking CPU testbench
├── Immediate_Generator/
│   ├── immediate_generator.v  # Sign-extension logic for I, S, B, U, J types
│   └── immediate_generator_tb.v
├── Register_File/
│   ├── register_file.v        # 32 x 32-bit registers (x0 hardwired to 0)
│   └── register_file_tb.v
├── Shifter/
│   ├── shifter.v              # Barrel shifter module
│   └── shifter_tb.v
└── README.md
```

---

## Supported Instructions & Activities

1. **Instruction Extensions**:
   - Arithmetic Immediate: `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`
   - Shifts: `SLLI`, `SRLI`, `SRAI`
   - Memory Access: `LW`, `SW`
   - Control Flow: `BEQ`, `BNE`, `JAL`, `LUI`

2. **Assembly Programs**:
   - `program1_sum.asm`: Sum $1 + 2 + \dots + N$
   - `program2_fibonacci.asm`: Fibonacci sequence generator
   - `program3_max.asm`: Array maximum finder

3. **Self-Checking Verification**:
   - Automated comparison of final register states with expected outputs.

