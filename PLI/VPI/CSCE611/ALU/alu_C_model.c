#include <stdio.h>
#include <math.h>
#include <errno.h>

int and(int a, int b) {
  return (a & b);
}

int xor(int a, int b) {
  return (a ^ b);
}

int nor(int a, int b) {
  return ~(a | b);
}

int or(int a, int b) {
  return (a | b);
}

int add(int a, int b) {
  return (a + b);
}

int addu(int a, int b) {
  return (a + b);
}

int sub(int a, int b) {
  return (a - b);
}

int subu(int a, int b) {
  return (a - b);
}

int lt(int a, int b) {
  return ((a < b) ? 1 : 0);
}

int ltu(unsigned int a, unsigned int b) {
  return ((a < b) ? 1 : 0);
}

int sll(int a, unsigned int shamt) {
  return (a << shamt);
}

int srl(unsigned int a, unsigned int shamt) {
  return (a >> shamt);
}

int sra(int a, unsigned int shamt) {
  return (a >> shamt);
}

/* set zero if result is 0 */
int IsZero(int result) {
  return ((result == 0) ? 1 : 0);  
}

/* set overflow for add and sub operation */
int IsOverflow(int a, int b, int opcode, int result) {
  int overflow = 0;
  int sign_a, sign_b, sign_r;
  switch(opcode) {
    case 0x4:
      sign_a = (a >> 31) & 0x1;
      sign_b = (b >> 31) & 0x1;
      sign_r = (result >> 31) & 0x1;
      if (sign_a == sign_b && sign_a != sign_r)
        overflow = 1;
      break;
  
    case 0x6:
      sign_a = (a >> 31) & 0x1;
      sign_b = (b >> 31) & 0x1;
      sign_r = (result >> 31) & 0x1;
      if (sign_a && !sign_b && !sign_r || !sign_a && sign_b && sign_r)
        overflow = 1;
      break;

    default: overflow = 0; 
  }
  return overflow;
}

void ALU_C_model(
       int *result,  /* output result from ALU */
       int *zero,    /* output; set if output is zero */
       int *overflow,/* output; set if result causes overflow */
       int a,        /* operand a */
       int b,        /* operand b */
       int opcode,   /* opcode */
       int shamt )   /* shift amount */
{
  switch (opcode) {
    case 0x0: *result = and  (a, b);     break;
    case 0x1: *result = or   (a, b);     break;
    case 0x2: *result = xor  (a, b);     break;
    case 0x3: *result = nor  (a, b);     break;

    case 0x4: *result = add  (a, b);     break;
    case 0x5: *result = addu (a, b);     break;
    case 0x6: *result = sub  (a, b);     break;
    case 0x7: *result = subu (a, b);     break;

    case 0x8: *result = 0;               break;
    case 0x9: *result = 0;               break;
    case 0xA: *result = ltu  (a, b);     break;
    case 0xB: *result = lt   (a, b);     break;

    case 0xC: *result = sll  (a, shamt); break;
    case 0xD: *result = 0;               break;
    case 0xE: *result = srl  (a, shamt); break;
    case 0xF: *result = sra  (a, shamt); break;
  }
  *zero = IsZero(*result);
  *overflow = IsOverflow(a, b, opcode, *result);
  return;
}

