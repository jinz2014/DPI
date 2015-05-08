worklib:
	vlib work

compile:  test.sv foreign.c
	vlog test.sv -dpiheader dpi_types.h

# -m32 or -m64
foreign: foreign.c
	gcc -m64 -I$(MTI_HOME)/include -fPIC -shared -g -o foreign.so foreign.c

optimize:
	vopt +acc test -o opt_test

sim:
	vsim opt_test -c -l log -sv_lib foreign

all: worklib compile foreign optimize sim

clean:
	rm -rf work transcript vsim.wlf foreign.so dpi_types.h
