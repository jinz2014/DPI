//
// Copyright 1991-2010 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - Verilog test module for 8-to-1 MUX
//
`timescale 1ns / 1ns

import "DPI-C" context function chandle counter_new(input int mask);

import "DPI-C" context function void counter ( input  chandle inst,
                                               output int count,
                                               input  int init_val,
                                               input  bit reset, load);

program automatic test;
  // Test two instances of the counter
  initial begin
    int o1, o2, i1, i2;
    bit reset, load, clk1;

    // Points to storage in C 
    // (no storage conversion between the SV storage and C storage
    chandle inst1, inst2;   

    // initialize modulo counter 
    // get the counter's handle
    inst1 = counter_new(8'hff); 
    inst2 = counter_new(4'hf);

    fork // counter manipulate its counter using DPI 
      forever #10 clk1 = ~clk1;
      forever @(posedge clk1) begin
        counter(inst1, o1, i1, reset, load);
        counter(inst2, o2, i2, reset, load);
      end
    join_none

    reset = 0;
    load = 0;
    i1 = 250;
    i2 = 10;
    @(negedge clk1);
    load = 1;
    @(negedge clk1);
    load = 0;
    #200;
    $finish;
  end

endprogram
