/**********************************************************************
 * $scientific_alu example -- PLI application using VPI routines
 *
 * C model of a Scientific Arithmetic Logic Unit.
 *   Combinational logic version (output values are not stored).
 *
 * For the book, "The Verilog PLI Handbook" by Stuart Sutherland
 *  Copyright 1999 & 2001, Kluwer Academic Publishers, Norwell, MA, USA
 *   Contact: www.wkap.il
 *  Example copyright 1998, Sutherland HDL Inc, Portland, Oregon, USA
 *   Contact: www.sutherland-hdl.com
 *********************************************************************/
#include <stdlib.h>
#include <math.h>
#include <errno.h>

void PLIbook_ScientificALU_C_model(
       double *result,   /* output from ALU */
       int    *excep,    /* output; set if result is out of range */
       int    *err,      /* output; set if input is out of range */
       double  a,        /* input */
       double  b,        /* input */
       int     opcode)   /* input */
{
  switch (opcode) {
    case 0x0: *result = pow    (a, b);      break;
    case 0x1: *result = sqrt   (a);         break;
    case 0x2: *result = exp    (a);         break;
    case 0x3: *result = ldexp  (a, (int)b); break;
    case 0x4: *result = fabs   (a);         break;
    case 0x5: *result = fmod   (a, b);      break;
    case 0x6: *result = ceil   (a);         break;
    case 0x7: *result = floor  (a);         break;
    case 0x8: *result = log    (a);         break;
    case 0x9: *result = log10  (a);         break;
    case 0xA: *result = sin    (a);         break;
    case 0xB: *result = cos    (a);         break;
    case 0xC: *result = tan    (a);         break;
    case 0xD: *result = asin   (a);         break;
    case 0xE: *result = acos   (a);         break;
    case 0xF: *result = atan   (a);         break;
  }
  *excep = (errno == ERANGE);   /* result of math func. out-of-range */
  #ifdef WIN32  /* for Microsoft Windows compatibility */
   *err   = (_isnan(*result) || /* result is not-a-number, or */
             errno == EDOM);    /* arg to math func. is out-of-range */
  #else
   *err   = (isnan(*result) ||  /* result is not-a-number, or */
             errno == EDOM);    /* arg to math func. is out-of-range */
  #endif
  if (*err) *result = 0.0;      /* set result to 0 if error occurred */
  errno = 0;                    /* clear the error flag */
  return;
}
/*********************************************************************/


#define VPI_1995 0 /* set to non-zero for Verilog-1995 compatibility */

#include <stdlib.h>    /* ANSI C standard library */
#include <stdio.h>     /* ANSI C standard input/output library */
#include <stdarg.h>    /* ANSI C standard arguments library */
#include "vpi_user.h"  /* IEEE 1364 PLI VPI routine library  */

#if VPI_1995
#include "../vpi_1995_compat.h"  /* kludge new Verilog-2001 routines */
#endif


/* prototypes of routines in this PLI application */
PLI_INT32  PLIbook_ScientificALU_calltf(PLI_BYTE8 *user_data);
PLI_INT32  PLIbook_ScientificALU_compiletf(PLI_BYTE8 *user_data);
PLI_INT32  PLIbook_ScientificALU_interface(p_cb_data cb_data);

/**********************************************************************
 * VPI Registration Data
 *********************************************************************/
void PLIbook_ScientificALU_register()
{
  s_vpi_systf_data tf_data;
  tf_data.type        = vpiSysTask;
  tf_data.sysfunctype = 0;
  tf_data.tfname      = "$alu";
  tf_data.calltf      = PLIbook_ScientificALU_calltf;
  tf_data.compiletf   = PLIbook_ScientificALU_compiletf;
  tf_data.sizetf      = NULL;
  tf_data.user_data   = NULL;
  vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])() = {
  PLIbook_ScientificALU_register,
  0
};

/**********************************************************************
 * Value change simulation callback routine: Serves as an interface
 * between Verilog simulation and the C model.  Called whenever the
 * C model inputs change value, passes the values to the C model, and
 * puts the C model outputs into simulation.
 *
 * NOTE: A handle to the $scientific_alu instance is passed into this
 * simulation callback routine, so that this routine can access the
 * arguments of the system task.
 *
 * A more efficient method would be to obtain all the handles one time
 * in the calltf routine, save the handles, and pass a pointer to the
 * saved handles to this simulation callback routine.
 *********************************************************************/
PLI_INT32 PLIbook_ScientificALU_interface(p_cb_data cb_data)
{
  double       a, b, result;
  int          opcode, excep, err;
  s_vpi_value  value_s;
  vpiHandle    instance_h, arg_itr;
  vpiHandle    a_h, b_h, opcode_h, result_h, excep_h, err_h;

  /* Retrieve handle to $scientific_alu instance from user_data */
  instance_h = (vpiHandle)cb_data->user_data;

  /* obtain handles to system task arguments */
  /* compiletf has already verified arguments are correct */
  arg_itr  = vpi_iterate(vpiArgument, instance_h);
  a_h      = vpi_scan(arg_itr); /* 1st arg is a input */
  b_h      = vpi_scan(arg_itr); /* 2nd arg is b input */
  opcode_h = vpi_scan(arg_itr); /* 3rd arg is opcode input */
  result_h = vpi_scan(arg_itr); /* 4th arg is result output */
  excep_h  = vpi_scan(arg_itr); /* 5th arg is excep output */
  err_h    = vpi_scan(arg_itr); /* 6th arg is error output */
  vpi_free_object(arg_itr);  /* free iterator--did not scan to null */

  /* Read current values of C model inputs from Verilog simulation */
  value_s.format = vpiRealVal;
  vpi_get_value(a_h, &value_s);
  a = value_s.value.real;

  vpi_get_value(b_h, &value_s);
  b = value_s.value.real;

  value_s.format = vpiIntVal;
  vpi_get_value(opcode_h, &value_s);
  opcode = (int)value_s.value.integer;

  /******  Call the C model  ******/
  PLIbook_ScientificALU_C_model(&result, &excep, &err, a, b, opcode);

  /* Write the C model outputs onto the Verilog signals */
  value_s.format = vpiRealVal;
  value_s.value.real = result;
  vpi_put_value(result_h, &value_s, NULL, vpiNoDelay);

  value_s.format = vpiIntVal;
  value_s.value.integer = (PLI_INT32)excep;
  vpi_put_value(excep_h, &value_s, NULL, vpiNoDelay);

  value_s.value.integer = (PLI_INT32)err;
  vpi_put_value(err_h, &value_s, NULL, vpiNoDelay);

  return(0);
}

