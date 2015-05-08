import "DPI-C" function int pipeline(input longint  sim_time,
                                     input int unsigned      test_in[44], // 32-bit
                                     input longint unsigned  hw_out, 
                                     input longint unsigned  bs0,    // 64-bit
                                     input longint unsigned  bs1,
                                     input longint unsigned  bs2,
                                     input longint unsigned  bs3,
                                     input bit               norm,
                                     input int unsigned      id, 
                                     input int unsigned      dfp);


//
// output delay 
//
`define OUTPUT_DELAY [0:$]

module testbench (
   
  input clk,
  input rst,
  input en,
  input [31:0] in1, in2, in3, in4,
  input [63:0] bs0, bs1, bs2, bs3,
  input norm,
  input [31:0] out0, out1, out2, out3, out4, out5, 
  input [63:0] out6,
  input [ 0:0] out0_valid, out1_valid, out2_valid, 
               out3_valid, out4_valid, out5_valid, out6_valid
);

  parameter PHY_PORTS_NU=4;
  parameter DII         = 11;
  parameter INPUTS_NU   = DII * PHY_PORTS_NU;
  parameter OUTPUTS_NU  = 7;


  integer i, j;

  int dataQ[OUTPUTS_NU][$];     // queue to store/read incoming data

  int unsigned     sw_pipeline_inputs[OUTPUTS_NU][INPUTS_NU];
  longint unsigned hw_pipeline_outputs[OUTPUTS_NU];

  //
  // pipeline I/O I/F
  //
  logic [63:0] out           [OUTPUTS_NU];
  logic        out_valid     [OUTPUTS_NU];
  int unsigned out_data_width[OUTPUTS_NU] = '{0,0,0,0,0,0,1};  // 1: double

  assign out_valid[0] = out0_valid;
  assign out_valid[1] = out1_valid;
  assign out_valid[2] = out2_valid;
  assign out_valid[3] = out3_valid;
  assign out_valid[4] = out4_valid;
  assign out_valid[5] = out5_valid;
  assign out_valid[6] = out6_valid;

  assign out[0] = {32'b0, out0};
  assign out[1] = {32'b0, out1};
  assign out[2] = {32'b0, out2};
  assign out[3] = {32'b0, out3};
  assign out[4] = {32'b0, out4};
  assign out[5] = {32'b0, out5};
  assign out[6] = out6;

  //
  // push into all queues pipeline inputs driven by testbench
  //
  always @ (negedge clk)
    if (rst) begin
      for (i = 0; i < OUTPUTS_NU; i++)
        dataQ[i] <= {};
    end
    else if (en) begin
      for (i = 0; i < OUTPUTS_NU; i++) begin
        dataQ[i].push_front(in1);
        dataQ[i].push_front(in2);
        dataQ[i].push_front(in3);
        dataQ[i].push_front(in4);
      end
    end

  //
  // pop pipeline input data, and read pipeline output as C model stimuli
  //
  always @ (negedge clk) begin
    for (i = 0; i < OUTPUTS_NU; i++) begin
      if (out_valid[i]) begin
        hw_pipeline_outputs[i] <= out[i];
        for (j = 0; j < INPUTS_NU; j = j+PHY_PORTS_NU) begin
          sw_pipeline_inputs[i][j+0] <= dataQ[i].pop_back();
          sw_pipeline_inputs[i][j+1] <= dataQ[i].pop_back();
          sw_pipeline_inputs[i][j+2] <= dataQ[i].pop_back();
          sw_pipeline_inputs[i][j+3] <= dataQ[i].pop_back();
        end
      end
    end
  end


  //--------------------------------------------------------------------------------
  //--------------------------------------------------------------------------------
genvar n;
generate 
  for (n = 0; n < OUTPUTS_NU; n=n+1) begin: gen_property
    property p_check_out;
      @(posedge clk)
      (out_valid[n] |-> pipeline($time, sw_pipeline_inputs[n], 
      hw_pipeline_outputs[n], bs0, bs1, bs2, bs3, norm, 
      n, out_data_width[n]));
    endproperty : p_check_out
    assert property (p_check_out);
  end
endgenerate

endmodule


