#
# Copyright 1991-2010 Mentor Graphics Corporation
#
# All Rights Reserved.
#
# THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
# PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
# LICENSE TERMS.
#
# Simple SystemVerilog DPI Example - Setup & simulation Tcl script
#
onbreak {resume}
onerror {break}

# log signals in database
#
if {[file exists wave.do]} {
  do wave.do
}

# run simulation
run -all

# configure wave window
# wave zoomfull
quit -f
