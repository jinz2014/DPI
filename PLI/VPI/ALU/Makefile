INSTALL_DIR=/usr/local/3rdparty/mentor/modelsim661/modeltech/include/

# 1. Compile the PLI code for the X86_64 operating system

alu : alu_vpi.c
	gcc -fPIC -c -I$(INSTALL_DIR) alu_vpi.c; \
	gcc -shared -Bsymbolic -o alu.sl alu_vpi.o; \
	vsim -do alu.do -c 

clean : 
	rm -rf *.o *.sl *.wlf transcript work
