typedef struct { int unsigned i; longint unsigned l; } num_u;
num_u pipeline_outputs[2];
import "DPI-C" function int pipeline(input int unsigned in[16],
                                   input num_u un[2], 
                                   input int unsigned id, 
                                   input int unsigned dfp);


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

  integer i;

  localparam PORTS_NU=4, TEST_NU = 10;

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
    #20;
    en = 1;
    for (i = 0; i < PORTS_NU * TEST_NU; i=i+1) begin
      @(negedge clk);
      in1 = i;
      in2 = i+1;
      in3 = i+2;
      in4 = i+3;
    end
    en = 0;
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

//integer inputs[0:41]; // v2k
int unsigned pipeline_inputs[16];       // pipeline inputs
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

  always @ (*) begin 
    pipeline_outputs[0].i = out1;  // 32
    pipeline_outputs[1].l = out2;  // 64
  end

// use generate ...
property p_check_out1;
  int unsigned local_inputs[INPUTS_NU]; // a copy of pipeline inputs
  @(posedge clk)
  (packet, local_inputs = pipeline_inputs) |-> ##2 (out1_valid && 
   pipeline(local_inputs, pipeline_outputs, 0, SP));
endproperty : p_check_out1
assert property (p_check_out1);

property p_check_out2;
  int unsigned local_inputs[INPUTS_NU]; // a copy of pipeline inputs
  @(posedge clk)
  (packet, local_inputs = pipeline_inputs) |-> ##3 (out2_valid && 
   pipeline(local_inputs, pipeline_outputs, 1, DP));
endproperty : p_check_out2
assert property (p_check_out2);

// 0: 32 -- 1: 64

always @ (*) begin
  sum = 0; // default
  if (packet)
    for (i = 0; i < INPUTS_NU; i = i + 1)
      sum = sum + pipeline_inputs[i];
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
        pipeline_inputs[0] <= in1;
        pipeline_inputs[1] <= in2;
        pipeline_inputs[2] <= in3;
        pipeline_inputs[3] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd1:
      begin
        pipeline_inputs[4] <= in1;
        pipeline_inputs[5] <= in2;
        pipeline_inputs[6] <= in3;
        pipeline_inputs[7] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd2:
      begin
        pipeline_inputs[8] <= in1;
        pipeline_inputs[9] <= in2;
        pipeline_inputs[10] <= in3;
        pipeline_inputs[11] <= in4;
        packet     <= 0;
        cnt       <= cnt + 1;
      end
      4'd3:
      begin
        pipeline_inputs[12] <= in1;
        pipeline_inputs[13] <= in2;
        pipeline_inputs[14] <= in3;
        pipeline_inputs[15] <= in4;
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