/**********************************************************************
 * calltf routine: Registers a callback to the C model interface
 * whenever any input to the C model changes value
 *********************************************************************/
PLI_INT32 PLIbook_ScientificALU_calltf(PLI_BYTE8 *user_data)
{
  vpiHandle    instance_h, arg_itr, a_h, b_h, opcode_h, cb_h;
  s_vpi_value  value_s;
  s_vpi_time   time_s;
  s_cb_data    cb_data_s;

  /* obtain a handle to the system task instance */
  instance_h = vpi_handle(vpiSysTfCall, NULL);

  /* obtain handles to system task arguments for model inputs */
  /* compiletf has already verified arguments are correct */
  arg_itr = vpi_iterate(vpiArgument, instance_h);
  a_h      = vpi_scan(arg_itr); /* 1st arg is a input */
  b_h      = vpi_scan(arg_itr); /* 2nd arg is b input */
  opcode_h = vpi_scan(arg_itr); /* 3rd arg is opcode input */
  vpi_free_object(arg_itr);  /* free iterator--did not scan to null */

  /* setup value change callback options */
  time_s.type      = vpiSuppressTime;
  cb_data_s.reason = cbValueChange;
  cb_data_s.cb_rtn = PLIbook_ScientificALU_interface;
  cb_data_s.time   = &time_s;
  cb_data_s.value  = &value_s;

  /* add value change callbacks to all signals which are inputs to  */
  /* pass handle to $scientific_alu instance as user_data value */
  cb_data_s.user_data = (PLI_BYTE8 *)instance_h;
  value_s.format = vpiRealVal;
  cb_data_s.obj = a_h;
  cb_h = vpi_register_cb(&cb_data_s);
  vpi_free_object(cb_h); /* don't need callback handle */

  cb_data_s.obj = b_h;
  cb_h = vpi_register_cb(&cb_data_s);
  vpi_free_object(cb_h); /* don't need callback handle */

  value_s.format = vpiIntVal;
  cb_data_s.obj = opcode_h;
  cb_h = vpi_register_cb(&cb_data_s);
  vpi_free_object(cb_h); /* don't need callback handle */

  return(0);
}

/**********************************************************************
 * compiletf routine: Verifies that $scientific_alu() is used correctly
 *   Note: For simplicity, only limited data types are allowed for
 *   task arguments.  Could add checks to allow other data types.
 *********************************************************************/
PLI_INT32 PLIbook_ScientificALU_compiletf(PLI_BYTE8 *user_data)
{
  vpiHandle systf_h, arg_itr, arg_h;
  int       err = 0;

  systf_h = vpi_handle(vpiSysTfCall, NULL);
  arg_itr = vpi_iterate(vpiArgument, systf_h);
  if (arg_itr == NULL) {
    vpi_printf("ERROR: $scientific_alu requires 6 arguments\n");
    vpi_control(vpiFinish, 1);  /* abort simulation */
    return(0);
  }

  arg_h = vpi_scan(arg_itr); /* 1st arg is a input */
  if (vpi_get(vpiType, arg_h) != vpiRealVar) {
    vpi_printf("$scientific_alu arg 1 (a) must be a real variable\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* 2nd arg is b input */
  if (vpi_get(vpiType, arg_h) != vpiRealVar) {
    vpi_printf("$scientific_alu arg 2 (b) must be a real variable\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* 3rd arg is opcode input */
  if (vpi_get(vpiType, arg_h) != vpiNet) {
    vpi_printf("$scientific_alu arg 3 (opcode) must be a net\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 4) {
    vpi_printf("$scientific_alu arg 3 (opcode) must be 4-bit vector\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* 4th arg is result output */
  if (vpi_get(vpiType, arg_h) != vpiRealVar) {
    vpi_printf("$scientific_alu arg 4 (result) must be a real var.\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* 5th arg is exception output */
  if (vpi_get(vpiType, arg_h) != vpiReg) {
    vpi_printf("$scientific_alu arg 5 (exception) must be a reg\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 1) {
    vpi_printf("$scientific_alu arg 5 (exception) must be scalar\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* 6th arg is error output */
  if (vpi_get(vpiType, arg_h) != vpiReg) {
    vpi_printf("$scientific_alu arg 6 (error) must be a reg\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 1) {
    vpi_printf("$scientific_alu arg 6 (error) must be scalar\n");
    err = 1;
  }

  if (vpi_scan(arg_itr) != NULL) { /* should not be any more args */
    vpi_printf("ERROR: $scientific_alu requires only 6 arguments\n");
    vpi_free_object(arg_itr);
    err = 1;
  }

  if (err) {
    vpi_control(vpiFinish, 1);  /* abort simulation */
    return(0);
  }
  return(0);  /* no syntax errors detected */
}

/*********************************************************************/
