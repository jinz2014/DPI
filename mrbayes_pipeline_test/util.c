#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "pipeline.h"

void myprintf(const char* format, ... ) {
#ifdef DEBUG
  va_list args;
  va_start( args, format );
  vfprintf( stdout, format, args );
  va_end( args );
#endif
}

void myfprintf(FILE *fp, const char* format, ... ) {
#ifdef DEBUG
  va_list args;
  va_start( args, format );
  vfprintf( fp, format, args );
  va_end( args );
#endif
}


