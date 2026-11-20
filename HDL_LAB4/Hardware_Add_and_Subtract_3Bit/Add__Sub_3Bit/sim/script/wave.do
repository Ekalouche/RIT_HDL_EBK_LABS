
onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0010000" "9" -color "red",
    "7'b1111111" "Blank" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Add_Sub_3Bit_tb/DUT/clk
add wave -noupdate /Add_Sub_3Bit_tb/DUT/reset
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/a
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/b
add wave -noupdate /Add_Sub_3Bit_tb/DUT/add_btn
add wave -noupdate /Add_Sub_3Bit_tb/DUT/sub_btn
add wave -noupdate -radix States /Add_Sub_3Bit_tb/DUT/a_bcd
add wave -noupdate -radix States /Add_Sub_3Bit_tb/DUT/b_bcd
add wave -noupdate -radix States /Add_Sub_3Bit_tb/DUT/result_bcd
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/A_sync
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/B_sync
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/A_Pad
add wave -noupdate -radix unsigned /Add_Sub_3Bit_tb/DUT/B_Pad
add wave -noupdate /Add_Sub_3Bit_tb/DUT/Add_op
add wave -noupdate /Add_Sub_3Bit_tb/DUT/Sub_op
add wave -noupdate -radix binary /Add_Sub_3Bit_tb/DUT/Flag
add wave -noupdate -radix hexadecimal /Add_Sub_3Bit_tb/DUT/Result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2000 ns}
