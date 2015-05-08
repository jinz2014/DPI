onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mrbay_TB/clk
add wave -noupdate -radix hexadecimal /mrbay_TB/rst
add wave -noupdate -radix hexadecimal /mrbay_TB/p1_in
add wave -noupdate -radix hexadecimal /mrbay_TB/p2_in
add wave -noupdate -radix hexadecimal /mrbay_TB/p3_in
add wave -noupdate -radix hexadecimal /mrbay_TB/p4_in
add wave -noupdate -radix hexadecimal /mrbay_TB/II1_in
add wave -noupdate -radix hexadecimal /mrbay_TB/II2_in
add wave -noupdate -radix hexadecimal /mrbay_TB/II3_in
add wave -noupdate -radix hexadecimal /mrbay_TB/II4_in
add wave -noupdate -radix hexadecimal /mrbay_TB/Norm_in
add wave -noupdate -radix hexadecimal /mrbay_TB/stall_in
add wave -noupdate -radix hexadecimal /mrbay_TB/go_in
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux12_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux12_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux13_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux13_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux14_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux14_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux15_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmux15_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_dtof1_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_dtof1_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fadd2_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fadd2_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmuld2_out
add wave -noupdate -radix hexadecimal /mrbay_TB/mrbay_fmuld2_out_rdy
add wave -noupdate -radix hexadecimal /mrbay_TB/res
add wave -noupdate -radix hexadecimal /pipeline_v_unit::pipeline/hw_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9239 ns} 0}
configure wave -namecolwidth 177
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
WaveRestoreZoom {8792 ns} {9098 ns}
