//typedef struct { int unsigned i; longint unsigned l; } num_u;
//num_u pipeline_outputs[2];
import "DPI-C" function int pipeline(
                                   input longint  sim_time,
                                   input int unsigned hw_in[16],
                                   input longint unsigned hw_out, 
                                   input int unsigned id, 
                                   input int unsigned dfp);


//
// If I dont want to calculate output delay by looking at the waveform
//
`define OUTPUT_DELAY [1:$]

module pipeline_TB;
  reg [31:0] in1, in2, in3, in4;
  reg clk;
  reg rst;
  reg en;
  wire [31:0] out1;
  wire [63:0] out2;
  wire [ 0:0] out1_valid, 
              out2_valid;

  parameter INPUTS_NU = 16;
  parameter OUTPUTS_NU = 2;
  parameter PORTS_NU=4;

  localparam TEST_NU = 2;
  localparam DP = 1, SP = 0;

  integer i, j, n;
  shortreal r;

  // data structure
  int dataQ[OUTPUTS_NU][$];     // queue to store/read incoming data

  //integer inputs[0:41]; // v2k
  int unsigned pipeline_inputs[OUTPUTS_NU][INPUTS_NU]; 
  longint unsigned pipeline_outputs[OUTPUTS_NU];

  logic [63:0] out[OUTPUTS_NU];
  logic out_valid[OUTPUTS_NU];


  // pipeline I/O I/F wrapper
  assign out_valid[0] = out1_valid;
  assign out_valid[1] = out2_valid;
  assign out[0] = {32'b0, out1};
  assign out[1] = out2;

  // push into all queues pipeline inputs driven by testbench
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

  // pop pipeline input data, and read pipeline output as C model stimuli
  always @ (negedge clk) begin
    for (i = 0; i < OUTPUTS_NU; i++) begin
      if (out_valid[i]) begin
        pipeline_outputs[i] <= out[i];
        for (j = 0; j < INPUTS_NU; j = j+PORTS_NU) begin
          pipeline_inputs[i][j+0] <= dataQ[i].pop_back();
          pipeline_inputs[i][j+1] <= dataQ[i].pop_back();
          pipeline_inputs[i][j+2] <= dataQ[i].pop_back();
          pipeline_inputs[i][j+3] <= dataQ[i].pop_back();
        end
      end
    end
  end

  property p_check_out1;
    @(posedge clk)
    (out1_valid) |-> (pipeline($time, pipeline_inputs[0], pipeline_outputs[0], 0, SP), 
    $display($time,,, "checked pipeline out1"));
  endproperty : p_check_out1
  assert property (p_check_out1);

  property p_check_out2;
    @(posedge clk)
    (out2_valid) |-> (pipeline($time, pipeline_inputs[1], pipeline_outputs[1], 1, DP),
    $display($time,,, "checked pipeline out2"));
  endproperty : p_check_out2
  assert property (p_check_out2);

  pipeline_hw pipeline_i (
    in1, in2, in3, in4,
    clk,
    rst,
    en,
    out1, 
    out2,
    out1_valid, 
    out2_valid
  );


  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    r   = 0.0;
    #20;
    rst = 0;

    repeat (5) @(posedge clk);

    repeat (TEST_NU) begin
      for (n = 0; n < INPUTS_NU / PORTS_NU; n=n+1) begin
        @(posedge clk);
        en = 1;
        in1 = $shortrealtobits(r+0.1);
        in2 = $shortrealtobits(r+0.2);
        in3 = $shortrealtobits(r+0.3);
        in4 = $shortrealtobits(r+0.4);
        r += 0.4;
      end
      @(posedge clk) en = 0;  // when en is low ?
      repeat (10) @(posedge clk);
    end

    #500;
    $finish;
  end
endmodule


// inputs in hex
// outputs in hex
module pipeline_hw (
  input [31:0] in1, in2, in3, in4,
  input clk,
  input rst,
  input en,
  output reg [31:0] out1, 
  output reg [63:0] out2,
  output reg [ 0:0] out1_valid = 1'b0,
  output reg [ 0:0] out2_valid = 1'b0
);

localparam DII=11, INPUTS_NU=16, PORTS_NU=4;
localparam DP = 1, SP = 0;
int unsigned inputs[16];       // pipeline inputs

reg packet = 0;
reg [1:0] cnt; // depends on inputs
integer i;
shortreal sum_f;
real sum_d;

// pipeline function (e.g. accumulation)
always @ (*) begin
  sum_f = 0; sum_d = 0; 
  if (packet) begin
    for (i = 0; i < INPUTS_NU; i = i + 1) begin
      sum_f = sum_f + $bitstoshortreal(inputs[i]);
      $display("HDLsim: %0t float input %0d %h(%f)", 
      $time, i, inputs[i], $bitstoshortreal(inputs[i]));
    end
    sum_d = sum_f;

    $display("HDLsim: %0t float sum %h(%f)", 
    $time, $shortrealtobits(sum_f), sum_f);

    $display("HDLsim: %0t double sum %h(%f)\n",
    $time, $realtobits(sum_d), sum_d);
  end
end

always @ (posedge clk) begin
  out1  <= #200 $shortrealtobits(sum_f); 
  out2  <= #200 $realtobits(sum_d);  
  out1_valid <= #200 packet; 
  out2_valid <=#200 packet;
end

always @ (posedge clk) begin
  if (rst) begin
    cnt    <= 0;
  end
  else if (en) begin
    case (cnt)
      4'd0:
      begin
        inputs[0] <= in1;
        inputs[1] <= in2;
        inputs[2] <= in3;
        inputs[3] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd1:
      begin
        inputs[4] <= in1;
        inputs[5] <= in2;
        inputs[6] <= in3;
        inputs[7] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd2:
      begin
        inputs[8] <= in1;
        inputs[9] <= in2;
        inputs[10] <= in3;
        inputs[11] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd3:
      begin
        inputs[12] <= in1;
        inputs[13] <= in2;
        inputs[14] <= in3;
        inputs[15] <= in4;
        // reset
        packet     <= 1;
        cnt        <= 0;
      end
      default begin
        packet     <= 0;
        cnt <= 0;
      end
    endcase
  end
  else begin
    packet <= 0;
  end
end


endmodule


