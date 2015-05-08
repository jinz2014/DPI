INSTALL_DIR=/usr/local/3rdparty/mentor/modelsim661/modeltech/include/

# 1. Compile the PLI code for the X86_64 operating system

pow : pow.c
	gcc -fPIC -c -I$(INSTALL_DIR) pow.c; \
	gcc -shared -Bsymbolic -o pow.sl pow.o; \
	vsim -do pow.do -c 

clean : 
	rm -rf *.o *.sl *.wlf transcript work
