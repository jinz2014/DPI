#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "benchmark.h"

double coeff[16][5]=
{{-73.40074365,0.2382358288e32,-0.6210319922e62,0.7238728538e92,-0.2987219758e122},
{-68.79557345,0.2382358288e30,-0.6210319922e58,0.7238728538e86,-0.2987219758e114},
{-64.19040325,0.2382358288e28,-0.6210319922e54,0.7238728538e80,-0.2987219758e106},
{-59.58523305,0.2382358288e26,-0.6210319922e50,0.7238728538e74,-0.2987219758e98},
{-54.98006290,0.2382358288e24,-0.6210319922e46,0.7238728538e68,-0.2987219758e90},
{-50.37489271,0.2382358288e22,-0.6210319922e42,0.7238728538e62,-0.2987219758e82},
{-45.76972251,0.2382358288e20,-0.6210319922e38,0.7238728538e56,-0.2987219758e74},
{-41.16455235,0.2382358288e18,-0.6210319922e34,0.7238728538e50,-0.2987219758e66},
{-36.55938215,0.2382358288e16,-0.6210319922e30,0.7238728538e44,-0.2987219758e58},
{-31.95421196,0.2382358288e14,-0.6210319922e26,0.7238728538e38,-0.2987219758e50},
{-27.34904179,0.2382358288e12,-0.6210319922e22,0.7238728538e32,-0.2987219758e42},
{-22.74387159,2382358288.,-0.6210319922e18,0.7238728538e26,-0.2987219758e34},
{-18.13870141,23823582.88,-0.6210319922e14,0.7238728538e20,-0.2987219758e26},
{-13.53303064,238165.2663,-6207720405.,0.7235218462e14,-0.2985647234e18},
{-8.927860468,2381.652663,-620772.0405,72352184.62,-2985647234},
{-4.323190849,23.82358288,-62.10319922,72.38728538,-29.87219758}};

double mrbayes (
              FILE *fp, 
              float* ports,
              double bs0,
              double bs1,
              double bs2,
              double bs3,
              unsigned char norm,
              float* clP,
              float* lnScaler, 
              float* scP, 
              int nu) {

  /* keep the union structure */
  int32_or_float resAL, resCL, resGL, resTL;
  int32_or_float resAR, resCR, resGR, resTR;
  int32_or_float resA, resC, resG, resT;
  int32_or_float max1, max2, max3;
  int32_or_float Norm, InScaler, NumSites;
  int32_or_float scp, lnS;

  int64_or_double IIA, IIC, IIG, IIT;
  int64_or_double xd, log_d, log_d1, res;

  int i;

  /* clear */
  resAL.f = resCL.f = resGL.f = resTL.f = 0;
  resAR.f = resCR.f = resGR.f = resTR.f = 0;

  /*
   * read inputs
   */
  for (i = 0; i < 4; i++) {
    resAL.f += ports[i + 0] * ports[32+i];
  }

  for (i = 4; i < 8; i++) {
    resAR.f += ports[i + 0] * ports[32+i];
  }

  resA.f = resAL.f * resAR.f;

  for (i = 0; i < 4; i++) {
    resCL.f += ports[i + 8] * ports[32+i];
  }

  for (i = 4; i < 8; i++) {
    resCR.f += ports[i + 8] * ports[32+i];
  }

  resC.f = resCL.f * resCR.f;

  for (i = 0; i < 4; i++) {
    resGL.f += ports[i + 16] * ports[32+i];
  }

  for (i = 4; i < 8; i++) {
    resGR.f += ports[i + 16] * ports[32+i];
  }

  resG.f = resGL.f * resGR.f;

  for (i = 0; i < 4; i++) {
    resTL.f += ports[i + 24] * ports[32+i];
  }

  for (i = 4; i < 8; i++) {
    resTR.f += ports[i + 24] * ports[32+i];
  }

  InScaler.f = ports[40];

  myfprintf(fp, "InScaler input = %016llx(%.11f)\n", InScaler.i, InScaler.f);

  NumSites.f = ports[41];

  myfprintf(fp, "NumSites input = %08x(%.6f)\n", NumSites.i, NumSites.f);

  /*
   * compute
   */
  resT.f = resTL.f * resTR.f;

  myfprintf(fp, "LA PLF = %08x(%.6f)\n", resA.i, resA.f);

  myfprintf(fp, "LC PLF = %08x(%.6f)\n", resC.i, resC.f);

  myfprintf(fp, "LG PLF = %08x(%.6f)\n", resG.i, resG.f);

  myfprintf(fp, "LT PLF = %08x(%.6f)\n", resT.i, resT.f);

  max1.f = resA.f > resC.f ? resA.f : resC.f;
  max2.f = resG.f > resT.f ? resG.f : resT.f;
  max3.f = max1.f > max2.f ? max1.f : max2.f;

  IIA.f = bs0;
  IIC.f = bs1;
  IIG.f = bs2;
  IIT.f = bs3;

  Norm.i = norm;

  resA.f = Norm.i ? resA.f / max3.f : resA.f;
  resC.f = Norm.i ? resC.f / max3.f : resC.f;
  resG.f = Norm.i ? resG.f / max3.f : resG.f;
  resT.f = Norm.i ? resT.f / max3.f : resT.f;

  xd.f = (double) resA.f * IIA.f + (double) resG.f * IIG.f + 
         (double) resC.f * IIC.f + (double) resT.f * IIT.f;

  myfprintf(fp, "log_d1 input(single) = %08x(%.6f)\n", max3.i, max3.f);
  myfprintf(fp, "log_d_input (double) = %016llx(%.11f)\n", xd.i, xd.f);
  
  /* single-coeff + double-power */
  log_d1.f = log_d1_cheby(fp, &max3, 0);
  myfprintf(fp, "log_d1 output = %016llx(%.11f)\n", log_d1.i, log_d1.f);

  /* double-coeff + double-power */
  log_d.f = log_d_cheby(fp, &xd, 0);
  myfprintf(fp, "log_d output = %016llx(%.11f)\n", log_d.i, log_d.f);

  scp.f = (float)log_d1.f;
  lnS.f = scp.f + InScaler.f;
  myfprintf(fp, "log_d output = %016llx(%.11f)\n", log_d.i, log_d.f);


  res.f = ((double)lnS.f + log_d.f) * (double)NumSites.f;

  clP[nu*4+0]  = resA.f;
  clP[nu*4+1]  = resC.f;
  clP[nu*4+2]  = resG.f;
  clP[nu*4+3]  = resT.f;
  lnScaler[nu] = lnS.f;
  scP[nu]      = scp.f;

  return res.f;
}

