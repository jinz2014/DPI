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
#            Run C packages example ......... doit.sh run
#            Clean directory ................ doit.sh clean
#
if [ "$1" = "clean" ] ; then
    rm -f transcript *.wlf core* *.log workingExclude.cov
    rm -f *.dll *.exp *.lib *.obj *.sl *.o *.so
    rm -f vsim_stacktrace.vstf *.h
    rm -rf work
    exit 0
fi

if [ "$1" = "run" ] ; then
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
    echo ""
    echo "### NOTE: Running C packages example ..."
    echo ""
    vlog -sv test.sv
    vsim -c top -voptargs="+acc=r" -do sim.do
    exit 0
fi

echo ""
echo "### Help/Usage ..................... doit.sh"
echo "### Run cpackages example .......... doit.sh run"
echo "### Clean directory ................ doit.sh clean"
echo ""
