#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"
#include "opt.h"
#include "parameters.h"
#include "bheap.h"

typedef struct {
    int *ndeps[MAXCONCEPTS];
    int *dependency[MAXCONCEPTS][MAXDEP]; 
    int *complexity[MAXCONCEPTS];
    int *totalcomplexity[MAXCONCEPTS];
    int enumind[MAXCONCEPTS];
    int ndef[MAXCONCEPTS];
    int rmat[MAXCONCEPTS];
    int rdef[MAXCONCEPTS];
} componentdata;


int main(int, char**);
void scorepartition(int, bheap_t*, int*, int*, componentdata *, int*, int*, int, int);
void readcomponentdata(componentdata *);
int *my_malloc(int n);
void my_free(componentdata *);

componentdata cd;

int main(int argc, char **argv)
{
  FILE *finptr, *foutptr;
  char c[MAXSTRING];
  char *tok;
  int currpart[MAXPART];
  int marked[MAXCONCEPTS];   // flag which concepts have been used already
  int inheap[MAXCONCEPTS];   // flag which concepts currently in heap
  int partsz, i, j, currscore, bestscore, nr, rind, bestscorer, bestscoreall;
  bheap_t *bh;

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

  bh = bh_alloc(MAXCONCEPTS);
  for (i=0; i<MAXCONCEPTS; i++) {
    marked[i]=0;  
    inheap[i]=0;  
  }

  j = 1;
  partsz = 0;
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
        currpart[partsz] = cd.enumind[currpart[partsz]];
        bh_insert(bh, currpart[partsz], cd.ndef[currpart[partsz]]);
        marked[currpart[partsz]]++;
        inheap[currpart[partsz]]++;
        partsz++;
      }
      tok = (char *) strtok(NULL, " ");
    }
    // find reciprocals
    currscore = 0; bestscoreall = MAXSCORE; ps.nsofar = 0;
    // score this partition 
    scorepartition(partsz, bh, marked, inheap, &cd, &currscore, &bestscoreall, 1, 0);
    if (ps.nsofar > ps.nsearch) {
      ps.nsofar = 0;
      scorepartition(partsz, bh, marked, inheap, &cd, &currscore, &bestscoreall, 0, 0);
    }

    bestscore = bestscoreall;
    
    fprintf(foutptr, "%d %d\n", bestscore, partsz);
    fflush(foutptr);
    j++;

    // remove seed concepts from heap
    for (i=partsz-1; i>=0; i--) {
      if (marked[currpart[i]]) {
        bh_delete(bh, currpart[i]);
        marked[currpart[i]]--;
        inheap[currpart[i]]--;
      }	
    }
  }

  fclose(foutptr);
  fclose(finptr);
  bh_free(bh);
  my_free(&cd);

  return(0);
}

void scorepartition(int hcount, bheap_t *bh, int *marked, int *inheap, componentdata *cd, int *currscore, int *bestscore, int recipflag, int randflag) {
  int i, j, minitem, dep, dcmplx, freeind, unmcnt, iinit, termcnd, rflag, firstdep;
  long minkey;

  // abort if we've tried enough options already
  if (ps.nsofar > ps.nsearch) { return; }

  if (hcount > 0) { 
    minitem = bh_min(bh, &minkey);
    bh_delete(bh, minitem);
    inheap[minitem]--;
    hcount--;

    dcmplx = MAXSCORE;
    freeind = MAXSCORE;
    // initial pass through definitions to see if one comes for free
    for (i = 0; i<minkey; i++) {  // for each definition
      unmcnt = 0;
      for (j = 0; j< cd->ndeps[minitem][i]; j++) {
        dep = cd->dependency[minitem][j][i];
        if (marked[dep] == 0) {
	  unmcnt = 1;
        }
      }
      if (j == 1) { 
        firstdep = cd->dependency[minitem][0][i];
	if (cd->rmat[minitem] == firstdep && 
				 (cd->rdef[firstdep] || 
			  	   (inheap[firstdep] && ps.rheuristic==0) ||
				    recipflag==0) ) {
	  unmcnt = 1; // don't get this defn for free -- firstdep was
		      // defined as a reciprocal of minitem, or first dep 
		      // still in heap and we're not using the reciprocal
		      // heuristic, or we're not considering reciprocal
		      // definitions at all
	}
      }

      if (unmcnt==0 && cd->complexity[minitem][i] < dcmplx) {
        dcmplx = cd->complexity[minitem][i];
        freeind = i;
      }
    }
    if (freeind < MAXSCORE) { // one defn comes for free -- so pick it
      iinit = freeind; 
      termcnd = freeind + 1;
    } else if (randflag==1) { // pick random defn
      iinit = rand() % minkey;
      termcnd = iinit+1;
    } else {		      // consider all defns
      iinit = 0;
      termcnd = minkey;
    }

    rflag = 0;
    for (i = iinit; i<termcnd; i++) {  // for each definition
      // new here
      firstdep = cd->dependency[minitem][0][i];
      if (cd->rmat[minitem] == firstdep && cd->ndeps[minitem][i]==1 ) {
        if (recipflag==0 || cd->rdef[firstdep]) {
          continue; // can't use this reciprocal definition -- firstdep was
		    // previously defined as a reciprocal
        } else {
          rflag = 1;
          cd->rdef[minitem] = 1; // indicate that we've defined minitem as a
				 // reciprocal
        }
      }
      // end of new

      *currscore = *currscore + cd->complexity[minitem][i];

      for (j = 0; j< cd->ndeps[minitem][i]; j++) {
        dep = cd->dependency[minitem][j][i];
        marked[dep]++;
	if (marked[dep]==1) {
	  bh_insert(bh, dep, cd->ndef[dep]);
	  inheap[dep]++;
	  hcount++;
	}
      }

     // recursive call
     scorepartition(hcount, bh, marked, inheap, cd, currscore, bestscore, recipflag, randflag);

     for (j = 0; j< cd->ndeps[minitem][i]; j++) {
        dep = cd->dependency[minitem][j][i];
        marked[dep]--;
	if (marked[dep]==0) {
	  bh_delete(bh, dep);
          inheap[dep]--;
	  hcount--;
	}
      }
      *currscore = *currscore - cd->complexity[minitem][i];
      if (rflag == 1) {
        cd->rdef[minitem] = 0;
        rflag = 0; 
      }
    }

    bh_insert(bh, minitem, minkey);
    inheap[minitem]++;
    hcount++;
  } else {
    ps.nsofar++;
    if (*currscore < *bestscore) {
      *bestscore = *currscore;
      if (randflag == 1) {
      fprintf(stderr, "%d\n", *currscore);
      }
    }
  }

  return;
}