/* coeffecient memory read + power 2, 4, 3 */
double log_d1_cheby(FILE *fp, int32_or_float* ports, int log) {

  int32_or_float mx2, mx4, mx5, mx6, mx8;
  int32_or_float mx9, mx10, mx11, mx12, mx13, mx14;
  int32_or_float x;

  int64_or_double x_d, x2_d, x3_d, x4_d;
  int64_or_double res;
  int a3, a2, a1, a0;
  int i, j;
  int addr;

  /*
   * A simple memory (depth x words)
   */
  double val = 0.01; /* initial memory fill value */
  int64_or_double **mem;

  mem = (int64_or_double **) malloc (sizeof(int64_or_double *) * WORDS);


#ifdef INIT_COEFF
  /* use appropriate values to fill the mem array */
  for (j = 0; j < WORDS; j++) {
    mem[j] = (int64_or_double *) malloc (sizeof(int64_or_double) * DEPTH);
    for (i = 0; i < DEPTH; i++) 
      mem[j][i].f = coeff[i][j];
  }
#else
  /* use simple arbitrary values to fill the mem array */
  for (j = 0; j < WORDS; j++) {
    mem[j] = (int64_or_double *) malloc (sizeof(int64_or_double) * DEPTH);
    for (i = 0; i < DEPTH; i++) {
      mem[j][i].f = val++;  
    }
  }
#endif

  /*
   * log input x
   */
  x.f    = ports[0].f;
  x_d.f  = (double)(ports[0].f);

  mx2.f = (x.f > 10e-16) ? 10e-8 : 10e-24;

  mx4.f = (x.f > mx2.f)  ? 10e-20 : 10e-28;
  mx5.f = (x.f > mx2.f)  ? 10e-4  : 10e-12;
  mx6.f = (x.f > 10e-16) ? mx5.f  : mx4.f;

  mx8.f  = (x.f > mx6.f) ? 10e-26 : 10e-30;
  mx9.f  = (x.f > mx6.f) ? 10e-18 : 10e-22;
  mx10.f = (x.f > mx6.f) ? 10e-10 : 10e-14; 
  mx11.f = (x.f > mx6.f) ? 10e-2  : 10e-6; 

  mx12.f = (x.f > mx2.f) ? mx9.f  : mx8.f;
  mx13.f = (x.f > mx2.f) ? mx11.f : mx10.f;

  mx14.f = (x.f > 10e-16) ? mx13.f : mx12.f;

  /*
   * memory address
   */
  a0 = x.f > mx14.f;
  a1 = x.f > mx6.f;
  a2 = x.f > mx2.f;
  a3 = x.f > 10e-16;

  addr = a3 * 8 + a2 * 4 + a1 * 2 + a0;
  assert (addr < DEPTH);

  /*
   * memory data output
   */
  int64_or_double *c = (int64_or_double *) malloc (sizeof(int64_or_double) * WORDS);

  /* WORDS x DEPTH */
  for (i = 0; i < WORDS; i++) c[i] = mem[i][addr];

  /*
   * x's power
   */
  x2_d.f =  x_d.f *  x_d.f;
  x3_d.f =  x_d.f * x2_d.f;
  x4_d.f = x2_d.f * x2_d.f;

  res.f = c[0].f + c[1].f * x_d.f + c[2].f * x2_d.f + c[3].f * x3_d.f + c[4].f * x4_d.f;

  free (c);
  for (i = 0; i < WORDS; i++) free(mem[i]);
  free(mem);

  if (log) fprintf(fp, "%016llx\n", res.i);
  return res.f;
}


