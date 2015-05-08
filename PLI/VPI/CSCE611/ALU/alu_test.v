/**********************************************************************
 * Top level Verilog HDL test bench.
 *
 * Compare the ALU HDL model and C model
 *
 * Contact: jinz@email.sc.edu
 *********************************************************************/

`timescale 1ns / 1ns
module alu_test;

  reg  [31:0] a;
  reg  [31:0] b;
  reg   [4:0] opcode;
  reg   [5:0] shamt;
  wire [31:0] cm_result, vm_result;
  wire        cm_zero, vm_zero;
  wire        cm_overflow, zm_overflow;

  always @ (*) begin
    #1
    checker0.check(
      a, b, opcode[3:0], shamt[4:0], cm_result, vm_result, 
      cm_zero, vm_zero, cm_overflow, vm_overflow);
  end

  // ALU checker
  checker checker0();

  // ALU C reference model
  alu alu0 (a, b, opcode[3:0],shamt[4:0], cm_result, cm_zero, cm_overflow);

  // ALU Verilog model
  ALU alu1 (a, b, opcode[3:0], shamt[4:0], vm_result, vm_zero, vm_overflow);

  initial
    begin: gen_stimulus
      $timeformat(-9,0," ns",7);
      repeat(1000) begin
        a = $random;
        b = $random;
        for (opcode = 0; opcode <= 15; opcode = opcode + 1) begin
          if (opcode >= 12) begin
            for (shamt = 0; shamt <= 31; shamt = shamt + 1) #2;
          end
          else begin
            #2;
          end
        end
      end
     
      #10 $display("");
      $finish;
    end

endmodule

/*********************************************************************/
