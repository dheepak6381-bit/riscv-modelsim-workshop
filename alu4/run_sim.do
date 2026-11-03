# ==============================================================================
# ModelSim Simulation Script: 4-Bit ALU
# ==============================================================================
quit -sim

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

vlog -work work alu4.v
vlog -work work alu4_tb.v

vsim -voptargs="+acc" work.alu4_tb

add wave -noupdate -radix hexadecimal /alu4_tb/A
add wave -noupdate -radix hexadecimal /alu4_tb/B
add wave -noupdate -radix binary /alu4_tb/opcode
add wave -noupdate -radix hexadecimal -color Cyan /alu4_tb/result
add wave -noupdate -color Magenta /alu4_tb/carry_borrow
add wave -noupdate -color Yellow /alu4_tb/zero

run -all
wave zoom full
