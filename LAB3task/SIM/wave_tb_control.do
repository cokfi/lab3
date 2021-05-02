onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbcontrol/rst
add wave -noupdate /tbcontrol/clk
add wave -noupdate -color Blue /tbcontrol/Input
add wave -noupdate -color Blue /tbcontrol/One
add wave -noupdate -color Yellow /tbcontrol/OPCin
add wave -noupdate -color Yellow /tbcontrol/OPC2
add wave -noupdate -color Yellow /tbcontrol/OPC1
add wave -noupdate -color Firebrick /tbcontrol/Ld
add wave -noupdate -color Firebrick /tbcontrol/Bin
add wave -noupdate -color Firebrick /tbcontrol/Cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76224 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
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
WaveRestoreZoom {44145 ps} {629361 ps}
