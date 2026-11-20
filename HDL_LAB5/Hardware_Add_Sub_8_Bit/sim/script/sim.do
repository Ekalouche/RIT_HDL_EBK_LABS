vlib work
vcom -93 -work work ../../src/BCD.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/synchronizer_3bit.vhd
vcom -93 -work work ../../src/Pader.vhd
vcom -93 -work work ../../src/Operator.vhd
vcom -93 -work work ../../src/add_sub.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/Add_Sub_3Bit.vhd
vcom -93 -work work ../src/Add_Sub_3Bit_tb.vhd
vsim -voptargs=+acc work.Add_Sub_3Bit_tb
do wave.do
run -all
