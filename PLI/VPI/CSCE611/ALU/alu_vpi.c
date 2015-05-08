/**********************************************************************
 * $alu example -- PLI application using VPI routines
 *
 * C model of a  Arithmetic Logic Unit (Combinational logic version)
 *
 *********************************************************************/

/*********************************************************************/

#include <stdlib.h>    /* ANSI C standard library */
#include <stdio.h>     /* ANSI C standard input/output library */
#include <stdarg.h>    /* ANSI C standard arguments library */
#include "vpi_user.h"  /* IEEE 1364 PLI VPI routine library  */


/* prototypes of routines in this PLI application */
PLI_INT32  ALU_calltf(PLI_BYTE8 *user_data);
PLI_INT32  ALU_compiletf(PLI_BYTE8 *user_data);
PLI_INT32  ALU_interface(p_cb_data cb_data);

/**********************************************************************
 * VPI Registration Data
 *********************************************************************/
void ALU_register()
{
  s_vpi_systf_data tf_data;
  tf_data.type        = vpiSysTask;
  tf_data.sysfunctype = 0;
  tf_data.tfname      = "$alu";
  tf_data.calltf      = ALU_calltf;
  tf_data.compiletf   = ALU_compiletf;
  tf_data.sizetf      = NULL;
  tf_data.user_data   = NULL;
  vpi_register_systf(&tf_data);
}

void (*vlog_startup_routines[])() = {
  ALU_register,
  0
};

/**********************************************************************
 * Value change simulation callback routine: Serves as an interface
 * between Verilog simulation and the C model.  Called whenever the
 * C model inputs change value, passes the values to the C model, and
 * puts the C model outputs into simulation.
 *
 * NOTE: A handle to the $alu instance is passed into this
 * simulation callback routine, so that this routine can access the
 * arguments of the system task.
 *
 * A more efficient method would be to obtain all the handles one time
 * in the calltf routine, save the handles, and pass a pointer to the
 * saved handles to this simulation callback routine.
 *********************************************************************/
PLI_INT32 ALU_interface(p_cb_data cb_data)
{
  int          a, b, result, shamt;
  int          opcode, zero, overflow;
  s_vpi_value  value_s;
  vpiHandle    instance_h, arg_itr;
  vpiHandle    a_h, b_h, opcode_h, shamt_h, result_h, zero_h, overflow_h;

  /* Retrieve handle to $alu instance from user_data */
  instance_h = (vpiHandle)cb_data->user_data;

  /* obtain handles to system task arguments */
  /* compiletf has already verified arguments are correct */
  arg_itr     = vpi_iterate(vpiArgument, instance_h);
  a_h         = vpi_scan(arg_itr); /* 1st arg is a input */
  b_h         = vpi_scan(arg_itr); /* 2nd arg is b input */
  opcode_h    = vpi_scan(arg_itr); /* 3rd arg is opcode input */
  shamt_h     = vpi_scan(arg_itr); /* 4rd arg is opcode input */
  result_h    = vpi_scan(arg_itr); /* 5th arg is result output */
  zero_h      = vpi_scan(arg_itr); /* 6th arg is zero output */
  overflow_h  = vpi_scan(arg_itr); /* 7th arg is overflowor output */
  vpi_free_object(arg_itr);        /* free iterator--did not scan to null */

  /* Read current values of C model inputs from Verilog simulation */
  value_s.format = vpiIntVal;
  vpi_get_value(a_h, &value_s);
  a = value_s.value.integer;

  vpi_get_value(b_h, &value_s);
  b = value_s.value.integer;

  value_s.format = vpiIntVal;
  vpi_get_value(opcode_h, &value_s);
  opcode = value_s.value.integer;

  value_s.format = vpiIntVal;
  vpi_get_value(shamt_h, &value_s);
  shamt = value_s.value.integer;

  /******  Call the C model  ******/
  ALU_C_model(&result, &zero, &overflow, a, b, opcode, shamt);

  /* Write the C model outputs onto the Verilog signals */
  value_s.format = vpiIntVal;
  value_s.value.integer = result;
  vpi_put_value(result_h, &value_s, NULL, vpiNoDelay);

  value_s.format = vpiIntVal;
  value_s.value.integer = zero;
  vpi_put_value(zero_h, &value_s, NULL, vpiNoDelay);

  value_s.value.integer = overflow;
  vpi_put_value(overflow_h, &value_s, NULL, vpiNoDelay);

  return(0);
}

