# ModelSim Simulation Guide for RISC-V Workshop

This guide walks participants through setting up, simulating, and analyzing the RISC-V RV32I processor using ModelSim.

---

## 1. Prerequisites
- **ModelSim** (Intel FPGA Edition, ModelSim-PE, or QuestaSim) installed and added to your system PATH.
- Basic familiarity with digital logic (ALU, registers, multiplexers).

---

## 2. Quickstart: One-Command Simulation

### Using the ModelSim GUI
1. Launch **ModelSim**.
2. Set your current working directory to the project's simulation folder:
   ```tcl
   cd <path-to-repo>/riscv_rv32i/sim
   ```
3. Run the automated script:
   ```tcl
   do run_sim.do
   ```
4. The script will:
   - Create and map the `work` library.
   - Compile all 9 Verilog design files and the testbench.
   - Load the simulation into the ModelSim simulator kernel (`vsim`).
   - Group and format all key signals in the Wave window.
   - Execute the simulation to completion (`run -all`).
   - Automatically zoom to fit the full waveform (`wave zoom full`).

---

## 3. Step-by-Step Manual Simulation in ModelSim

If you prefer to perform each step interactively:

### Step 3.1: Create Library & Map
In the ModelSim Transcript console:
```tcl
vlib work
vmap work work
```

### Step 3.2: Compile Verilog Sources
```tcl
vlog -work work ../src/alu_32bit.v
vlog -work work ../src/alu_control.v
vlog -work work ../src/control_unit.v
vlog -work work ../src/imm_gen.v
vlog -work work ../src/program_counter.v
vlog -work work ../src/register_file.v
vlog -work work ../src/instruction_memory.v
vlog -work work ../src/data_memory.v
vlog -work work ../src/riscv_top.v
vlog -work work ../tb/riscv_tb.v
```

### Step 3.3: Load the Simulation
```tcl
vsim -voptargs="+acc" work.riscv_tb
```

### Step 3.4: Add Waves
```tcl
# System
add wave -radix hexadecimal /riscv_tb/clk
add wave -radix hexadecimal /riscv_tb/rst_n
add wave -radix hexadecimal /riscv_tb/debug_pc
add wave -radix hexadecimal /riscv_tb/debug_instr

# Internal Registers
add wave -radix decimal /riscv_tb/uut/u_regfile/registers
```

### Step 3.5: Run Simulation
```tcl
run 500ns
```

---

## 4. Waveform Inspection Checklist

During the workshop, inspect the following signals at key instruction steps:

| Time / Cycle | Instruction | Expected Waveform Observation |
|:-------------|:------------|:------------------------------|
| **Cycle 0**  | `addi x1, x0, 15` | `pc = 0x0`, `instr = 0x00f00093`, `RegWrite = 1`, `wdata = 15` |
| **Cycle 1**  | `addi x2, x0, 25` | `pc = 0x4`, `instr = 0x01900113`, `RegWrite = 1`, `wdata = 25` |
| **Cycle 2**  | `add x3, x1, x2`  | `alu_result = 40`, `x3` updates to `40` |
| **Cycle 8**  | `sw x3, 4(x0)`    | `MemWrite = 1`, `dmem_addr = 4`, `dmem_wdata = 40` |
| **Cycle 9**  | `lw x10, 4(x0)`   | `MemRead = 1`, `dmem_addr = 4`, `x10` updates to `40` |
| **Cycles 12-26** | `loop (sum 1..5)` | `x11` accumulates: 5 -> 9 -> 12 -> 14 -> 15; branch taken 5 times |
| **Cycle 28** | `jal x14, 8`      | `pc` jumps from `0x44` to `0x4C`; return address `0x48` stored in `x14` |
| **Cycle 29** | `addi x15, x0, 1` | `x15` updates to `1` (SUCCESS FLAG) |
| **Cycle 30** | `beq x0, x0, 0`   | `pc` stalls in self-loop `0x50` |

---

## 5. Troubleshooting Common ModelSim Errors

- **`** Error: (vlog-7) Failed to open -readmem file "program.hex"`**:
  - Ensure `program.hex` is present in the directory where `vsim` is launched (`riscv_rv32i/sim`).
- **Signal radix is binary or unreadable**:
  - Right-click on signal in the Wave window -> **Radix** -> Select **Hexadecimal** or **Decimal**.
- **ModelSim console not updating**:
  - Type `run 100ns` or click the "Run" icon in the top toolbar.
