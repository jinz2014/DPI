/**********************************************************************
 * $scientific_alu example -- Verilog HDL test bench.
 *
 * Verilog test bench to test the $scientific_alu C model PLI
 * application.  This test uses the Scientific Alu as a combinational
 * logic device.
 *
 * For the book, "The Verilog PLI Handbook" by Stuart Sutherland
 *  Copyright 1999 & 2001, Kluwer Academic Publishers, Norwell, MA, USA
 *   Contact: www.wkap.il
 *  Example copyright 1998, Sutherland HDL Inc, Portland, Oregon, USA
 *   Contact: www.sutherland-hdl.com
 *********************************************************************/

`timescale 1ns / 1ns
module alu_test;

  reg   [4:0] opcode;
  wire        excep, err;
  real        a, b, result;
  wire [63:0] a_in, b_in, result_out;

  // convert real numbers to/from 64-bit vector port connections
  always @(result_out) result = $bitstoreal(result_out);
  assign a_in = $realtobits(a);
  assign b_in = $realtobits(b);

  alu i1 (a_in, b_in, opcode[3:0], result_out, excep, err);

  initial
    begin
      $display("");  //add some white space to output
      $timeformat(-9,0," ns",7);
      $monitor("At %t: result=%.2f \t excep=%b  err=%b  a=%.1f  b=%.1f  opcode=%h",
               $time, result, excep, err, a, b, opcode[3:0]);
      a = 16.0;
      b =  2.0;
      for (opcode=0; opcode<=15; opcode=opcode+1) #1;

      #10 $display("");
      $finish;
    end

endmodule

/*********************************************************************/
