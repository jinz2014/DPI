//
// Copyright 1991-2010 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - 4-state array access
// Notice that the array of Fibonacci values is allocated and stored in
// SystemVerilog, even though it is calculated in C. There is no way to
// allocate an array in C and reference // it in SystemVerilog.
//
`timescale 1ns / 1ns

import "DPI-C" context function void fib(output logic [31:0] data[20]);

program automatic test;
  logic [31:0] data[20];
  initial begin
    fib(data); // call c routine
    foreach (data[i]) $display(i,,data[i]);
  end
endprogram
