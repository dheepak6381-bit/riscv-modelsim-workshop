# ==============================================================================
# ModelSim Simulation Script: RISC-V RV32I Processor
# Workshop: RISC-V Architecture & Simulation using ModelSim
# Author: Dheepak (github.com/dheepak6381-bit)
# ==============================================================================

# Quit any active simulation
quit -sim

# Create work library
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# Compile Verilog source files
vlog -work work ../src/alu_32bit.v
vlog -work work ../src/alu_control.v
vlog -work work ../src/control_unit.v
vlog -work work ../src/imm_gen.v
vlog -work work ../src/program_counter.v
vlog -work work ../src/register_file.v
vlog -work work ../src/instruction_memory.v
vlog -work work ../src/data_memory.v
vlog -work work ../src/riscv_top.v

# Compile Testbench
vlog -work work ../tb/riscv_tb.v

# Load simulation with full signal visibility
vsim -voptargs="+acc" work.riscv_tb

# Waveform Configuration
# ------------------------------------------------------------------------------
# System Signals
add wave -noupdate -divider {System Clock & Reset}
add wave -noupdate -color Cyan /riscv_tb/clk
add wave -noupdate -color Magenta /riscv_tb/rst_n

# Program Counter
add wave -noupdate -divider {Program Counter (Fetch)}
add wave -noupdate -radix hexadecimal -color Yellow /riscv_tb/uut/pc
add wave -noupdate -radix hexadecimal -color Yellow /riscv_tb/uut/pc_next
add wave -noupdate -radix hexadecimal /riscv_tb/uut/pc_plus_4
add wave -noupdate -radix hexadecimal /riscv_tb/uut/branch_target

# Instruction & Decode
add wave -noupdate -divider {Instruction Decode}
add wave -noupdate -radix hexadecimal -color Orange /riscv_tb/uut/instr
add wave -noupdate -radix binary /riscv_tb/uut/opcode
add wave -noupdate -radix unsigned /riscv_tb/uut/rd
add wave -noupdate -radix unsigned /riscv_tb/uut/rs1
add wave -noupdate -radix unsigned /riscv_tb/uut/rs2
add wave -noupdate -radix hexadecimal /riscv_tb/uut/imm_val

# Control Unit Signals
add wave -noupdate -divider {Control Signals}
add wave -noupdate -color Green /riscv_tb/uut/reg_write
add wave -noupdate /riscv_tb/uut/alu_src
add wave -noupdate /riscv_tb/uut/mem_read
add wave -noupdate /riscv_tb/uut/mem_write
add wave -noupdate -radix binary /riscv_tb/uut/mem_to_reg
add wave -noupdate /riscv_tb/uut/branch
add wave -noupdate /riscv_tb/uut/jump
add wave -noupdate -radix binary /riscv_tb/uut/alu_op
add wave -noupdate -radix binary /riscv_tb/uut/alu_ctrl

# Register File
add wave -noupdate -divider {Register File Ports}
add wave -noupdate -radix hexadecimal /riscv_tb/uut/reg_rdata1
add wave -noupdate -radix hexadecimal /riscv_tb/uut/reg_rdata2
add wave -noupdate -radix hexadecimal -color Cyan /riscv_tb/uut/reg_wdata

# ALU Execution
add wave -noupdate -divider {ALU Execution}
add wave -noupdate -radix hexadecimal /riscv_tb/uut/alu_in1
add wave -noupdate -radix hexadecimal /riscv_tb/uut/alu_in2
add wave -noupdate -radix hexadecimal -color Green /riscv_tb/uut/alu_result
add wave -noupdate /riscv_tb/uut/alu_zero

# Data Memory
add wave -noupdate -divider {Data Memory}
add wave -noupdate -radix hexadecimal /riscv_tb/uut/u_dmem/addr
add wave -noupdate -radix hexadecimal /riscv_tb/uut/u_dmem/wdata
add wave -noupdate -radix hexadecimal /riscv_tb/uut/u_dmem/rdata

# Monitored Registers
add wave -noupdate -divider {Monitored Registers (x1 - x15)}
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[1]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[2]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[3]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[4]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[5]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[6]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[7]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[8]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[9]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[10]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[11]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[12]
add wave -noupdate -radix hexadecimal /riscv_tb/uut/u_regfile/registers[13]
add wave -noupdate -radix hexadecimal /riscv_tb/uut/u_regfile/registers[14]
add wave -noupdate -radix decimal /riscv_tb/uut/u_regfile/registers[15]

# Run Simulation
run -all

# Zoom to fit
wave zoom full
