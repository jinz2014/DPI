/**********************************************************************
 * $alu example -- Verilog HDL shell module
 *
 * CSCE611 ALU C model, combinational logic version.
 *
 * Note: 
 *********************************************************************/
`timescale 1ns / 1ns
module alu(a_in, 
           b_in, 
           opcode, 
           shamt,
           result_out,
           zero_out, 
           overflow_out);

  input  [31:0] a_in, b_in;
  input   [3:0] opcode;
  input   [4:0] shamt;
  output [31:0] result_out;
  output        zero_out;
  output        overflow_out;

  integer       a, b;
  integer       result; 
  reg           zero, overflow;

  // convert real numbers to/from 64-bit vector port connections
  //always @(a_in) a  = $bitstoreal(a_in);
  //always @(b_in) b  = $bitstoreal(b_in);
  //assign result_out = $realtobits(result);
  
  always @(a_in) a  = a_in;
  always @(b_in) b  = b_in;
  assign result_out = result;
  assign overflow_out = overflow;
  assign zero_out = zero;

  //call the PLI application which interfaces to the C model
  initial
    $alu(a, b, opcode, shamt, result, zero, overflow);

endmodule
