onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/DII
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/INPUTS_NU
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/PORTS_NU
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/DP
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/SP
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/in1
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/in2
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/in3
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/in4
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/clk
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/rst
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/en
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out1
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out1_valid
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2_valid
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/pipeline_inputs
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/packet
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/cnt
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/en_r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/i
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/sum
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out1_r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2_r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2_2r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out1_valid_r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2_valid_r
add wave -noupdate -radix hexadecimal /pipeline_TB/pipeline_i/out2_valid_2r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {82 ns}
