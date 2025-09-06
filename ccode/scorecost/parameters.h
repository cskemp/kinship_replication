#ifndef PARAMETERS_H 
#define PARAMETERS_H 
#include "config.h"

struct parameter_str
{ 
  char outfile[MAXSTRING];
  char partfile[MAXSTRING];
  char compexfile[MAXSTRING];
  char needfile[MAXSTRING];
  int nhalf;
} parameter_str;

/* global variable */
extern struct parameter_str ps;

void parameters_getps(int *argcp, char ***argvp); 

#endif /* PARAMETERS_H */
