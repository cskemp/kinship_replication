#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "config.h"
#include "opt.h"
#include "parameters.h"

typedef struct {
    double needprob[MAXTREE];
    int* compex[MAXCONCEPTS_ENUM];
    int compsizes[MAXCONCEPTS_ENUM];
    int halfcounts[MAXCONCEPTS_ENUM][2];
    double halfprobs[MAXCONCEPTS_ENUM][2];
    int nhalf;
} componentdata;


int main(int, char**);
double scorepartitioncost(int, int*, componentdata *);
void readcomponentdata(componentdata *);
int *my_malloc(int n);


int main(int argc, char **argv)
{
  FILE *finptr, *foutptr;
  char c[MAXSTRING];
  char *tok;
  int currpart[MAXTREE];
  int partsz;
  double score;
  componentdata cd;

  /* read parameters */
  parameters_getps(&argc, &argv);

  /* get data */
  readcomponentdata(&cd);

  /* read in partitions and score */
  finptr= fopen(ps.partfile, "r");
  if (finptr == NULL) {
    fprintf(stderr, "couldn't read partitions\n"); exit(1); 
  }
  foutptr= fopen(ps.outfile, "w");
  if (foutptr == NULL) {
    fprintf(stderr, "couldn't read output file\n"); exit(1); 
  }

  while (fgets(c, MAXSTRING, finptr) != NULL) {
    // read current partition
    tok = (char *) strtok(c, " ");
    partsz= 0;
    if (tok != NULL && tok[0]=='A') {
      break;    
    }
    while (tok != NULL) {
      currpart[partsz] = atoi(tok);
      if (currpart[partsz] != 0) {
        partsz++;
      }
      tok = (char *) strtok(NULL, " ");
    }
    score = scorepartitioncost(partsz, currpart, &cd); 

    fprintf(foutptr, "%f\n", score);
    fflush(foutptr);
  }
  fclose(foutptr);
  fclose(finptr);

  return(0);
}


void readcomponentdata(componentdata *cd) {
  FILE *fptr;
  int i, j, nhalf;
  char c[MAXSTRING];
  char *tok;

  // read need prob 
  fptr = fopen(ps.needfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read needprobs\n"); exit(1); 
  }
  i = 1;
  while (fscanf(fptr, "%lf", &(cd->needprob[i]))==1) {
    i++;
  }

  nhalf = ps.nhalf;

  fclose(fptr);

  // read components -- and allocate space
  fptr = fopen(ps.compexfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read compexfile\n"); exit(1); 
  }
  i = 0;
  while (fgets(c, MAXSTRING, fptr) != NULL) {
    i++;
    tok = (char *) strtok(c, " ");
    j = 0;
    while (tok != NULL) {
      if (atoi(tok)!= 0) {
      j++;
      }
      tok = (char *) strtok(NULL, " ");
    }
    cd->compsizes[i] = j;
    cd->compex[i] = my_malloc(j);
  }
  fclose(fptr);

  for (i = 0; i < MAXCONCEPTS_ENUM; i++) {
    cd->halfcounts[i][0] = 0;
    cd->halfcounts[i][1] = 0;

    cd->halfprobs[i][0] = 0;
    cd->halfprobs[i][1] = 0;
  }

  // read and store components
  fptr = fopen(ps.compexfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read compexfile\n"); exit(1); 
  }
  i = 0;
  while (fgets(c, MAXSTRING, fptr) != NULL) {
    i++;
    tok = (char *) strtok(c, " ");
    j = 0;
    while (tok != NULL) {
      cd->compex[i][j] =  atoi(tok);
      if (cd->compex[i][j]!=0) {
        if (cd->compex[i][j] <= nhalf) {
	  cd->halfcounts[i][0]++;
	  cd->halfprobs[i][0]+=cd->needprob[cd->compex[i][j]] ;
	} else {
	  cd->halfcounts[i][1]++;
	  cd->halfprobs[i][1]+=cd->needprob[cd->compex[i][j]] ;
	}
        j++;
      }
      tok = (char *) strtok(NULL, " ");
    }
  }
  fclose(fptr);
  cd->nhalf = nhalf;
}


int *my_malloc(int nchunk)
{ int i, *ptr;
  ptr = malloc(nchunk*sizeof(int));
  if (ptr == NULL) {
    fprintf(stderr, "ERROR: malloc failed");
  } else {
    for (i = 0; i < nchunk; i++) {
      ptr[i] = 0;
    }
  }
  return ptr;
}

double scorepartitioncost(int partsz, int *part, componentdata *cd)
{
  int i, j, compi, nobj, nequiv, pind;
  double cost = 0.0, ntot;

  for (i = 0; i < partsz; i++) {
    compi = part[i];
    nobj = cd->compsizes[compi];
    for (j = 0; j < nobj; j++) {
      pind = cd->compex[compi][j];
      if (pind <= cd->nhalf) {
        nequiv = cd->halfcounts[compi][0];
        ntot= cd->halfprobs[compi][0];
      } else {
        nequiv = cd->halfcounts[compi][1];
        ntot= cd->halfprobs[compi][1];
      }
      if (cd->needprob[pind] > 0) {
        cost -= cd->needprob[pind]*log2(cd->needprob[pind]/ntot);
      }
    }

  }
  return(cost);
}
