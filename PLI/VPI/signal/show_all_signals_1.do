if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vlog show_all_signals_1_test.v
vsim -pli  show_all_signals_1.sl top
run -all
quit -f
