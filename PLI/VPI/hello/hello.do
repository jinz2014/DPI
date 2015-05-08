if {[file exists work]} {
	vdel -lib work -all
}

vlib work
vlog hello.v
vsim -pli hello.sl hello
run -all
quit -f
