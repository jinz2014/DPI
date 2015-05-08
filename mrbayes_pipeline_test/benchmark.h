#ifndef _BENCHMARK
#define _BENCHMARK

#include <stdio.h>

#define DEBUG

void myprintf(const char* format, ... );
void myfprintf(FILE *fp, const char* format, ... );

/* floating and hex representations */
typedef union {
  int i;
  float f;
} int32_or_float;

typedef union {
  long long unsigned int i;
  double f;
} int64_or_double;



/****************************************************/
/* A simple ROM orgnization                         */
#define DEPTH 16
#define WORDS 5
/****************************************************/

/* simple mrbayes c model */
double mrbayes (FILE *fp, 
              float* ports,
              double bs0,
              double bs1,
              double bs2,
              double bs3,
              unsigned char norm,
              float* clP,
              float* lnScaler, 
              float* scP,
              int nu);

/* cheby log functions  */
double log_d1_cheby(FILE *fp, int32_or_float* ports, int log);
double log_d_cheby(FILE *fp, int64_or_double* ports, int log);

#endif
