onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipeline_TB/INPUTS_NU
add wave -noupdate /pipeline_TB/PORTS_NU
add wave -noupdate /pipeline_TB/TEST_NU
add wave -noupdate /pipeline_TB/DP
add wave -noupdate /pipeline_TB/SP
add wave -noupdate -radix unsigned /pipeline_TB/in1
add wave -noupdate -radix unsigned /pipeline_TB/in2
add wave -noupdate -radix unsigned /pipeline_TB/in3
add wave -noupdate -radix unsigned /pipeline_TB/in4
add wave -noupdate -radix unsigned /pipeline_TB/clk
add wave -noupdate -radix unsigned /pipeline_TB/rst
add wave -noupdate -radix unsigned /pipeline_TB/en
add wave -noupdate -radix unsigned /pipeline_TB/out1
add wave -noupdate -radix unsigned /pipeline_TB/out2
add wave -noupdate -radix unsigned /pipeline_TB/out1_valid
add wave -noupdate -radix unsigned /pipeline_TB/out2_valid
add wave -noupdate -radix unsigned -subitemconfig {{/pipeline_TB/pipeline_inputs[0]} {-radix unsigned} {/pipeline_TB/pipeline_inputs[1]} {-radix unsigned}} /pipeline_TB/pipeline_inputs
add wave -noupdate -radix hexadecimal -subitemconfig {{/pipeline_TB/pipeline_outputs[0]} {-radix hexadecimal} {/pipeline_TB/pipeline_outputs[1]} {-radix hexadecimal}} /pipeline_TB/pipeline_outputs
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out1
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2
add wave -noupdate /pipeline_TB/pipeline_i/out1_valid
add wave -noupdate /pipeline_TB/pipeline_i/out2_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {332 ns} 0}
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
WaveRestoreZoom {212 ns} {900 ns}
