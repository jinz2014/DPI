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
#            Run MUX81 example .............. doit.sh run
#            Clean directory ................ doit.sh clean
#
if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f *.dll *.exp *.lib *.obj *.sl *.o *.so
    rm -f vsim_stacktrace.vstf 
    rm -f *.txt
    rm -rf work
    exit 0
fi

if [ "$1" != "run" ] ; then
    echo ""
    echo "### Help/Usage ..................... doit.sh"
    echo "### Run MUX81 example .............. doit.sh run"
    echo "### Clean directory ................ doit.sh clean"
    echo ""
fi

# The rest of the script is "run"
#
# change top-level module name
# change test file name (assume there are cnt7.h, cnt7.c and cnt7.v files)
testname=pipeline
topname=mrbay_TB

#
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

PROJ_PATH="/share/jinz/Xilinx_synthesis/MyResearch/PipeGen"
LIB_PATH="$PROJ_PATH/vlib"
SIM_PATH="$PROJ_PATH/Modelsim"
# 
#SIM_OPTIONS='-t ns -voptargs="+acc=rn"'
SIM_OPTIONS="-t ns -voptargs=+acc"

SIM_LIB="-L /usr/local/3rdparty/mentor/xilinx_libs/xilinxcorelib_ver"


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
        CC="gcc -g -c -fPIC -Wall -std=c99 -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -g -c -m64 -fPIC -Wall -std=c99 -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m64 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    else
        CC="gcc -g -c -m32 -fPIC -Wall -std=c99 -I. -I$MTI_HOME/include"
        LD="gcc -shared -lm -m32 -Wl,-Bsymbolic -Wl,-export-dynamic -o "
    fi
    ;;
SunOS)
    if [ "$gccversion" = "2" ] ; then
        CC="gcc -g -c -fPIC -I. -I$MTI_HOME/include"
    elif [ $is64bit -ne 0 ] ; then
        CC="gcc -g -m64 -c -fPIC -I. -I$MTI_HOME/include"
    else
        CC="gcc -g -m32 -c -fPIC -I. -I$MTI_HOME/include"
    fi
    LD="/usr/ccs/bin/ld -Bsymbolic -G -o"
    ;;
Win*|CYGWIN_NT*)
    CC="cl -c -Ox -Oy -I $MTI_HOME/include "
    LD="link /DLL "
    ;;
*)
    echo "Script not configured for $platform, see User's manual."
    exit 0
    ;;
esac

echo ""
echo "### NOTE: Running $testname example ..."
echo ""
# dpi top
vlog -sv -dpiheader $testname.h $testname.v

# mrbayes
vcom -work work -explicit $LIB_PATH/float.vhd
vlog -work work $LIB_PATH/MUX.v 
vlog -work work $LIB_PATH/Register.v 
vlog -work work $LIB_PATH/counter.v 
vlog -work work $LIB_PATH/ShiftRegister.v 
vlog -work work $LIB_PATH/max.v 
vlog -work work $LIB_PATH/ROM.v 
vlog -work work $SIM_PATH/mrbay/ASAP4_mrbay/ASAP4_mrbay_HDL.v
vlog -sv -work work $SIM_PATH/mrbay/ASAP4_mrbay/ASAP4_mrbay_TB.v

# bind 
vlog -cuname bind_pkg -mfcu bind.sv

# c files
$CC $testname.c benchmark.c util.c

# select platform
case $platform in
Win*|CYGWIN_NT*)
    $LD $testname.obj  benchmark.obj util.o
    ;;
*)
    $LD $testname.so $testname.o benchmark.o util.o
    ;;
esac

# -sv_lib: shared lib name
vsim -c -assertdebug $SIM_LIB $SIM_OPTIONS -l log work.$topname bind_pkg -sv_lib $testname -do sim.do
exit 0

#
#+acc options
#a  Preserve PSL and SystemVerilog assertion and functional coverage data.
#Enables pass count logging in the Transcript window and assertion viewing in the
#Wave window. Also enables the complete functionality of vsim -assertdebug.
#If you do not specify +acc=a, the tool only transcripts assertion failure messages
#  and reports only failure counts in the assertion browser.
#  Note that if a PSL or SystemVerilog construct is being driven by a port signal,
#  vopt may replace that signal name with its higher-level driver. So in this case, if
#  604 ModelSim SE Reference Manual, v6.5c
#  Commands
#  vopt
#  you prefer the local port name, the +acc "p" option should also be specified (i.e.,
#  +acc=ap).
#  b  Enable access to bits of vector nets. This is necessary for PLI applications that
#  require handles to individual bits of vector nets. Also, some user interface
#  commands require this access if you need to operate on net bits.
#  c  Enable access to library cells. By default any Verilog module containing a
#  non-empty specify block may be optimized, and debug and PLI access may be
#  limited. This option keeps module cell visibility.
#  f 
#  Enable access to finite state machines.
#  l  Enable access to line number directives and process names.
#  m  Preserve the visibility of module, program, and interface instances.
#  n  Enable access to nets.
#  p  Enable access to ports. This disables the module inlining optimization, and is
#  necessary only if you have PLI applications that require access to port handles.
#  r  Enable access to registers (including memories, integer, time, and real types).
#  s  Enable access to system tasks.
#  t  Enable access to tasks and functions.
#  u  Enable access to primitive instances.
#  v  Enable access to variables, constants, and aliases in processes (VHDL design
#  units only) that would otherwise be merged due to optimizations. Disables an
#  optimization that automatically converts variables to constants.
#  +<selection>  enables access for specific Verilog design objects and/or regions,
#  optionally followed by ".", selection occurs recursively downward from the specified
#  module or instance. Multiple selections are allowed, with each separated by a "+"
#  (+acc=rn+top1+top2). If no selection is specified, then all modules are affected.
#  Ensure that you do not put a space between any <spec> arguments and the
#  +<selection> argument. You can use a path delimiter to select unique instances or
#  objects (+acc=mrp+/top/ul. or +acc=r+/top/myreg). If you specify a module name
#  (+acc=rn+Demux), pertinent objects in side the module are selected.
#  +<entity>[(architecture)]  enables access for all instances of the specified
