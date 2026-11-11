# 8-Bit Ripple Carry Full Adder - Workshop Lab 1

A ripple-carry 8-bit full adder implemented in Verilog HDL using `generate` blocks. Built by chaining eight 1-bit full adder instances. Serves as the introductory lab for the RISC-V workshop to establish HDL modeling, hierarchical design, and ModelSim testbench verification fundamentals.

## Design Architecture

The design is split into two modules:

### Module 1: `full_adder_1bit`

A single-bit full adder using combinational logic.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | Input | 1-bit | Bit A input |
| `b` | Input | 1-bit | Bit B input |
| `cin` | Input | 1-bit | Carry-in |
| `sum` | Output | 1-bit | Sum bit |
| `cout` | Output | 1-bit | Carry-out |

**Logic:**
```verilog
sum  = a ^ b ^ cin;
cout = (a & b) | (b & cin) | (a & cin);
```

### Module 2: `full_adder_8bit`

An 8-bit ripple-carry adder that uses a `generate` loop to instantiate 8 copies of `full_adder_1bit`.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `A` | Input | 8-bit | First operand |
| `B` | Input | 8-bit | Second operand |
| `Cin` | Input | 1-bit | Carry-in |
| `Sum` | Output | 8-bit | 8-bit sum result |
| `Cout` | Output | 1-bit | Final carry-out |

## Files

| File | Description |
|------|-------------|
| `full_adder_8bit.v` | 1-bit and 8-bit adder design modules |
| `full_adder_8bit_tb.v` | Testbench with 6 test cases |
| `run_sim.do` | ModelSim automation script with pre-configured waveform |

## Testbench Test Cases

| Test | A | B | Cin | Expected Sum | Cout |
|------|---|---|-----|--------------|------|
| 1 | 10 | 20 | 0 | 30 | 0 |
| 2 | 100 | 50 | 0 | 150 | 0 |
| 3 | 255 | 1 | 0 | 0 (overflow) | 1 |
| 4 | 255 | 255 | 1 | 255 | 1 |
| 5 | 128 | 127 | 1 | 0 (overflow) | 1 |
| 6 | 50 | 25 | 1 | 76 | 0 |

## ModelSim Simulation

### Using the Automated Script
In ModelSim transcript:
```tcl
do run_sim.do
```

### Manual Simulation
```bash
vlib work
vlog full_adder_8bit.v full_adder_8bit_tb.v
vsim -voptargs="+acc" work.full_adder_8bit_tb
add wave -r /*
run -all
```

## Block Diagram

```
       +-------------------------------------+
  A -->|  FA[0] FA[1] FA[2] ... FA[7]        |--> Sum [7:0]
  B -->|  (chain of 1-bit full adders)       |--> Cout
Cin -->|                                     |
       +-------------------------------------+
```
