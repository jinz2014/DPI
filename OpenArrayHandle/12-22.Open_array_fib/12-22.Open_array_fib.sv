//-----------------------------------------------------------------------------
// This code example can be shared freely as long as you keep
// this notice and give us credit. In the event of publication,
// the following notice is applicable:
//
// (C) COPYRIGHT 2006-2011 Chris Spear, Greg Tumbush.  All rights reserved
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Sample 12-22
// Shows sharing an open array between C and SystemVerilog

import "DPI-C" function void fib_oa(output bit [31:0] data[],
				    input int length);

program automatic test;
  localparam LENGTH = 20;
  bit [31:0] data[LENGTH], r;

  initial begin
    fib_oa(data, LENGTH);
    foreach (data[i]) begin
      $display(i,,data[i]);
      if (i > 2) begin
        if (data[i] != data[i-2] + data[i-1]) begin
          $display("ERROR: fib[%0d]=%0d, expected %0d", i, data[i], data[i-2] + data[i-1]);
          $finish;
        end
      end
    end
    $display("Success: Fib values matched expected");
end

endprogram
