INSTALL_DIR=/usr/local/3rdparty/mentor/modelsim661/modeltech/include/

# 1. Compile the PLI code for the X86_64 operating system

hello : hello.c
	gcc -fPIC -c -I$(INSTALL_DIR) hello.c; \
	gcc -shared -Bsymbolic -o hello.sl hello.o; \
	vsim -do hello.do -c 

clean : 
	rm -rf *.o *.sl *.wlf transcript work
