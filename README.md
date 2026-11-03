# RISC-V (RV32I) Processor Simulation Workshop using ModelSim

[![RISC-V](https://img.shields.io/badge/Architecture-RISC--V%20RV32I-orange.svg)](https://riscv.org/)
[![Verilog HDL](https://img.shields.io/badge/Language-Verilog%20HDL%20(IEEE%201364)-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog%20(IEEE%201800)-red.svg)](https://en.wikipedia.org/wiki/SystemVerilog)
[![Simulator](https://img.shields.io/badge/Simulator-ModelSim-green.svg)](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-simulation.html)
[![Author](https://img.shields.io/badge/Author-Dheepak-purple.svg)](https://github.com/dheepak6381-bit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A complete **RISC-V Processor Design & Simulation Workshop** repository featuring synthesizeable implementations in both **Verilog HDL (IEEE 1364)** and **SystemVerilog (IEEE 1800)**, verified using **ModelSim**. Progressive labs build from fundamental digital blocks to a complete **Single-Cycle 32-bit RV32I Core**.

---

## Repository Structure

```
riscv-modelsim-workshop/
├── full_adder_8bit/               # Lab 1: 8-Bit Ripple Carry Full Adder
│   ├── verilog/                   #   Verilog HDL implementation
│   ├── systemverilog/             #   SystemVerilog implementation
│   ├── run_sim.do                 #   ModelSim automation script
│   └── README.md
├── alu4/                          # Lab 2: 4-Bit Arithmetic Logic Unit
│   ├── verilog/                   #   Verilog HDL implementation
│   ├── systemverilog/             #   SystemVerilog implementation
│   ├── run_sim.do                 #   ModelSim automation script
│   └── README.md
├── d_flip_flop/                   # Lab 3: D Flip-Flop with Async Reset
│   ├── verilog/                   #   Verilog HDL implementation
│   ├── systemverilog/             #   SystemVerilog implementation
│   ├── run_sim.do                 #   ModelSim automation script
│   └── README.md
├── riscv_rv32i/                   # Lab 4: Single-Cycle 32-bit RV32I Processor
│   ├── src/                       #   Verilog HDL processor modules
│   ├── systemverilog/             #   SystemVerilog processor modules
│   │   ├── src/                   #     SV RTL (includes riscv_pkg.sv)
│   │   └── tb/                    #     SV Testbench
│   ├── tb/                        #   Verilog HDL testbench
│   ├── programs/                  #   Assembly source & hex machine code
│   ├── sim/                       #   ModelSim scripts (GUI & CLI)
│   └── README.md
├── docs/                          # Architecture specs & ModelSim guide
│   ├── architecture.md
│   └── modelsim_guide.md
├── .gitignore
├── LICENSE
└── README.md
```

---

## RISC-V Core Architecture

The processor implements a single-cycle datapath compliant with the **RV32I Base Integer ISA**:

```
                              +--------------------+
                              |  Instruction Mem   |
                              |     (256 Words)    |
                              +---------+----------+
                                        | instr[31:0]
               +------------------------+------------------------+
               |                        |                        |
       [Control Unit]             [Imm Generator]        [Register File]
   RegWrite, ALUSrc, MemToReg,       Sign-extend          32 x 32-bit
   MemRead, MemWrite, Branch,        I, S, B, U, J       x0 hardwired 0
   Jump, ALUOp                       Immediates           rs1, rs2, rd
         |                                |                    |
         v                                v                    v
    +---------+                      +----------+         +----------+
    | ALU Ctrl|                      | ALU In2  |<--------| rdata2   |
    +----+----+                      |  Mux     |         +----+-----+
         |                           +----+-----+              |
         v                                |                    |
    +-------------------------------------+----+               |
    |               32-Bit ALU                 |               |
    | ADD, SUB, SLL, SRL, SRA, SLT, SLTU, AND, |               |
    | OR, XOR, LUI Pass, Zero Flag             |               |
    +--------------------+---------------------+               |
                         | alu_result                          |
                         +-----------------+                   |
                         |                 |                   |
                         |                 v                   v
                         |       +-------------------+---------+--+
                         |       |            Data Memory         |
                         |       |      256 Words / Synchronous   |
                         |       +-------------------+------------+
                         |                           | mem_rdata
                         v                           v
                      +---------------------------------+
                      |     Write-Back Mux (MemToReg)   |
                      |  ALU Result / Memory / PC + 4   |
                      +----------------+----------------+
                                       | reg_wdata
                                       +---> [RegFile Write Port]
```

### Supported RV32I Instructions

| Type | Instructions |
|:----:|:-------------|
| **R-Type** | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| **I-Type** | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` |
| **Load/Store** | `LW`, `SW` |
| **Branch** | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| **Jump** | `JAL`, `JALR` |
| **Upper** | `LUI`, `AUIPC` |

---

## Verilog vs SystemVerilog

Each project provides **dual implementations** to compare classical Verilog HDL with modern SystemVerilog features:

| Feature | Verilog HDL (IEEE 1364) | SystemVerilog (IEEE 1800) |
|:--------|:-----------------------|:-------------------------|
| Signal Types | `wire`, `reg` | `logic` (unified) |
| Combinational | `always @(*)` | `always_comb` |
| Sequential | `always @(posedge clk)` | `always_ff @(posedge clk)` |
| Enumerations | `localparam` constants | `typedef enum logic` |
| Packages | Not available | `package` + `import` |
| Loop Variables | `integer i` | `int i` (inline) |
| Testbench Tasks | `task ... endtask` | `task automatic ... endtask` |

---

## Quick Start: ModelSim Simulation

### Method 1: GUI Simulation
1. Open **ModelSim**
2. `cd riscv_rv32i/sim`
3. Run:
   ```tcl
   do run_sim.do
   ```

### Method 2: Command-Line
```powershell
cd riscv_rv32i/sim
vlib work
vlog -sv ../systemverilog/src/riscv_pkg.sv ../systemverilog/src/*.sv ../systemverilog/tb/*.sv
vsim -c work.riscv_tb -do "run -all; quit -f"
```

---

## Verification Results

```
=======================================================
   RISC-V RV32I SystemVerilog Simulation - ModelSim
   Workshop: RISC-V Architecture & Simulation
   Author:   Dheepak (github.com/dheepak6381-bit)
=======================================================

[PASS] x1  (addi 15)                Expected: 0x0000000f | Actual: 0x0000000f
[PASS] x2  (addi 25)                Expected: 0x00000019 | Actual: 0x00000019
[PASS] x3  (add x1, x2)             Expected: 0x00000028 | Actual: 0x00000028
[PASS] x4  (sub x2, x1)             Expected: 0x0000000a | Actual: 0x0000000a
[PASS] x5  (and x1, x2)             Expected: 0x00000009 | Actual: 0x00000009
[PASS] x6  (or  x1, x2)             Expected: 0x0000001f | Actual: 0x0000001f
[PASS] x7  (xor x1, x2)             Expected: 0x00000016 | Actual: 0x00000016
[PASS] x8  (slli x1, 2)             Expected: 0x0000003c | Actual: 0x0000003c
[PASS] x9  (srli x2, 1)             Expected: 0x0000000c | Actual: 0x0000000c
[PASS] x10 (lw from mem[4])         Expected: 0x00000028 | Actual: 0x00000028
[PASS] x11 (loop sum 1..5)          Expected: 0x0000000f | Actual: 0x0000000f
[PASS] x12 (loop counter end)       Expected: 0x00000000 | Actual: 0x00000000
[PASS] x13 (lui 0x12345)            Expected: 0x12345000 | Actual: 0x12345000
[PASS] x14 (jal link PC+4)          Expected: 0x00000048 | Actual: 0x00000048
[PASS] x15 (SUCCESS FLAG)           Expected: 0x00000001 | Actual: 0x00000001
[PASS] Memory[4]                    Expected: 40         | Actual: 40
-------------------------------------------------------
>>> ALL SYSTEMVERILOG TESTS PASSED! (0 Errors) <<<
>>> RV32I SV Processor is fully operational!   <<<
=======================================================
```

---

## Author

**Dheepak**
- GitHub: [dheepak6381-bit](https://github.com/dheepak6381-bit)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
