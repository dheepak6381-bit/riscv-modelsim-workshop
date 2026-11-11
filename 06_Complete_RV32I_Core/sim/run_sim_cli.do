# ==============================================================================
# ModelSim Batch/CLI Simulation Script: RISC-V RV32I Processor
# Workshop: RISC-V Architecture & Simulation using ModelSim
# Author: Dheepak (github.com/dheepak6381-bit)
# ==============================================================================

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

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

vsim -c -voptargs="+acc" work.riscv_tb -do "run -all; quit -f"
