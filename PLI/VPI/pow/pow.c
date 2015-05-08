#include "vpi_user.h"
#include <stdlib.h>
#include <math.h>

/* prototypes of PLI application routine names */
PLI_INT32 PowSizetf(PLI_BYTE8 *user_data),
          PowCalltf(PLI_BYTE8 *user_data),
          PowCompiletf(PLI_BYTE8 *user_data),
          PowStartOfSim(s_cb_data *callback_data);

/* Registration routine */
void RegisterMyTfs( void )
{
  s_vpi_systf_data systf_data;
  s_cb_data cb_data_s;
  vpiHandle systf_handle, callback_handle;

  systf_data.type        = vpiSysFunc;
  systf_data.sysfunctype = vpiSizedFunc;
  systf_data.tfname      = "$pow";
  systf_data.calltf      = PowCalltf;
  systf_data.compiletf   = PowCompiletf;
  systf_data.sizetf      = PowSizetf;
  systf_data.user_data   = NULL;
  systf_handle           = vpi_register_systf( &systf_data );
  vpi_free_object( systf_handle );
}

void (*vlog_startup_routines[])() = {
  RegisterMyTfs,
  0
};

/***********************************************************
 * Sizetf app to check bit width of systf return 
 **********************************************************/
PLI_INT32 PowSizetf(PLI_BYTE8 *user_data) { return (32); }

/***********************************************************
 * compiletf app to verify valid systf args 
 **********************************************************/
PLI_INT32 PowCompiletf(PLI_BYTE8 *user_data) {
  vpiHandle systf_handle, arg_iter, arg_handle;
  PLI_INT32 tfarg_type;
  int err_flag = 0;

  do {
    systf_handle = vpi_handle(vpiSysTfCall, NULL);
    arg_iter = vpi_iterate(vpiArgument, systf_handle);
    if (arg_iter == NULL) {
      vpi_printf("ERROR: $pow requires two arguments\n");
      err_flag = 1;
      break;
    }

    arg_handle = vpi_scan(arg_iter);
    tfarg_type = vpi_get(vpiType, arg_handle);
    if ( (tfarg_type != vpiReg) && 
         (tfarg_type != vpiIntegerVar) &&
         (tfarg_type != vpiConstant) ) {
      vpi_printf("ERROR: $pow arg1 must be a number, variable or net\n");
      err_flag = 1;
      break;
    }

    arg_handle = vpi_scan(arg_iter);
    if (arg_handle == NULL) {
      vpi_printf("ERROR: $pow requires 2nd arguments\n");
      err_flag = 1;
      break;
    }
    tfarg_type = vpi_get(vpiType, arg_handle);
    if ( (tfarg_type != vpiReg) && 
         (tfarg_type != vpiIntegerVar) &&
         (tfarg_type != vpiConstant) ) {
      vpi_printf("ERROR: $pow arg2 must be a number, variable or net\n");
      err_flag = 1;
      break;
    }

    if (vpi_scan(arg_iter) != NULL) {
      vpi_printf("ERROR: $pow has too many argments\n");
      vpi_free_object(arg_iter);
      err_flag = 1;
      break;
    }
} while (0 == 1);

  /* Abort simulation */
  if (err_flag) {
    /* One additional arg of type PLI_INT32 which is the same   
     * as the diagnostic message level arg passed to $finish().
     */
    vpi_control(vpiFinish, 1);
  }

  return 0;
}


/***********************************************************
 * calltf app to calculate base to power of exponent and
 * return result
 **********************************************************/
PLI_INT32 PowCalltf(PLI_BYTE8 *user_data) {
  s_vpi_value value_s;
  vpiHandle systf_handle, arg_iter, arg_handle;
  PLI_INT32 base, exp;
  double result;

  systf_handle = vpi_handle(vpiSysTfCall, NULL);
  arg_iter = vpi_iterate(vpiArgument, systf_handle);
  if (arg_iter == NULL) {
    vpi_printf("ERROR: $pow failed to obtain systf arg handles\n");
    return 0;
  }

  /* read base from systf arg 1 (compiletf has already verified */
  arg_handle = vpi_scan(arg_iter);
  value_s.format = vpiIntVal;
  vpi_get_value(arg_handle, &value_s);
  base = value_s.value.integer;

  /* read base from systf arg 2 (compiletf has already verified) */
  arg_handle = vpi_scan(arg_iter);
  vpi_free_object(arg_iter); /* not calling scan until returns NULL */
  vpi_get_value(arg_handle, &value_s);
  exp = value_s.value.integer;

  /* calculate result of base to power of exponent */
  result = pow((double)base, (double)exp);

  value_s.value.integer = (PLI_INT32) result;
  vpi_put_value(systf_handle, &value_s, NULL, vpiNoDelay);
  return (0);
}

/***********************************************************
 * Start-of-simulation app
 **********************************************************/
PLI_INT32 PowStartOfSim(s_cb_data *callback_data) {
  vpi_printf("\n$pow PLI application is being called...\n\n");
  return 0;
}
