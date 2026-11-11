# RISC-V Processor Design & Digital Logic Simulation Workshop

[![Architecture](https://img.shields.io/badge/Architecture-RISC--V%20(RV32I)-orange.svg)](https://riscv.org/)
[![Verilog HDL](https://img.shields.io/badge/Language-Verilog%20HDL%20(IEEE%201364)-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog%20(IEEE%201800)-red.svg)](https://en.wikipedia.org/wiki/SystemVerilog)
[![Simulator](https://img.shields.io/badge/Simulator-ModelSim-green.svg)](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-simulation.html)
[![Author](https://img.shields.io/badge/Author-Dheepak-purple.svg)](https://github.com/dheepak6381-bit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A complete, structured digital design and computer architecture workshop repository implementing digital logic blocks, finite state machines, memory subsystems, and full single-cycle and pipelined **RISC-V (RV32I) microprocessors**.

All modules are written in **Verilog HDL** and **SystemVerilog**, simulated with **ModelSim** and **Icarus Verilog**, and verified using self-checking testbenches.

---

## 📑 Progressive Workshop Curriculum

The repository is organized in sequential order:

```
riscv-modelsim-workshop/
├── 00_Foundational_Labs/                      # Introductory digital blocks
│   ├── alu4/                                  #   4-bit ALU (Verilog & SystemVerilog)
│   ├── d_flip_flop/                           #   Positive edge D-FF with async reset (Verilog & SV)
│   ├── full_adder_8bit/                       #   8-bit ripple-carry adder (Verilog & SV)
│   ├── full_adder4/                           #   4-bit behavioral adder
│   └── adder_dff_top/                         #   Registered adder with D-FF
├── 01_Day1_Combinational_and_Sequential/      # Day 1: Datapath Building Blocks
│   ├── 1.1_alu/                               #   8-operation 32-bit ALU + waveform
│   ├── 1.2_counter/                           #   Up/down counter with parallel load + waveform
│   ├── 1.3_shifter/                           #   Combinational barrel shifter (SLL/SRL/SRA) + waveform
│   └── 1.4_regfile/                           #   Dual-read/single-write register file (x0=0) + waveform
├── 02_Day2_FSM_and_Memory/                    # Day 2: Control Logic & Sequential Storage
│   ├── 2.1_sequence_detector/                 #   Mealy & Moore 1011 sequence detectors with overlap
│   ├── 2.2_vending/                           #   Vending machine controller (dispense/change/cancel)
│   ├── 2.3_fifo/                              #   Synchronous FIFO buffer (16x8)
│   ├── 2.4_design_review/                     #   Design review analysis & timing notes
│   ├── 2.5_traffic/                           #   Traffic light controller with pedestrian latching
│   ├── 2.6_atm/                               #   ATM PIN authentication & withdrawal FSM
│   └── 2.7_washing_machine_fsm/               #   SystemVerilog washing machine controller FSM
├── 03_Day3_Single_Cycle_RISCV/                # Day 3: Single-Cycle RV32I Processor
│   ├── ALU/                                   #   RV32I integer arithmetic & logic unit
│   ├── Control_Unit/                          #   Main decoder & ALU controller
│   ├── Immediate_Generator/                   #   Sign-extension for I, S, B, U, J types
│   ├── Register_File/                         #   32 x 32-bit general purpose registers
│   ├── Shifter/                               #   Logical & arithmetic shifter
│   ├── CPU/                                   #   Integrated single-cycle CPU top & testbench
│   └── Assembly_Programs/                     #   RV32I assembly tests (sum, fibonacci, max)
├── 04_Day4_Pipelined_RISCV/                   # Day 4: 5-Stage Pipelined RV32I Processor
│   └── pipeline/                              #   IF, ID, EX, MEM, WB with forwarding & hazard unit
├── 05_Two_Stage_Pipelined_RISCV/              # Compact 2-Stage Pipelined RISC-V Core
│   ├── riscv_2stage.v                         #   Fetch | Execute 2-stage pipelined design
│   └── tb_riscv_2stage.v                      #   Self-checking pipeline testbench
├── 06_Complete_RV32I_Core/                    # Comprehensive RV32I Processor (ModelSim Verified)
│   ├── verilog/                               #   Verilog-2001 synthesizable core
│   ├── systemverilog/                         #   SystemVerilog package, enums & typed core
│   ├── programs/                              #   Pre-assembled test machine code
│   └── sim/                                   #   One-click ModelSim .do automation scripts
├── docs/                                      # Technical References
│   ├── architecture.md                        #   Datapath diagrams, opcode & ALU truth tables
│   └── modelsim_guide.md                      #   Step-by-step ModelSim simulation guide
├── .gitignore
├── LICENSE                                    # MIT License
└── README.md
```

---

## 🏛️ RISC-V Architecture Summary

### Single-Cycle & Pipelined Datapaths

```
Single-Cycle:
  +---------------+     +---------------+     +---------------+     +---------------+     +---------------+
  |  Fetch (IF)   | --> |  Decode (ID)  | --> | Execute (EX)  | --> | Memory (MEM)  | --> |Write-Back (WB)|
  +---------------+     +---------------+     +---------------+     +---------------+     +---------------+
    PC + IMEM ROM         RegFile + ImmGen      32-bit ALU            Data Memory RAM       Mux to rd

5-Stage Pipeline:
  [IF] ---> [IF/ID] ---> [ID] ---> [ID/EX] ---> [EX] ---> [EX/MEM] ---> [MEM] ---> [MEM/WB] ---> [WB]
                                                 ^                         |                 |
                                                 |==== Forwarding Paths ===|=================|
```

### Supported RV32I Instructions

- **R-Type**: `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND`
- **I-Type Arithmetic**: `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI`
- **Load & Store**: `LW`, `SW`
- **Conditional Branches**: `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`
- **Jumps**: `JAL`, `JALR`
- **Upper Immediate**: `LUI`, `AUIPC`

---

## 🚀 Quick Start: ModelSim Simulation

### 1. Simulating the Complete RV32I Core
```tcl
# In ModelSim:
cd 06_Complete_RV32I_Core/sim
do run_sim.do
```

### 2. Simulating Day 3 Single-Cycle CPU
```bash
cd 03_Day3_Single_Cycle_RISCV
vlog CPU/*.v ALU/*.v Control_Unit/*.v Immediate_Generator/*.v Register_File/*.v Shifter/*.v
vsim -c cpu_tb -do "run -all; quit -f"
```

### 3. Simulating Day 4 5-Stage Pipelined CPU
```bash
cd 04_Day4_Pipelined_RISCV/pipeline
vlog pipeline_cpu.v pipeline_tb.v
vsim -c pipeline_tb -do "run -all; quit -f"
```

---

## 👤 Author

**Dheepak**
- GitHub: [@dheepak6381-bit](https://github.com/dheepak6381-bit)
- Repository: [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
