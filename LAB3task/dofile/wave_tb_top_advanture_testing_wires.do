onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/DATAout
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/TrigR
add wave -noupdate -radix decimal /top_tb/DATAin
add wave -noupdate /top_tb/Ld
add wave -noupdate /top_tb/OPCin
add wave -noupdate /top_tb/One
add wave -noupdate /top_tb/Input
add wave -noupdate /top_tb/OPC2
add wave -noupdate /top_tb/Bin
add wave -noupdate /top_tb/Cout
add wave -noupdate /top_tb/OPC1
add wave -noupdate -radix decimal /top_tb/counter_out
add wave -noupdate -radix decimal /top_tb/opc_out
add wave -noupdate -radix decimal /top_tb/reg_b_out
add wave -noupdate -radix decimal /top_tb/reg_c_out
add wave -noupdate /top_tb/done
add wave -noupdate /top_tb/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141864 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1271616 ps}
