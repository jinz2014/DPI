#include "vpi_user.h"

static PLI_INT32 hello(PLI_BYTE8 * param)
{
  vpi_printf( "Hello world!\n" );
  return 0;
}

/* Registration routine */
void RegisterMyTfs( void )
{
  s_vpi_systf_data systf_data;
  vpiHandle systf_handle;
  systf_data.type = vpiSysTask;
  systf_data.sysfunctype = vpiSysTask;
  systf_data.tfname = "$hello";
  systf_data.calltf = hello;
  systf_data.compiletf = 0;
  systf_data.sizetf = 0;
  systf_data.user_data = 0;
  systf_handle = vpi_register_systf( &systf_data );
  vpi_free_object( systf_handle );
}

void (*vlog_startup_routines[])() = {
  RegisterMyTfs,
  0
};