void readcomponentdata(componentdata *cd) {
  FILE *fptr;
  int i, j, cptind, defind, val, rind, cind;
  // 2012 code:
  // int depdata[4];
  int depdata[32];
  char c[MAXSTRING];
  char *tok;

  // create ndef and rdef
  for (i = 0; i < MAXCONCEPTS; i++) {
    cd->ndef[i] = 0;
    cd->rdef[i] = 0;
    cd->enumind[i] = 0;
  }



  // read enumind
  fptr = fopen(ps.enumindfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read enumind\n"); exit(1); 
  }
  i = 1;
  while (fscanf(fptr, "%d", &(cd->enumind[i]))==1) {
    i++;
  }
  fclose(fptr);

  
  fptr = fopen(ps.cxcfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read cxcfile\n"); exit(1); 
  }
  i = 0;
  while (fscanf(fptr, "%d %d %d", &cptind, &defind, &val)==3) {
    cd->ndef[cptind]=defind+1;
  }
  fclose(fptr);

  // allocate space for cd data structures
  for (i = 0; i < MAXCONCEPTS; i++) {
    cd->ndeps[i] = my_malloc(cd->ndef[i]);
    cd->dependency[i][0] = my_malloc(cd->ndef[i]);
    cd->dependency[i][1] = my_malloc(cd->ndef[i]);
    cd->complexity[i] = my_malloc(cd->ndef[i]);
    cd->totalcomplexity[i] = my_malloc(cd->ndef[i]);
  }

  // read dependency
  fptr = fopen(ps.depfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read depfile\n"); exit(1); 
  }

  while (fgets(c, MAXSTRING, fptr) != NULL) {
    // read current partition
    tok = (char *) strtok(c, " ");
    i = 0;
    while (tok != NULL) {
      depdata[i] = atoi(tok);
      tok = (char *) strtok(NULL, " ");
      i++;
    }
    i = i-1;
    cptind = depdata[0];
    defind = depdata[1];
    cd->ndeps[cptind][defind] = i-2;
    for (j = 2; j < i; j++) {
      cd->dependency[cptind][j-2][defind]=depdata[j];
    }
  }
  fclose(fptr);

  // read cxfile 
  fptr = fopen(ps.cxfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read cxfile\n"); exit(1); 
  }
  while (fscanf(fptr, "%d %d %d", &cptind, &defind, &val)==3) {
    cd->complexity[cptind][defind]=val;
  }
  fclose(fptr);

  // read cxcfile 
  fptr = fopen(ps.cxcfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read cxcfile\n"); exit(1); 
  }
  while (fscanf(fptr, "%d %d %d", &cptind, &defind, &val)==3) {
    cd->totalcomplexity[cptind][defind]=val;
  }
  fclose(fptr);

  // read rmatfile 
  fptr = fopen(ps.rmatfile, "r");
  if (fptr == NULL) {
    fprintf(stderr, "couldn't read rmatfile\n"); exit(1); 
  }
  for (i=0; i<MAXCONCEPTS; i++) {
    cd->rmat[i] = 0;
  }

  while (fscanf(fptr, "%d %d", &rind, &cind)==2) {
    cd->rmat[rind]=cind;
  }
  fclose(fptr);

}


int *my_malloc(int nchunk)
{ int i, *ptr;
  ptr = calloc(nchunk,sizeof(int));
  if (ptr == NULL) {
    fprintf(stderr, "ERROR: malloc failed");
  } else {
    for (i = 0; i < nchunk; i++) {
      ptr[i] = 0;
    }
  }
  return ptr;
}

void my_free(componentdata *cd)
{ int i;
  for (i = 0; i < MAXCONCEPTS; i++) {
    free(cd->ndeps[i]);
    free(cd->dependency[i][0]);
    free(cd->dependency[i][1]);
    free(cd->complexity[i]);
    free(cd->totalcomplexity[i]);
  }
}


