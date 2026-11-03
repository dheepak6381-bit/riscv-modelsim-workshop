# ==============================================================================
# ModelSim Simulation Script: 8-Bit Full Adder
# ==============================================================================
quit -sim

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

vlog -work work full_adder_8bit.v
vlog -work work full_adder_8bit_tb.v

vsim -voptargs="+acc" work.full_adder_8bit_tb

add wave -noupdate -radix unsigned /full_adder_8bit_tb/A
add wave -noupdate -radix unsigned /full_adder_8bit_tb/B
add wave -noupdate /full_adder_8bit_tb/Cin
add wave -noupdate -radix unsigned -color Cyan /full_adder_8bit_tb/Sum
add wave -noupdate -color Magenta /full_adder_8bit_tb/Cout

run -all
wave zoom full
