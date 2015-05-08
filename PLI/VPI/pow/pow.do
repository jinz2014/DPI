if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vlog pow_test.v
vsim -pli pow.sl pow_test
run -all
quit -f
