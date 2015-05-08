#include <math.h>
#include <stdio.h>
#include "svdpi.h"
#include "pipeline.h"
#include "benchmark.h"

/* int32_or_float defined in benchmark.h */
typedef union { int32_or_float i_u; int64_or_double l_u; } float_or_double;

int compare (const uint64_t hw, const float_or_double* sw, 
             const uint32_t id, const uint32_t dfp) {
  if (dfp) {
    double res = *((double *)&hw); 
    printf("Csim: hw output%d = %llx(%f)\n", id, hw, res);
    printf("Csim: sw output%d = %llx(%f)\n", id, sw[id].l_u.i, sw[id].l_u.f);
    return ( fabs( res - sw[id].l_u.f ) <= 0.01 );
  }
  else {
    int res_i = hw; /* discard upper 32 bits */
    float res_f = *((float*)&res_i);
    printf("Csim: hw output%d = %x(%f)\n", id, res_i, res_f);
    printf("Csim: sw output%d = %x(%f)\n", id, sw[id].i_u.i, sw[id].i_u.f);
    return ( fabs( res_f - sw[id].i_u.f ) <= 0.01 );
  }
}

int
pipeline(
    const int64_t time,       /* longint(sv) -- int64_t(c) */
    const uint32_t *sw_inputs,
    const uint64_t hw_output,  /* largest output data width */
    const uint64_t bs0,
    const uint64_t bs1,
    const uint64_t bs2,
    const uint64_t bs3,
    const unsigned char norm,
    const uint32_t id,        /* output number */
    const uint32_t dfp) {     /* float or double */

   float  ports[42];               /* 42 inputs */
   float  sw_clP[4]; 
   float  sw_lnScaler;
   float  sw_scP;
   double sw_lnL;
   float_or_double sw_outputs[7];  /* 7 outputs */ 

   int i;

   printf("Csim: time %ld\n", time);

   /***************************************************************** 
    * inputs I/F 
    *
    * Warnings: refer to the testBench file for port read sequences 
    *
    *****************************************************************/
   for (i = 32; i < 40; i++) {
     ports[i] = *((float *) &sw_inputs[i-32]);
   }

   for (i = 0; i < 32; i++) {
     ports[i] = *((float *) &sw_inputs[i+8]);
   }

   ports[40] = *((float *) &sw_inputs[41]);
   ports[41] = *((float *) &sw_inputs[40]);

   for (i = 0; i < 42; i++) 
     printf("Csim: ports %d = %x\n", i, *((int*)&ports[i]));

   printf("Csim: bs %llx %llx %llx %llx\n", bs0, bs1, bs2, bs3);

   /* call mrbayes */
    sw_lnL = mrbayes (  stdout, 
                        ports, 
                        *(double *) &bs0, 
                        *(double *) &bs1, 
                        *(double *) &bs2, 
                        *(double *) &bs3, 
                        norm, 
                        sw_clP,           /* array */
                        &sw_lnScaler,
                        &sw_scP,
                        0);

   /***************************************************************** 
    * outputs I/F 
    *
    * Specified by the bind.sv
    *****************************************************************/
    sw_outputs[0].i_u.f = sw_clP[0]; 
    sw_outputs[1].i_u.f = sw_clP[1]; 
    sw_outputs[2].i_u.f = sw_clP[2]; 
    sw_outputs[3].i_u.f = sw_clP[3]; 
    sw_outputs[4].i_u.f = sw_scP; 
    sw_outputs[5].i_u.f = sw_lnScaler; 
    sw_outputs[6].l_u.f = sw_lnL; 

    /* compare hw results and sw results */
    return compare(hw_output, sw_outputs, id, dfp);
 }

