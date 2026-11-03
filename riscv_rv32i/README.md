# Single-Cycle 32-Bit RISC-V (RV32I) Processor - Workshop Core

A complete single-cycle 32-bit RISC-V (RV32I Base Integer ISA) processor implemented in Verilog HDL, simulated and verified using ModelSim.

---

## Architecture Overview

The core implements the standard Princeton/Harvard single-cycle datapath executing one instruction per clock cycle:

```
+---------------+     +---------------+     +---------------+     +---------------+     +---------------+
|  Instruction  | --> |  Instruction  | --> |   Execution   | --> |  Data Memory  | --> |  Write-Back   |
|  Fetch (IF)   |     |  Decode (ID)  |     |     (EX)      |     |  Access (MEM) |     |     (WB)      |
+---------------+     +---------------+     +---------------+     +---------------+     +---------------+
  [PC Register]        [RegFile 32x32]       [32-bit ALU]          [RAM 256 Words]       [Mux to rd]
  [IMEM ROM]           [Immediate Gen]       [ALU Control]
                       [Main Control]        [Branch Eval]
```

### Supported Instruction Set

| Format | Instructions Supported | Operation Description |
|:------:|:-----------------------|:----------------------|
| **R-Type** | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` | Register-to-register arithmetic, logic, and shifts |
| **I-Type** | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` | Register-immediate arithmetic, logic, and shifts |
| **Load** | `LW` | Load 32-bit word from memory |
| **Store** | `SW` | Store 32-bit word to memory |
| **Branch** | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` | Conditional branch relative to PC |
| **Jump** | `JAL`, `JALR` | Unconditional jump & link (function call / return) |
| **Upper** | `LUI`, `AUIPC` | Load Upper Immediate (20-bit), Add Upper Imm to PC |

---

## Module Hierarchy

```
riscv_top (Top Module)
├── program_counter      # 32-bit PC register with sync reset & branch muxing
├── instruction_memory   # 256-word ROM initialized via $readmemh ("program.hex")
├── control_unit         # Main opcode decoder (RegWrite, ALUSrc, MemToReg, etc.)
├── alu_control          # Decodes ALUOp, funct3, and funct7 into 4-bit ALU control
├── register_file        # 32 x 32-bit general registers (x0 hardwired to zero)
├── imm_gen              # Immediate sign-extension for I, S, B, U, J types
├── alu_32bit            # 32-bit ALU with arithmetic, shifts, logic, zero flag
└── data_memory          # 256-word RAM with synchronous write & transparent read
```

---

## Directory Structure

```
riscv_rv32i/
├── src/
│   ├── alu_32bit.v           # 32-bit ALU module
│   ├── alu_control.v         # ALU decoder
│   ├── control_unit.v        # Main control unit decoder
│   ├── data_memory.v         # 256-word RAM
│   ├── imm_gen.v             # Immediate generator
│   ├── instruction_memory.v  # 256-word instruction ROM
│   ├── program_counter.v     # 32-bit Program Counter
│   ├── register_file.v       # 32x32 Register File
│   └── riscv_top.v           # Top-level integrated processor
├── tb/
│   └── riscv_tb.v            # Self-checking testbench with register checks
├── programs/
│   ├── program.s             # Assembly source code with inline comments
│   └── program.hex           # Assembled hex machine code loaded into ROM
├── sim/
│   ├── run_sim.do            # GUI ModelSim simulation script with waveform dividers
│   ├── run_sim_cli.do        # Headless/command-line simulation script
│   └── program.hex           # Hex file for simulation execution
└── README.md                 # Lab documentation
```

---

## Demonstration Program (`program.s`)

The included test program validates the processor with arithmetic, memory, and branching:

```assembly
_start:
    # 1. Initialize Operands
    addi x1, x0, 15          # x1 = 15
    addi x2, x0, 25          # x2 = 25

    # 2. Arithmetic & Logic Operations
    add  x3, x1, x2          # x3 = 15 + 25 = 40
    sub  x4, x2, x1          # x4 = 25 - 15 = 10
    and  x5, x1, x2          # x5 = 15 & 25 = 9
    or   x6, x1, x2          # x6 = 15 | 25 = 31
    xor  x7, x1, x2          # x7 = 15 ^ 25 = 22

    # 3. Shift Operations
    slli x8, x1, 2           # x8 = 15 << 2 = 60
    srli x9, x2, 1           # x9 = 25 >> 1 = 12

    # 4. Data Memory Access
    sw   x3, 4(x0)           # Memory[4] = x3 = 40
    lw   x10, 4(x0)          # x10 = Memory[4] = 40

    # 5. Loop (Sum 1 to 5)
    addi x11, x0, 0          # sum = 0
    addi x12, x0, 5          # count = 5
