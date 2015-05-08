/***********************************
// Specification
//
// ALUOp3 ALUOp2 
// 0      0            Logical
// 0      1            Arithmetic
// 1      0            Comparison
// 1      1            Shift
//
// ---------------------
// Logical
// ---------------------
// ALUOp1 ALUOp0
// 0      0         AND
// 0      1         OR
// 1      0         XOR
// 1      1         NOR
//
// ---------------------
// Shift
// ---------------------
// ALUOp1 ALUOp0
// 0      0         SLL
// 0      1         N/A
// 1      0         SRL
// 1      1         SRA
//
// ---------------------
// Arithmetic
// ---------------------
// ALUOp1 ALUOp0
// 0      0         ADD
// 0      1         ADDU
// 1      0         SUB
// 1      1         SUBU
//
// ---------------------
// Comparison
// ---------------------
// ALUOp1 ALUOp0
// 0      0         N/A
// 0      1         N/A
// 1      0         SLT
// 1      1         SLTU

************************************/

//
// ALU Operation Encodings
//
`define AND   4'b0000
`define OR    4'b0001
`define XOR   4'b0010
`define NOR   4'b0011

`define ADD    4'b0100 
`define ADDU   4'b0101
`define SUB    4'b0110
`define SUBU   4'b0111

`define SLTU  4'b1010
`define SLT   4'b1011

`define SLL   4'b1100
`define SRL   4'b1110
`define SRA   4'b1111
