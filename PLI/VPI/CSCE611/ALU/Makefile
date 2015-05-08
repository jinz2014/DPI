INSTALL_DIR=/usr/local/3rdparty/mentor/modelsim661/modeltech/include/

# Compile the PLI code for the X86_64 operating system with -fPIC

alu : alu_vpi.c alu_C_model.c
	gcc -fPIC -c alu_C_model.c; \
	gcc -fPIC -c -I$(INSTALL_DIR) alu_vpi.c; \
	gcc -shared -Bsymbolic -o alu.sl alu_vpi.o alu_C_model.o; \
	vsim -do alu.do -c 

clean : 
	rm -rf *.log *.o *.sl *.wlf wlft* transcript work 
