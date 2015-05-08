/*
 * Copyright 1991-2010 Mentor Graphics Corporation
 *
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 * Simple SystemVerilog DPI Example - C model 8-to-1 multiplexer
 */

/*
The reset and load signals are 2-state single bit signals, and so they are passed as
svBit, which reduces to unsigned char. The input i is 2-state, and  bits wide, and
is passed as svBitVecVal. Notice that it is passed as a const pointer, which means
the underlying value can change, but you cannot change the value of the pointer, such
as making it point to another value. Likewise, the reset and load inputs are also
marked as const. In this example, the -bit counter value is stored in a char, and so
you have to mask off the upper bit.

The file svdpi.h contains the definitions for SystemVerilog DPI structures and
methods. 
*/

#define P1364_VECVAL
#include "svdpi.h"
#include <malloc.h>
#include <veriuser.h>
#include "cnt.h"

/* Structure to hold counter value */
typedef struct { 
  unsigned int cnt;
  unsigned int msk;
} my_cnt;

/* Construct a counter structure */
void* counter_new(int mask) {
  my_cnt* c = (my_cnt*) malloc(sizeof(my_cnt));
  c->cnt = 0;
  c->msk = mask;
  return c;
}

/* 
 * Run the counter for one cycle 
 * modelsim doesn't support const argument that is not passed as pointer.
 * Also c* inst is replaced with void *inst
 *
 * The argument *count is a pointer, corresponding to bit vector o1. 
 * Because only a pointer can return value to the bit vector.
 */

void counter(void *inst,
             int  *count,   
             int   init_val, /* init val */
             svBit reset,
             svBit load) {

 my_cnt* inst_q = (my_cnt*) inst;

 if (reset) 
   inst_q->cnt = 0; 

 else if (load) 
   inst_q->cnt = init_val; 

 else 
   inst_q->cnt++; 

 /* modulo count */
 inst_q->cnt &= inst_q->msk; 

 /* return current count */
 *count = inst_q->cnt;

 io_printf("C: count=%d, i=%d, reset=%d, load=%d\n", \
     inst_q->cnt, init_val, reset, load);
}

