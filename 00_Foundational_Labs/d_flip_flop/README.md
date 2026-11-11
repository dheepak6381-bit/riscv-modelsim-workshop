# D Flip-Flop with Asynchronous Reset - Workshop Sequential Foundation

Positive edge-triggered D Flip-Flop with asynchronous active-high reset, implemented in both **Verilog HDL (IEEE 1364)** and **SystemVerilog (IEEE 1800)**. Serves as the fundamental sequential building block for the Program Counter (PC) and Register File in the RISC-V workshop.

---

## Implementations

### 1. Verilog HDL (`verilog/`)
Uses standard `always @(posedge clk or posedge reset)`.

### 2. SystemVerilog (`systemverilog/`)
Uses modern `always_ff @(posedge clk or posedge reset)` and `logic` types for synthesis predictability.

---

## ModelSim Simulation

In ModelSim transcript:
```tcl
do run_sim.do
```

---

## Author

**Dheepak**
- GitHub: [dheepak6381-bit](https://github.com/dheepak6381-bit)
- Workshop: RISC-V RV32I Processor Simulation with ModelSim

