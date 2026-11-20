# Run with: quartus_sh -t compile.tcl
# Place this script beside the four VHDL files, or in a scripts
# folder beside a ../src folder containing the VHDL files.
set script_dir [file dirname [file normalize [info script]]]
set project_name "counter"
set source_files {}
foreach filename {Sum_register.vhd generic_counter.vhd generic_adder_beh.vhd seven_seg.vhd} {
    set source_path [file join $script_dir $filename]
    if {![file exists $source_path]} {
        set source_path [file normalize [file join $script_dir .. src $filename]]
    }
    if {![file exists $source_path]} {
        error "Cannot find $filename. Place the VHDL files beside this script or in ../src."
    }
    lappend source_files $source_path
}

load_package flow
file mkdir [file join $script_dir project]
cd [file join $script_dir project]
project_new $project_name -overwrite

set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name TOP_LEVEL_ENTITY sum_register
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files
foreach source_path $source_files {
    set_global_assignment -name VHDL_FILE $source_path
}

# 50 MHz clock: CLOCK_50
set_location_assignment PIN_AF14 -to clk_50_mhz
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_50_mhz

# SW0: ON asserts the active-high reset; OFF lets the counter run.
set_location_assignment PIN_AB12 -to reset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to reset

# HEX0, using the supplied board assignments.
set_location_assignment PIN_AE26 -to {seven_seg_out[0]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[0]}
set_location_assignment PIN_AE27 -to {seven_seg_out[1]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[1]}
set_location_assignment PIN_AE28 -to {seven_seg_out[2]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[2]}
set_location_assignment PIN_AG27 -to {seven_seg_out[3]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[3]}
set_location_assignment PIN_AF28 -to {seven_seg_out[4]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[4]}
set_location_assignment PIN_AG28 -to {seven_seg_out[5]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[5]}
set_location_assignment PIN_AH28 -to {seven_seg_out[6]}
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to {seven_seg_out[6]}

export_assignments
execute_flow -compile
project_close
