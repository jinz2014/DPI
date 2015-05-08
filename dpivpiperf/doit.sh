#!/bin/sh
#
# Copyright 1991-2010 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
# PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
# LICENSE TERMS.
#
# Simple SystemVerilog DPI Example - Simulation shell script
#
# Usage:     Help/usage ..................... doit.sh
#            Run DPI/VPI Perf example ....... doit.sh run
#            Clean directory ................ doit.sh clean
#
# NOTE: On win32, run this script in a cygwin or MKS shell.
#
if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f *.dll *.exp *.lib *.obj *.sl *.o *.so
    rm -f vsim_stacktrace.vstf *.h
    rm -rf work
    exit 0
fi

if [ "$1" != "run" ] ; then
    echo ""
    echo "### Help/Usage ..................... doit.sh"
    echo "### Run DPI VPI Perf example ....... doit.sh run"
    echo "### Clean directory ................ doit.sh clean"
    echo ""
fi

# The rest of the script is "run"
rm -rf work
vlib work
if [ $? -ne 0 ]; then
    echo "ERROR: Couldn't run vlib. Make sure \$PATH is set correctly."
    exit 0
fi
if [ -z "$MTI_HOME" ] ; then
    echo "ERROR: Environment variable MTI_HOME is not set"
    exit 0
fi
platform=`uname`
`vsim -version | grep "64 vsim" > /dev/null`
if [ $? -eq 0 ]; then
    is64bit=1
else
    is64bit=0
fi
rm -f *.o *.dll *.so

case $platform in
Linux)
    gccversion=`gcc -dumpversion | awk -F. '{print $1}'`
    machine=`uname -m`
    if [ "$gccversion" = "2" -o "$machine" = "ia64" ] ; then
        CC="gcc -O4 -c -fPIC -Wall -ansi -pedantic -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -O4 -c -m64 -fPIC -Wall -ansi -pedantic -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m64 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    else
        CC="gcc -O4 -c -m32 -fPIC -Wall -ansi -pedantic -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m32 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    fi
    ;;
SunOS)
    if [ "$gccversion" = "2" ] ; then
        CC="gcc -O4 -c -fPIC -I. -I$MTI_HOME/include"
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -O4 -m64 -c -fPIC -I. -I$MTI_HOME/include"
    else
        CC="gcc -O4 -m32 -c -fPIC -I. -I$MTI_HOME/include"
    fi
    LD="/usr/ccs/bin/ld -Bsymbolic -G -o"
    ;;
Win*|CYGWIN_NT*)
    CC="cl -c -Ox -Oy -I $MTI_HOME/include "
    LD="link /DLL $MTI_HOME/win32/mtipli.lib"
    ;;
*)
    echo "Script not configured for $platform, see User's manual."
    exit 0
    ;;
esac

echo ""
echo "### NOTE: Running DPI/VPI performance comparison example ..."
echo ""
vlog -sv -dpiheader dpi_adder.h dpi_adder.v vpi_adder.v
$CC dpi_adder.c
$CC vpi_adder.c
case $platform in
Win*|CYGWIN_NT*)
    $LD dpi_adder.obj 
    $LD vpi_adder.obj 
    ext=dll
    ;;
*)
    $LD dpi_adder.so dpi_adder.o
    $LD vpi_adder.so vpi_adder.o
    ext=so
    ;;
esac

# Run the DPI version
/usr/bin/time vsim -vopt -voptargs="-O5" dpi_adder -sv_lib dpi_adder -c -do "run -all; quit -f"
diff results.txt results.ref

# Run the VPI version
/usr/bin/time vsim -vopt -no_autoacc -voptargs="-O5 +acc=r" vpi_adder -pli vpi_adder.$ext -c -do "run -all; quit -f"
diff results.txt results.ref
exit 0
