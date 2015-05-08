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

import "DPI-C" context function chandle counter7_new();
import "DPI-C" context function void counter7 (input chandle inst,
                                               output bit [6:0] out,
                                               input bit [6:0] in,
                                               input bit reset, load);

program automatic test;
  // Test two instances of the counter
  initial begin
    bit [6:0] o1, o2, i1, i2;
    bit reset, load, clk1;

    // Points to storage in C 
    // (no storage conversion between the SV storage and C storage
    chandle inst1, inst2;   

    inst1 = counter7_new(); // set up counter and get the counter's handle
    inst2 = counter7_new();

    fork // counter7 manipulate its counter via the handle
      forever #10 clk1 = ~clk1;
      forever @(posedge clk1) begin
        counter7(inst1, o1, i1, reset, load);
        counter7(inst2, o2, i2, reset, load);
        //$display($time, "%b %b %b %b %b %b", reset, load, i1, o1, i2, o2);
      end
    join_none

    reset = 0;
    load = 0;
    i1 = 120;
    i2 = 10;
    @(negedge clk1);
    load = 1;
    @(negedge clk1);
    load = 0;
    #100;
    $finish;
  end

endprogram
