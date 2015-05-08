#include "veriuser.h"
static PLI_INT32 hello()
{
  io_printf("Hi there\n");
  return 0;
}
s_tfcell veriusertfs[] = {
{usertask, 0, 0, 0, hello, 0, "$hello"},
{0} /* last entry must be 0 */
};
