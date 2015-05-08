typedef struct { int unsigned i; longint unsigned l; } num_u;
import "DPI-C" function int pipeline(input int unsigned in[],
                                     input num_u un[], 
                                     input int unsigned id, 
                                     input int unsigned dfp);


//
// If I dont want to calculate output delay by looking at the waveform
//
`define OUTPUT_DELAY [1:5]

module pipeline_TB;
  reg [31:0] in1, in2, in3, in4;
  reg clk;
  reg rst;
  reg en;
  //wire [31:0] out1, out2, out3, out4, out5, out6,
  //wire [ 0:0] out1_valid, out2_valid, out3_valid, out4_valid, out5_valid, out6_valid
  wire [31:0] out1;
  wire [63:0] out2;
  wire [ 0:0] out1_valid, 
              out2_valid;

  integer i, n;

  parameter INPUTS_NU = 16;
  parameter OUTPUTS_NU = 2;
  parameter PORTS_NU=4;

  // we know the delay of each output
  parameter OUTPUT1_DELAY = 2;
  parameter OUTPUT2_DELAY = 3;

  localparam TEST_NU = 2;
  localparam DP = 1, SP = 0;

  //integer inputs[0:41]; // v2k
  int unsigned pipeline_inputs[INPUTS_NU];       // pipeline inputs
  //num_u pipeline_outputs[OUTPUTS_NU];
  num_u pipeline_outputs[];

  int dataQ[$];     // queue to store/read incoming data
  int dataQsize;    // queue size
  assign dataQsize = dataQ.size;

  always @ (negedge clk)
    if (rst)
      dataQ = {};
    else if (en) begin
      dataQ.push_front(in1);
      dataQ.push_front(in2);
      dataQ.push_front(in3);
      dataQ.push_front(in4);
    end

  reg read_packet;  

  // pipeline input data
  always @ (posedge clk) begin
    if (dataQsize == INPUTS_NU) begin
      read_packet = 1;
      for (i = 0; i < INPUTS_NU; i = i+PORTS_NU) begin
        pipeline_inputs[i+0] = dataQ.pop_back();
        pipeline_inputs[i+1] = dataQ.pop_back();
        pipeline_inputs[i+2] = dataQ.pop_back();
        pipeline_inputs[i+3] = dataQ.pop_back();
      end
    end
    else read_packet = 0;
  end

  // pipeline output data
  always @ (negedge clk) begin 
    if (out1_valid) pipeline_outputs[0].i = out1;  // 32
    if (out2_valid) pipeline_outputs[1].l = out2;  // 64
  end


  // use generate ...
  property p_check_out1;
    //int unsigned local_inputs[INPUTS_NU];
    int unsigned local_inputs[];
    @(posedge clk)
    (read_packet, local_inputs = pipeline_inputs) |-> 
     ##`OUTPUT_DELAY (out1_valid && pipeline(local_inputs, pipeline_outputs, 0, SP));
  endproperty : p_check_out1
  assert property (p_check_out1);

  property p_check_out2;
    int unsigned local_inputs[INPUTS_NU]; 
    @(posedge clk)
    (read_packet, local_inputs = pipeline_inputs) |-> 
    ##`OUTPUT_DELAY (out2_valid && pipeline(local_inputs, pipeline_outputs, 1, DP));
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
    #20;
    rst = 0;
    repeat (5) @(posedge clk);
    for (n = 0; n < INPUTS_NU / PORTS_NU * TEST_NU; n=n+1) begin
      @(posedge clk);
      en = 1;
      in1 = n;
      in2 = n+1;
      in3 = n+2;
      in4 = n+3;
    end
    @(posedge clk) en = 0;  // when en is low ?
    #500;
    $finish;
  end
endmodule


module pipeline_hw (
  input [31:0] in1, in2, in3, in4,
  input clk,
  input rst,
  input en,
  //output [31:0] out1, out2, out3, out4, out5, out6,
  //output [ 0:0] out1_valid, out2_valid, out3_valid, out4_valid, out5_valid, out6_valid
  output reg [31:0] out1, 
  output reg [63:0] out2,
  output reg [ 0:0] out1_valid = 1'b0,
  output reg [ 0:0] out2_valid = 1'b0
);

localparam DII=11, INPUTS_NU=16, PORTS_NU=4;
localparam DP = 1, SP = 0;
int unsigned inputs[16];       // pipeline inputs

reg packet;
reg [1:0] cnt; // depends on inputs
reg en_r;
integer i;
integer sum;

reg[31:0] out1_r = 'b0;
reg[63:0] out2_r = 'b0, out2_2r = 'b0;
reg[ 0:0] out1_valid_r = 0;
reg[ 0:0] out2_valid_r = 0, out2_valid_2r = 0;

// aggregate array copy
// dst = src
// aggregate array compare
// if (dst == src)

// 0: 32 -- 1: 64

always @ (*) begin
  sum = 0; // default
  if (packet)
    for (i = 0; i < INPUTS_NU; i = i + 1)
      sum = sum + inputs[i];
end

always @ (posedge clk) begin
  out1_r <= sum; 
  out2_r <= sum + 1; 
  out2_2r <= out2_r;
  out1 <= out1_r;
  out2 <= out2_2r;

  out1_valid_r <= packet; 
  out1_valid <= out1_valid_r;

  out2_valid_r <= packet;
  out2_valid_2r <= out2_valid_r;
  out2_valid <= out2_valid_2r;
end


always @ (posedge clk) begin
  if (rst)
    en_r   <= 1'b0;
  else
    en_r   <= en;
end

always @ (posedge clk) begin
  if (rst) begin
    packet <= 0;
    cnt    <= 0;
  end
  else if (en_r || en) begin
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


