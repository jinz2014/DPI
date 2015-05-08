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
svBit, which reduces to unsigned char. The input i is 2-state, and 7 bits wide, and
is passed as svBitVecVal. Notice that it is passed as a const pointer, which means
the underlying value can change, but you cannot change the value of the pointer, such
as making it point to another value. Likewise, the reset and load inputs are also
marked as const. In this example, the 7-bit counter value is stored in a char, and so
you have to mask off the upper bit.

The file svdpi.h contains the definitions for SystemVerilog DPI structures and
methods. 
*/

#define P1364_VECVAL
#include "svdpi.h"
#include "fib.h"

void fib( svBitVecVal data[20] ) {
  int i;
  data[0] = data[1] = 1;
  for (i = 2; i < 20; i++) 
    data[i] = data[i-1] + data[i-2];
}

