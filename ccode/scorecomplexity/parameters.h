#ifndef PARAMETERS_H 
#define PARAMETERS_H 
#include "config.h"

struct parameter_str
{ int nsearch;
  int subscore;
  int nsofar;
  int rheuristic;

  char outfile[MAXSTRING];
  char partfile[MAXSTRING];
  char enumindfile[MAXSTRING];
  char subindfile[MAXSTRING];
  char depfile[MAXSTRING];
  char cxfile[MAXSTRING];
  char cxcfile[MAXSTRING];
  char rmatfile[MAXSTRING];
} parameter_str;

/* global variable */
extern struct parameter_str ps;

void parameters_getps(int *argcp, char ***argvp); 

#endif /* PARAMETERS_H */