double log_d_cheby(FILE *fp, int64_or_double* ports, int log) {
  int64_or_double res;
  int64_or_double x, x2, x3, x4;
  int64_or_double mx2, mx4, mx5, mx6, mx8;
  int64_or_double mx9, mx10, mx11, mx12, mx13, mx14;
  int a3, a2, a1, a0;
  int i, j;

  double val;
  int addr;
  val = 0.01; 
  int64_or_double **mem;

  mem = (int64_or_double **) malloc (sizeof(int64_or_double *) * WORDS);

#ifdef INIT_COEFF
  for (j = 0; j < WORDS; j++) {
    mem[j] = (int64_or_double *) malloc (sizeof(int64_or_double) * DEPTH);
    for (i = 0; i < DEPTH; i++) 
      mem[j][i].f = coeff[i][j];
  }
#else
  for (j = 0; j < WORDS; j++) {
    mem[j] = (int64_or_double *) malloc (sizeof(int64_or_double) * DEPTH);
    for (i = 0; i < DEPTH; i++) {
      mem[j][i].f = val++;  
    }
  }
#endif


  /*
   * log input x
   */
  x.f  = ports[0].f;

  mx2.f = (x.f > 10e-16) ? 10e-8 : 10e-24;

  mx4.f = (x.f > mx2.f)  ? 10e-20 : 10e-28;
  mx5.f = (x.f > mx2.f)  ? 10e-4  : 10e-12;
  mx6.f = (x.f > 10e-16) ? mx5.f  : mx4.f;

  mx8.f  = (x.f > mx6.f) ? 10e-26 : 10e-30;
  mx9.f  = (x.f > mx6.f) ? 10e-18 : 10e-22;
  mx10.f = (x.f > mx6.f) ? 10e-10 : 10e-14; 
  mx11.f = (x.f > mx6.f) ? 10e-2  : 10e-6; 

  mx12.f = (x.f > mx2.f) ? mx9.f  : mx8.f;
  mx13.f = (x.f > mx2.f) ? mx11.f : mx10.f;

  mx14.f = (x.f > 10e-16) ? mx13.f : mx12.f;

  a0 = x.f > mx14.f;
  a1 = x.f > mx6.f;
  a2 = x.f > mx2.f;
  a3 = x.f > 10e-16;

  addr = a3 * 8 + a2 * 4 + a1 * 2 + a0;
  assert (addr < DEPTH);

  int64_or_double *c = (int64_or_double *) malloc (sizeof(int64_or_double) * WORDS);

  for (i = 0; i < WORDS; i++) c[i] = mem[i][addr];

  /*
   * x's power
   */
  x2.f = x.f * x.f;
  x3.f = x.f * x2.f;
  x4.f = x2.f * x2.f;

  res.f = c[0].f + c[1].f * x.f + c[2].f * x2.f + c[3].f * x3.f + c[4].f * x4.f;

  free (c);
  for (i = 0; i < WORDS; i++) free(mem[i]);
  free(mem);

  fprintf(fp, "%016llx\n", res.i);

  return res.f;
}

