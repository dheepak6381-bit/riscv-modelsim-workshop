# 4-Bit Arithmetic Logic Unit (ALU) - Workshop Lab 2

A 4-bit Arithmetic Logic Unit implemented in Verilog HDL. Supports 5 core arithmetic and logical operations selected via a 3-bit opcode. Serves as a foundational building block for processor ALU design in the RISC-V workshop.

## Module: `alu4`

### Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `A` | Input | 4-bit | First operand |
| `B` | Input | 4-bit | Second operand |
| `opcode` | Input | 3-bit | Operation selector |
| `result` | Output | 4-bit | Operation result |
| `carry_borrow` | Output | 1-bit | Carry (ADD) or Borrow (SUB) flag |
| `zero` | Output | 1-bit | Zero flag (1 if result == 0) |

### Supported Operations

| Opcode | Operation | Description |
|--------|-----------|-------------|
| `3'b000` | ADD | `result = A + B`, sets carry on overflow |
| `3'b001` | SUB | `result = A - B`, sets borrow if A < B |
| `3'b010` | AND | `result = A & B` (Bitwise AND) |
| `3'b011` | OR  | `result = A | B` (Bitwise OR) |
| `3'b100` | XOR | `result = A ^ B` (Bitwise XOR) |
| `3'b101`-`3'b111` | DEFAULT | `result = 0` |

## Files

| File | Description |
|------|-------------|
| `alu4.v` | ALU design module |
| `alu4_tb.v` | Self-checking testbench with 8 test cases |
| `run_sim.do` | ModelSim automation script with pre-configured waveform |

## Testbench Test Cases

| Test | A | B | Opcode | Expected Result |
|------|---|---|--------|-----------------|
| ADD | 0101 (5) | 0011 (3) | 000 | 1000 (8), carry=0 |
| ADD overflow | 1111 (15) | 0001 (1) | 000 | 0000 (0), carry=1 |
| SUB | 0101 (5) | 0011 (3) | 001 | 0010 (2), borrow=0 |
| SUB borrow | 0011 (3) | 0101 (5) | 001 | 1110 (14), borrow=1 |
| AND | 0101 (5) | 0011 (3) | 010 | 0001 (1) |
| OR  | 0101 (5) | 0011 (3) | 011 | 0111 (7) |
| XOR | 0101 (5) | 0011 (3) | 100 | 0110 (6) |
| SUB zero | 0101 (5) | 0101 (5) | 001 | 0000 (0), zero=1 |

## ModelSim Simulation

### Using the Automated Script
In ModelSim transcript:
```tcl
do run_sim.do
```

### Manual Simulation
```bash
vlib work
vlog alu4.v alu4_tb.v
vsim -voptargs="+acc" work.alu4_tb
add wave -r /*
run -all
```

## Block Diagram

```
       +----------------------+
  A -->|                      |--> result [3:0]
  B -->|       alu4           |--> carry_borrow
       |                      |--> zero
opcode>|                      |
       +----------------------+
```
