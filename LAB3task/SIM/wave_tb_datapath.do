onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbdatapath/clk
add wave -noupdate -color Blue /tbdatapath/Input
add wave -noupdate -color Blue /tbdatapath/One
add wave -noupdate -color Yellow /tbdatapath/OPCin
add wave -noupdate -color Yellow /tbdatapath/OPC2
add wave -noupdate -color Yellow /tbdatapath/OPC1
add wave -noupdate -color Yellow /tbdatapath/Ld
add wave -noupdate -color Yellow /tbdatapath/Bin
add wave -noupdate -color Yellow /tbdatapath/Cout
add wave -noupdate -color Cyan -radix decimal /tbdatapath/DATAin
add wave -noupdate -color {Dark Green} -radix decimal /tbdatapath/DATAout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {1024 ns}
