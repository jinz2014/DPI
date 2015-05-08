#include "svdpi.h"
#include "pipeline.h"
/*
Function Description (the variable h is a svOpenArrayHandle and d is an int.)
  int svLeft(h, d) Left bound for dimension d
  int svRight(h, d) Right bound for dimension d
  int svLow(h, d) Low bound for dimension d
  int svHigh(h, d) High bound for dimension d
  int svIncrement(h, d) 1 if left >= right, and 1 if left < right
  int svSize(h, d) Number of elements in dimension d: svHighsvLow+1
  int svDimension(h) Number of dimensions in open array
  int svSizeOfArray(h) Total size of array in bytes
 */

/*
 typedef struct {
   uint32_t i; 
   uint64_t l; 
 } num_u;
 */

/*
 int pipeline (const svOpenArrayHandle inputs_oa, 
             const svOpenArrayHandle outputs_oa, 
             uint32_t id, uint32_t dfp) {
             */
int
pipeline(
    const uint32_t* inputs,
    const num_u* outputs,
    uint32_t id,
    uint32_t dfp) {

   uint32_t result0;
   uint64_t result1;
   int i;
   int sum = 0;

   /*call mrbayes */
   for (i = 0; i < 16; i++)
     sum += inputs[i];

   result0 = sum;
   result1 = sum + 1;

   switch (id) {
     case 0:
     if (dfp)
      return (outputs[id].l == result0);
     else
      return (outputs[id].i == result0);

     case 1:
     if (dfp)
      return (outputs[id].l == result1);
     else
      return (outputs[id].i == result1);

     default: 
     printf("Error: undefined output id\n"); return 0;
   }
 }


