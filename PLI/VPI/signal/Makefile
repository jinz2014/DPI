INSTALL_DIR=/usr/local/3rdparty/mentor/modelsim661/modeltech/include/

# 1. Compile the PLI code for the X86_64 operating system

show_all_signals_1 : show_all_signals_1.c
	gcc -fPIC -c -I$(INSTALL_DIR) show_all_signals_1.c; \
	gcc -shared -Bsymbolic -o  show_all_signals_1.sl  show_all_signals_1.o; \
	vsim -do  show_all_signals_1.do -c 

clean : 
	rm -rf *.o *.sl *.wlf transcript work
