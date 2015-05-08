onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipeline_TB/INPUTS_NU
add wave -noupdate /pipeline_TB/PORTS_NU
add wave -noupdate /pipeline_TB/TEST_NU
add wave -noupdate /pipeline_TB/DP
add wave -noupdate /pipeline_TB/SP
add wave -noupdate /pipeline_TB/in1
add wave -noupdate /pipeline_TB/in2
add wave -noupdate /pipeline_TB/in3
add wave -noupdate /pipeline_TB/in4
add wave -noupdate /pipeline_TB/clk
add wave -noupdate /pipeline_TB/rst
add wave -noupdate /pipeline_TB/en
add wave -noupdate /pipeline_TB/out1
add wave -noupdate /pipeline_TB/out2
add wave -noupdate /pipeline_TB/out1_valid
add wave -noupdate /pipeline_TB/out2_valid
add wave -noupdate /pipeline_TB/i
add wave -noupdate /pipeline_TB/pipeline_inputs
add wave -noupdate /pipeline_TB/dataQsize
add wave -noupdate /pipeline_TB/read_packet
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ns} 0}
configure wave -namecolwidth 287
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {279 ns}
