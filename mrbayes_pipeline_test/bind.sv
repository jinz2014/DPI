// bind syntax:
// module name/instance name; 
// program/module/interface name ;
// program/module/interface instance name ;
// i/o ports
bind mrbay_i testbench pipeline_testbench (
  .clk        (clk), 
  .rst        (rst), 
  .en         (go_in & ~stall_in),
  .in1        (p1_in), 
  .in2        (p2_in),
  .in3        (p3_in),
  .in4        (p4_in), 
  .bs0        (II1_in), 
  .bs1        (II2_in),
  .bs2        (II3_in),
  .bs3        (II4_in), 
  .norm       (Norm_in), 
  .out0       (mrbay_fmux12_out),
  .out1       (mrbay_fmux13_out),
  .out2       (mrbay_fmux14_out),
  .out3       (mrbay_fmux15_out),
  .out4       (mrbay_dtof1_out),
  .out5       (mrbay_fadd2_out),
  .out6       (mrbay_fmuld2_out),
  .out0_valid (mrbay_fmux12_out_rdy),
  .out1_valid (mrbay_fmux13_out_rdy),
  .out2_valid (mrbay_fmux14_out_rdy), 
  .out3_valid (mrbay_fmux15_out_rdy), 
  .out4_valid (mrbay_dtof1_out_rdy), 
  .out5_valid (mrbay_fadd2_out_rdy),
  .out6_valid (mrbay_fmuld2_out_rdy)
);


