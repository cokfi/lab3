onerror {resume}
add list -width 16 /tbcontrol/clk
add list /tbcontrol/Input
add list /tbcontrol/One
add list /tbcontrol/OPCin
add list /tbcontrol/OPC2
add list /tbcontrol/OPC1
add list /tbcontrol/Ld
add list /tbcontrol/Bin
add list /tbcontrol/Cout
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
