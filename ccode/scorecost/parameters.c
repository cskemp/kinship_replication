#include "parameters.h"
#include "config.h"
#include "string.h"
#include "opt.h"

/*****************************************************************************
The global variable ps specifies parameters for the current run.
*****************************************************************************/

/* global variable */
struct parameter_str ps;

void parameters_getps(int *argcp, char ***argvp) {
  char emptystring[MAXSTRING];
  emptystring[0] = '\0';
  /* set defaults */

  ps.nhalf = 0;
  strcpy(ps.outfile, emptystring);
  strcpy(ps.partfile, emptystring);
  strcpy(ps.compexfile, emptystring);
  strcpy(ps.needfile, emptystring);
  
  optrega(&(ps.outfile),   OPT_CSTRING, '\0',  "outfile", "output file");
  optrega(&(ps.partfile),OPT_CSTRING, '\0',  "partfile", "partitions");
  optrega(&(ps.compexfile),OPT_CSTRING, '\0',  "compexfile", "compexfile");
  optrega(&(ps.needfile), OPT_CSTRING, '\0',  "needfile",
			    "needprobs");
  optrega(&(ps.nhalf),   OPT_INT, '\0',  "nhalf", "people in first family tree");

  opt(argcp, argvp);
  opt_free();

  return;
}

