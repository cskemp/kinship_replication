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
  ps.nsearch= 10000;
  ps.subscore= 0;
  ps.nsofar= 0;
  ps.rheuristic= 1;

  strcpy(ps.outfile, emptystring);
  strcpy(ps.partfile, emptystring);
  strcpy(ps.enumindfile, emptystring);
  strcpy(ps.subindfile, emptystring);
  strcpy(ps.depfile, emptystring);
  strcpy(ps.cxfile, emptystring);
  strcpy(ps.cxcfile, emptystring);
  strcpy(ps.rmatfile, emptystring);

  optrega(&(ps.nsearch),  OPT_INT, '\0',  "nsearch",  "search size");
  optrega(&(ps.subscore), OPT_INT, '\0',  "subscore", "score subset only?");
  optrega(&(ps.nsofar),  OPT_INT, '\0',  "nsofar",  "nsofar");
  optrega(&(ps.rheuristic),  OPT_INT, '\0',  "rheuristic",  "use recip heuristic?");
  optrega(&(ps.outfile),   OPT_CSTRING, '\0',  "outfile", "output file");
  optrega(&(ps.partfile),OPT_CSTRING, '\0',  "partfile", "partitions");
  optrega(&(ps.enumindfile), OPT_CSTRING, '\0',  "enumindfile",
			    "orig indices of concepts in partition file");
  optrega(&(ps.subindfile),  OPT_CSTRING, '\0',  "subindfile", 
			    "indices of partitions to score");
  optrega(&(ps.depfile),  OPT_CSTRING, '\0',  "depfile", "dependency");
  optrega(&(ps.cxfile),  OPT_CSTRING, '\0',  "cxfile", "complexity");
  optrega(&(ps.cxcfile),  OPT_CSTRING, '\0',  "cxcfile", "totalcomplexity");
  optrega(&(ps.rmatfile),  OPT_CSTRING, '\0',  "rmatfile", "rmat");
  opt(argcp, argvp);
  opt_free();

  if (!ps.subindfile[0]) {
    ps.subscore= 0;
  } else {
    ps.subscore= 1;
  }
  return;
}

