worklib:
	vlib work

compile:  test.sv foreign.c
	vlog test.sv -dpiheader dpi_types.h 

foreign:  foreign.c
	gcc -I$(MTI_HOME)/include -fPIC -m32 -shared -g -o foreign.so foreign.c
  
optimize:
	vopt +acc test -o opt_test

sim:
	vsim opt_test -sv_lib foreign -c -l log

all: worklib compile foreign optimize sim

clean:
	rm -rf work transcript vsim.wlf foreign.so dpi_types.h

