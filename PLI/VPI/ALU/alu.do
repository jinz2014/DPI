if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vlog alu_test.v
vlog alu_shell.v
vsim -pli alu.sl alu_test
run -all
quit -f
