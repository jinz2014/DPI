module checker;
  wire         Debug = 1'b0;    // Debug message
  task check;
    input [31:0] a, b;
    input  [3:0] opcode;
    input  [4:0] shamt;
    input [31:0] cm_result, vm_result;
    input        cm_zero, vm_zero;
    input        cm_overflow, vm_overflow;
    begin

      if (Debug) begin
      $display("C   model --> At %t: result=%h\t zero=%b  overflow=%b  a=%h b=%h  opcode=%h  shamt=%h",
               $time, cm_result, cm_zero, cm_overflow, 
               a, b, opcode, shamt);

      $display("HDL model --> At %t: result=%h\t zero=%b  overflow=%b  a=%h b=%h  opcode=%h  shamt=%h",
               $time, vm_result, vm_zero, vm_overflow, 
               a, b, opcode, shamt);
      end

      if (cm_result != vm_result) begin
        $display("error: cm_result = %h <-> vm_result=%h", cm_result, vm_result); 
        $finish;
      end
      if (cm_zero != vm_zero) begin
        $display("error: cm_zero = %h <-> vm_zero=%h", cm_zero, vm_zero); 
        $finish;
      end
      if (cm_overflow != vm_overflow) begin
        $display("error: cm_overflow = %h <-> vm_overflow=%h", cm_overflow, vm_overflow); 
        $finish;
      end
    end
  endtask;
endmodule

