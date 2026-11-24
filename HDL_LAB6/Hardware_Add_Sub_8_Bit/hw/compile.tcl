# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] Name your project here
set project_name "calculator"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name

set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name TOP_LEVEL_ENTITY Calculator
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] Include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/BCD.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer_8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/double_dabble.vhd
set_global_assignment -name VHDL_FILE ../../src/memory.vhd
set_global_assignment -name VHDL_FILE ../../src/alu.vhd
set_global_assignment -name VHDL_FILE ../../src/FSM.vhd
set_global_assignment -name VHDL_FILE ../../src/Calculator.vhd

# Clock and pushbuttons
set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset_n
set_location_assignment PIN_Y16  -to execute

# State LEDs
set_location_assignment PIN_V16 -to {led[0]}
set_location_assignment PIN_W16 -to {led[1]}
set_location_assignment PIN_V17 -to {led[2]}
set_location_assignment PIN_V18 -to {led[3]}
set_location_assignment PIN_W17 -to {led[4]}

# 8-bit calculator input switches
set_location_assignment PIN_AB12 -to {switch[0]}
set_location_assignment PIN_AC12 -to {switch[1]}
set_location_assignment PIN_AF9  -to {switch[2]}
set_location_assignment PIN_AF10 -to {switch[3]}
set_location_assignment PIN_AD11 -to {switch[4]}
set_location_assignment PIN_AD12 -to {switch[5]}
set_location_assignment PIN_AE11 -to {switch[6]}
set_location_assignment PIN_AC9  -to {switch[7]}

# Operation selection switches
set_location_assignment PIN_AD10 -to {op[0]}
set_location_assignment PIN_AE12 -to {op[1]}

# HEX0 - Ones digit
set_location_assignment PIN_AE26 -to {bcd_0[0]}
set_location_assignment PIN_AE27 -to {bcd_0[1]}
set_location_assignment PIN_AE28 -to {bcd_0[2]}
set_location_assignment PIN_AG27 -to {bcd_0[3]}
set_location_assignment PIN_AF28 -to {bcd_0[4]}
set_location_assignment PIN_AG28 -to {bcd_0[5]}
set_location_assignment PIN_AH28 -to {bcd_0[6]}

# HEX1 - Tens digit
set_location_assignment PIN_AJ29 -to {bcd_1[0]}
set_location_assignment PIN_AH29 -to {bcd_1[1]}
set_location_assignment PIN_AH30 -to {bcd_1[2]}
set_location_assignment PIN_AG30 -to {bcd_1[3]}
set_location_assignment PIN_AF29 -to {bcd_1[4]}
set_location_assignment PIN_AF30 -to {bcd_1[5]}
set_location_assignment PIN_AD27 -to {bcd_1[6]}

# HEX2 - Hundreds digit
set_location_assignment PIN_AB23 -to {bcd_2[0]}
set_location_assignment PIN_AE29 -to {bcd_2[1]}
set_location_assignment PIN_AD29 -to {bcd_2[2]}
set_location_assignment PIN_AC28 -to {bcd_2[3]}
set_location_assignment PIN_AD30 -to {bcd_2[4]}
set_location_assignment PIN_AC29 -to {bcd_2[5]}
set_location_assignment PIN_AC30 -to {bcd_2[6]}

# Compile the project
execute_flow -compile
project_close