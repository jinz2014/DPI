#ifdef QUESTA
 #include "incl.h"
 //#include "vpi_user.h"
#else
 #include <svdpi.h>
#endif

 #include <stdio.h>

/*
 */
void str_concat(
    char** z,        /* sv - output string */
    const char * i0, /* sv - input string */
    const char * i1) /* sv - input string */
{
  char *p = *z; 
  printf("%s %s %s\n", i0, i1, p);

  while ((*p = *i0) != '\0') {
    p++; 
    i0++;
  }
  while ((*p = *i1) != '\0') {
    p++; 
    i1++;
  }
}