loop:
    add  x11, x11, x12       # sum += count
    addi x12, x12, -1        # count--
    bne  x12, x0, loop       # branch if count != 0 (sum = 15)

    # 6. Upper Immediate
    lui  x13, 0x12345        # x13 = 0x12345000

    # 7. Unconditional Jump
    jal  x14, skip_target    # jump over next instruction, x14 = PC+4
    addi x15, x0, 99         # [SKIPPED]

skip_target:
    addi x15, x0, 1          # x15 = 1 (SUCCESS FLAG)

halt:
    beq  x0, x0, halt        # Infinite loop
```

---

## How to Simulate in ModelSim

### Option 1: One-Click GUI Simulation (Recommended)
1. Open **ModelSim**.
2. Change directory (`File -> Change Directory...`) to `riscv_rv32i/sim`.
3. In the ModelSim Transcript console, run:
   ```tcl
   do run_sim.do
   ```
4. ModelSim will compile all modules, load the testbench, organize the Wave window with color-coded signal groups, and run the simulation to completion.

### Option 2: Command-Line Simulation
From PowerShell or Command Prompt:
```powershell
cd riscv_rv32i/sim
vlib work
vlog ../src/*.v ../tb/*.v
vsim -c work.riscv_tb -do "run -all; quit -f"
```

---

## Simulation Verification Results

```
=======================================================
             REGISTER FILE VERIFICATION REPORT        
=======================================================
[PASS] x1  (addi 15)             Expected: 0x0000000f | Actual: 0x0000000f
[PASS] x2  (addi 25)             Expected: 0x00000019 | Actual: 0x00000019
[PASS] x3  (add x1, x2)          Expected: 0x00000028 | Actual: 0x00000028
[PASS] x4  (sub x2, x1)          Expected: 0x0000000a | Actual: 0x0000000a
[PASS] x5  (and x1, x2)          Expected: 0x00000009 | Actual: 0x00000009
[PASS] x6  (or  x1, x2)          Expected: 0x0000001f | Actual: 0x0000001f
[PASS] x7  (xor x1, x2)          Expected: 0x00000016 | Actual: 0x00000016
[PASS] x8  (slli x1, 2)          Expected: 0x0000003c | Actual: 0x0000003c
[PASS] x9  (srli x2, 1)          Expected: 0x0000000c | Actual: 0x0000000c
[PASS] x10 (lw from mem[4])      Expected: 0x00000028 | Actual: 0x00000028
[PASS] x11 (loop sum 1..5)       Expected: 0x0000000f | Actual: 0x0000000f
[PASS] x12 (loop counter end)    Expected: 0x00000000 | Actual: 0x00000000
[PASS] x13 (lui 0x12345)         Expected: 0x12345000 | Actual: 0x12345000
[PASS] x14 (jal link PC+4)       Expected: 0x00000048 | Actual: 0x00000048
[PASS] x15 (SUCCESS FLAG)        Expected: 0x00000001 | Actual: 0x00000001
[PASS] Memory[4]                 Expected: 40         | Actual: 40
-------------------------------------------------------
>>> ALL TESTS PASSED SUCCESSFULLY! (0 Errors) <<<
>>> RV32I Processor is fully operational!    <<<
=======================================================
```
