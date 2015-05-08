// Log
// ALU overflow -> Arithmetic overflow


//
// ALU design 
//
`include "ALU_defines.v"

module ALU
(
  // inputs
  A, 
  B, 
  ALUOp, 
  SHAMT, 

  // outputs
  R, 
  Zero,
  Overflow
);

input [31:0] A;
input [31:0] B;
input  [3:0] ALUOp;
input  [4:0] SHAMT;
output [31:0] R;
output Overflow;
output Zero;

wire cin;
wire cout;
wire add_ov;
wire addu_ov;
wire sub_ov;
wire subu_ov;
wire alu_ov;
wire ov;
wire ltu;
wire lt;
wire slt;
wire [31:0] R_int;
wire [31:0] ComparisonR;
wire [31:0] ShiftR;
wire [31:0] LogicalR;
wire [31:0] ArithmeticR;
wire [31:0] ArithmeticA;
wire [31:0] ArithmeticB;
wire [31:0] ANDR;
wire [31:0]  ORR;
wire [31:0] XORR;
wire [31:0] NORR;
wire [31:0] SLLR;
wire [31:0] SRLR;
wire [31:0] SRAR;

assign Zero = ~| R_int;
// 
// Arithmetic
//
assign ArithmeticA = A;
assign ArithmeticB = ALUOp[1] ? ~B : B;

assign cin = ALUOp[1];

// Add with carry in and carry out
assign {cout, ArithmeticR} = ArithmeticA + ArithmeticB + cin;

// Overflow 
assign addu_ov = 1'b0; //cout;

assign subu_ov = ~cout;

assign add_ov = ~ArithmeticR[31] & A[31] & B[31]
               | ArithmeticR[31] & ~A[31] & ~B[31]; 

assign sub_ov = ~ArithmeticR[31] & A[31] & ~B[31]
               | ArithmeticR[31] & ~A[31] & B[31]; 

assign alu_ov = ~(ALUOp[1] | ALUOp[0]) & add_ov
               | ALUOp[1] & ~ALUOp[0] & sub_ov;

// Arithmetic Overflow
assign Overflow = ~ALUOp[3] & ALUOp[2] & alu_ov;

//
// Logical
//
assign ANDR = A & B;
assign ORR = A | B;
assign XORR = A ^ B;
assign NORR = ~(A | B);
assign LogicalR = ALUOp[1] ? (ALUOp[0] ? NORR : XORR) : (ALUOp[0] ? ORR : ANDR);

//
// Comparison
//
// Four case: + -, - +, + +, - -

assign ltu = ALUOp[1] & ~ALUOp[0] & subu_ov;
assign  lt = ALUOp[1] &  ALUOp[0] & ((A[31] & ~B[31]) | (~sub_ov & ArithmeticR[31]));
assign slt = ltu | lt;

assign ComparisonR = slt ? 32'h0000_0001 : 32'h0000_0000;

//
// Shift
//
assign SLLR = A << SHAMT;
assign SRLR = A >> SHAMT;
assign SRAR = A[31] ? ~(~A >> SHAMT) : (A >> SHAMT);
assign ShiftR = ALUOp[1] ? (ALUOp[0] ? SRAR : SRLR) : (ALUOp[0] ? 32'd0 : SLLR);

// Internal ALU result
assign R_int = ALUOp[3] ? (ALUOp[2] ? ShiftR : ComparisonR) :
                          (ALUOp[2] ? ArithmeticR : LogicalR);
assign R = R_int;

endmodule



