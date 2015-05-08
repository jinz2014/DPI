if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vlog ALU.v
vlog alu_shell.v
vlog checker.v
vlog alu_test.v
vsim -pli alu.sl -l alu_test.log alu_test 
run -all
quit -f
