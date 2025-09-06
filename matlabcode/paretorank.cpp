#include <mex.h>   


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

// arguments: n, d1, d2

//declare variables
  const mxArray *nptr, *d1ind, *d2ind;
  mxArray *newl1_m;
  int i, j,  m, n;
  double *d1, *d2, *newl1;
  
    
//associate inputs

    d1ind = prhs[0];
    d2ind = prhs[1];
    m = mxGetM(d1ind);
    n = mxGetN(d1ind);

    d1= mxGetPr(d1ind);
    d2= mxGetPr(d2ind);



    // create space for outputs
    newl1_m = plhs[0] = mxCreateDoubleMatrix(m, n, mxREAL);
    newl1 = mxGetPr(newl1_m);

    for (i = 0; i < m; i++) {
      if (i % 1000 == 0) {
         mexPrintf("%d\n", i);
      }
      newl1[i] = 0;
      for (j = 0; j < m; j++) {
        if ( (d1[j]< d1[i] & d2[j]<=d2[i]) | (d2[j]<d2[i] & d1[j]<=d1[i] ))  {
	  newl1[i]++;
	}
      }
    } 

    return;
}
