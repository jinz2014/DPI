#include <math.h>
#include <stdio.h>
#include <sys/types.h>
#include "svdpi.h"
#include "pipeline.h"

// floating-point value (C) vs. hexadecimal value (SV)
int compare32 (uint32_t a, float b) {
  return ( fabs( *((float *) &a) - b ) <= 0.01 );
}

int compare64 (uint64_t a, double b) {
  return ( fabs( *((double *) &a) - b ) <= 0.01 );
}


int
pipeline(
   const int64_t time,    /* longint(sv) -- int64_t(c) */
   const uint32_t* inputs,
   const uint64_t  outputs,  /* largest output data width */
   uint32_t id,
   uint32_t dfp) {

   int i;
   float sum_f = 0;
   double sum_d = 0;

   printf("Csim: time %ld\n", time);

   for (i = 0; i < 16; i++) {
     printf("Csim: id=%d inputs %d = %x\n", id, i, inputs[i]);
     sum_f += *((float *) &inputs[i]);
   }

   sum_d = sum_f;
   printf("Csim: sum=%f %f\n", sum_f, sum_d);

   switch (id) {
     case 0:
     if (dfp)
      return (compare64(outputs, sum_d));
     else
      return (compare32(outputs, sum_f));  /* upper32 bits truncated */

     case 1:
     if (dfp)
      return (compare64(outputs, sum_d));
     else
      return (compare32(outputs, sum_f));

     default: 
     printf("Error: undefined output id\n"); return 0;
   }
 }

