rm -rf work
vlib work
vlog counter.sv 
vlog check.sv
vlog tb.sv
vlog -cuname bind_pkg -mfcu bind.sv
vsim -c testbench bind_pkg
run -all
quit -f
