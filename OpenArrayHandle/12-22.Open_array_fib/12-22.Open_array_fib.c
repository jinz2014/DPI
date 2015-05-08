//-----------------------------------------------------------------------------
// This code example can be shared freely as long as you keep
// this notice and give us credit. In the event of publication,
// the following notice is applicable:
//
// (C) COPYRIGHT 2006-2011 Chris Spear, Greg Tumbush.  All rights reserved
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Sample 12-22
// Shows sharing an open array between C and SystemVerilog


#ifdef QUESTA
#include "incl.h"
//#include "vpi_user.h"
#else
#include <svdpi.h>
#endif

#include <stdio.h>

void  fib_oa(const svOpenArrayHandle data_oa, const int size) {
  int i, *data;
  data = (int *) svGetArrayPtr(data_oa);
  data[0] = 1;
  data[1] = 1;
  for (i=2; i<=svSize(data_oa, 1); i++)
    data[i] = data[i-1] + data[i-2];
}
