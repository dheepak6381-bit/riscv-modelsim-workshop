# ==============================================================================
# ModelSim Simulation Script: D Flip-Flop
# Author: Dheepak (github.com/dheepak6381-bit)
# ==============================================================================
quit -sim

if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# Compile Verilog and SystemVerilog versions
vlog -work work -sv systemverilog/d_flip_flop.sv
vlog -work work -sv systemverilog/d_flip_flop_tb.sv

vsim -voptargs="+acc" work.d_flip_flop_tb

add wave -noupdate -color Cyan /d_flip_flop_tb/clk
add wave -noupdate -color Magenta /d_flip_flop_tb/reset
add wave -noupdate -color Yellow /d_flip_flop_tb/d
add wave -noupdate -color Green /d_flip_flop_tb/q
add wave -noupdate /d_flip_flop_tb/q_bar

run -all
wave zoom full