/**********************************************************************
 * calltf routine: Registers a callback to the C model interface
 * whenever any input to the C model changes value
 *********************************************************************/
PLI_INT32 ALU_calltf(PLI_BYTE8 *user_data)
{
  vpiHandle    instance_h, arg_itr, a_h, b_h, opcode_h, shamt_h, cb_h;
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
  shamt_h  = vpi_scan(arg_itr);  /* 4rd arg is shamt input */
  vpi_free_object(arg_itr);     /* free iterator--did not scan to null */

  /* setup value change callback options */
  time_s.type      = vpiSuppressTime;
  cb_data_s.reason = cbValueChange;
  cb_data_s.cb_rtn = ALU_interface;
  cb_data_s.time   = &time_s;
  cb_data_s.value  = &value_s;

  /* add value change callbacks to all signals which are inputs to  */
  /* pass handle to $alu instance as user_data value */
  cb_data_s.user_data = (PLI_BYTE8 *)instance_h;
  value_s.format = vpiIntVal;
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

  value_s.format = vpiIntVal;
  cb_data_s.obj = shamt_h;
  cb_h = vpi_register_cb(&cb_data_s);
  vpi_free_object(cb_h); /* don't need callback handle */

  return(0);
}

/**********************************************************************
 * compiletf routine: Verifies that $alu() is used correctly
 *   Note: For simplicity, only limited data types are allowed for
 *   task arguments.  Could add checks to allow other data types.
 *********************************************************************/
PLI_INT32 ALU_compiletf(PLI_BYTE8 *user_data)
{
  vpiHandle systf_h, arg_itr, arg_h;
  int       err = 0;

  systf_h = vpi_handle(vpiSysTfCall, NULL);
  arg_itr = vpi_iterate(vpiArgument, systf_h);
  if (arg_itr == NULL) {
    vpi_printf("ERROR: $alu requires 6 arguments\n");
    vpi_control(vpiFinish, 1);  /* abort simulation */
    return(0);
  }

  arg_h = vpi_scan(arg_itr); /* arg is a input */
  if (vpi_get(vpiType, arg_h) != vpiIntegerVar) {
    vpi_printf("$alu arg 1 (a) must be a integer variable\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is b input */
  if (vpi_get(vpiType, arg_h) != vpiIntegerVar) {
    vpi_printf("$alu arg 2 (b) must be a integer variable\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is opcode input */
  if (vpi_get(vpiType, arg_h) != vpiNet) {
    vpi_printf("$alu arg 3 (opcode) must be a net\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 4) {
    vpi_printf("$alu arg 3 (opcode) must be 4-bit vector\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is opcode input */
  if (vpi_get(vpiType, arg_h) != vpiNet) {
    vpi_printf("$alu arg 4 (shamt) must be a net\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 5) {
    vpi_printf("$alu arg 4 (shamt) must be 5-bit vector\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is result output */
  if (vpi_get(vpiType, arg_h) != vpiIntegerVar) {
    vpi_printf("$alu arg 5 (result) must be a integer var.\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is zero output */
  if (vpi_get(vpiType, arg_h) != vpiReg) {
    vpi_printf("$alu arg 6 (zero) must be a reg\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 1) {
    vpi_printf("$alu arg 6 (zero) must be scalar\n");
    err = 1;
  }

  arg_h = vpi_scan(arg_itr); /* arg is overflow output */
  if (vpi_get(vpiType, arg_h) != vpiReg) {
    vpi_printf("$alu arg 7 (overflow) must be a reg\n");
    err = 1;
  }
  else if (vpi_get(vpiSize, arg_h) != 1) {
    vpi_printf("$alu arg 7 (overflow) must be scalar\n");
    err = 1;
  }

  if (vpi_scan(arg_itr) != NULL) { /* should not be any more args */
    vpi_printf("ERROR: $alu requires only 7 arguments\n");
    vpi_free_object(arg_itr);
    err = 1;
  }

  if (err) {
    vpi_control(vpiFinish, 1);  /* abort simulation */
    return(0);
  }
  return(0);  /* no syntax overflowors detected */
}

/*********************************************************************/
