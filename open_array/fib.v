//
// Copyright 1991-2010 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - 2-state array access
// Notice that the array of Fibonacci values is allocated and stored in
// SystemVerilog, even though it is calculated in C. There is no way to
// allocate an array in C and reference // it in SystemVerilog.
//
`timescale 1ns / 1ns

/* Use the empty square brackets [] in the SystemVerilog
 * import statement to specify that you are passing an open array.*/
//import "DPI-C" context function void fib_oa(output bit [31:0] data[]);

typedef int unsigned mem_t;
mem_t mem[];


module test;

  import "DPI-C" context task ref_model ( inout mem_t m[] );
  export "DPI-C" task alloc_mem;
  task alloc_mem ( input int size );
  $display("SV: allocating new SV DA of size %0d", size);
  mem = new[size];
  endtask

  initial begin
  ref_model(mem);
  $display("SV: ref model finished, mem.size()=%0d", mem.size());
  foreach (mem[i]) $display("SV: mem[%0d]=%0d", i,mem[i]);
  end
endmodule
