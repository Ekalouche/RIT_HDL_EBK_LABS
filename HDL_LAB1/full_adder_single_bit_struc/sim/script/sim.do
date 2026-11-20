vlib work
vcom -93 -work work ../../src/full_adder_single_bit_str.vhd
vcom -93 -work work ../../src/and_gate.vhd
vcom -93 -work work ../../src/or_gate.vhd
vcom -93 -work work ../../src/xor_gate.vhd
vcom -93 -work work ../src/full_adder_single_bit_beh_tb.vhd
vsim -voptargs=+acc full_adder_single_bit_beh_tb
do wave.do
run 100 ns
