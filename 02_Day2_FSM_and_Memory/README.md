# Day 2: Finite State Machines & Memory Systems

**Author:** Dheepak ([@dheepak6381-bit](https://github.com/dheepak6381-bit))  
**Repository:** [https://github.com/dheepak6381-bit/riscv-modelsim-workshop](https://github.com/dheepak6381-bit/riscv-modelsim-workshop)

---

## Overview

This module contains practical FSM controllers and memory storage elements used in digital systems and processor control logic.

### Directory Structure & Modules

```
02_Day2_FSM_and_Memory/
├── 2.1_sequence_detector/
│   ├── seq_mealy.v            # Mealy FSM (detects '1011' with overlap)
│   ├── seq_moore.v            # Moore FSM (detects '1011' with overlap)
│   ├── seq_tb.v               # Sequence detector testbench
│   └── 2.1 sequence.png       # Simulation waveform screenshot
├── 2.2_vending/
│   ├── vending.v              # Vending machine controller (dispense, change, cancel)
│   ├── vending_tb.v           # Vending machine testbench
│   └── 2.2 vending machine.png# Simulation waveform screenshot
├── 2.3_fifo/
│   ├── fifo.v                 # Synchronous FIFO (16 depth x 8-bit width)
│   ├── fifo_tb.v              # FIFO testbench with full/empty edge checks
│   └── 2.3fifo.png            # Simulation waveform screenshot
├── 2.4_design_review/
│   └── Design_Review.txt      # Design review analysis & timing notes
├── 2.5_traffic/
│   ├── traffic.v              # Traffic light controller with pedestrian request latching
│   ├── traffic_tb.v           # Traffic controller testbench
│   └── 2.5traffic controller.png # Simulation waveform screenshot
├── 2.6_atm/
│   ├── atm.v                  # ATM controller FSM (PIN verification, withdrawal, balance)
│   ├── atm_tb.v               # ATM testbench
│   └── ATM.vcd                # Value change dump waveform
├── 2.7_washing_machine_fsm/
│   ├── washing.sv             # SystemVerilog washing machine controller FSM
│   └── washing_tb.sv          # SystemVerilog testbench
└── README.md
```

### Module Specifications

1. **2.1 Sequence Detector (`seq_mealy.v`, `seq_moore.v`)**:
   - Pattern: `1011` with overlap detection.
   - Mealy: Outputs asserted combinationally on receiving the final '1'.
   - Moore: Outputs asserted synchronously in the detect state one clock cycle later.

2. **2.2 Vending Machine (`vending.v`)**:
   - Accepts coin inputs, tracks credit balance, dispenses item with change, supports cancel/refund.

3. **2.3 Synchronous FIFO (`fifo.v`)**:
   - 16 entries $\times$ 8 bits with status flags (`full`, `empty`, `half-full`).

4. **2.5 Traffic Light Controller (`traffic.v`)**:
   - Manages Green-Yellow-Red vehicle light states with pedestrian crossing service logic.

5. **2.6 ATM Controller (`atm.v`)**:
   - State-driven PIN authentication, balance inquiry, and cash withdrawal management.

6. **2.7 Washing Machine Controller (`washing.sv`)**:
   - Modern SystemVerilog FSM modeling soak, wash, rinse, and spin cycles with safety interlocks.

