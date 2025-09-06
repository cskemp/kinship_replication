### Partial replication of analyses from Kemp + Regier, 2012,  Kinship categories across languages reflect general communicative principles.
#### Charles Kemp (c.kemp@unimelb.edu.au), September 2025

Code is based on the 2012 package available [here](https://charleskemp.com/kinship/).
Several changes were needed to get the code running using MATLAB R2023b on OSX: 

* `scorecomplexity.c`: 
    `depdata[4]` -> `depdata[32]`  (line 235 -- suggested by Sihan)
* `dancinglinks.c`: 
    - added `#include <stdlib.h>`
    - `print_row(p)` -> `void print_row(p)`
* `scorecomplexity.m`, `samplepartitions2textPAR.m`:
    - `matlabpool()` -> `parpool()` 
* `setps.m`
    - `ps.parnumWorkers = 8`;
    - set `ps.outdir`, `ps.outdirtmp`, `ps.plotdir` to desired directories
* added `combine_smallsetdisj.m` (I think that this was missing from the 2012 release)
* `plotsystems.m`:
    - `load(combocostfile)` -> `load('-ASCII', combocostfile)`
       (and similarly for `rwcomplexityfile`, `rwcostfile`)

Analogous changes will be needed in parts of the code I didn't run -- e.g. some `load` statements in `domstatistics.m` will need the `'-ASCII'` flag.

Then I did the following things. All intermediate results and data files should be saved in `output/`, which means that it should be possible to jump directly to the plotting stage (final steps in (3) and (4)) if that's what you'd like to do.

1) Followed steps 1 and 2 in original top-level `README` (I didn't worry about `mex paretorank.cpp`)
2) Followed "Preparations for Fig 4" in `matlabcode/README`)

a) Generate the disjunctive set of categories: 

patterns = [100, 1,1, 1, 3,3,6,1,0];  
groups = {[12]};  
rstages = {[3]};

which produced three files in the output directory after five hours or so:

  3599071   compx_12_1_1_1.mat   
  2233422   compx_12_1_1_1_all.mat   
 14430047   rawgencomponents12_1_1_1.mat   

You should be able to skip this step by using the versions of those outfiles 

b) Generated scores for attested partitions by running:

patterns = [100, 1,1, 1, 2,3,6,1,0];  
groups = {[12]};  
rstages = {[1,2,4,5,6]};

If we wanted the most accurate scores for attested systems we should increase `ps.nsearch` and set `ps.rheuristic = 2`. We don't take that approach here because we want to use the same approach for scoring attested systems and randomly sampled systems, and making these two changes increases the time taken to score systems. 

3) Followed steps for Fig 4C

Set    
ps.nsearch		=     100000000;   
ps.rheuristic		=	      2;   

(these two settings make the code take longer and aren't necessary if you just want to check that the code runs and produces the right kind of figures. But these settings are recommended if you want the most accurate complexity scores for the subsystems analysis).

patterns = [100, 1,1, 1, 2,3,6,1,0];  
groups = {[14:19]};  
rstages = {[1,2,3,4,5,6]};

then (took about 5 hours)

patterns = [100, 1,1, 1, 4,3,6,1,0];  
groups = {[14:19]};  
rstages = {[4,5,6,10]};

then make panels in Fig 4C using

patterns = [100, 1,1, 1, 4,3,6,1,0];
groups = {[14:19]};
rstages = {[8]};


4) Followed steps to make a figure like Fig 4A that uses only a small sample of hypothetical systems

Set    
ps.nsearch		=       10000;  
ps.rheuristic	=	        1;
ps.nsamplepartition =    1000; 

(this last setting is a much smaller sample than we used for the paper -- using a small sample here so the run doesn't take long and the output files are not large)

patterns = [100, 1,1, 9, 3,3,6,1,0];  
groups = {[12]};  
rstages = {[3,4,5,6,10]};

Then manually make dummy combined score file by typing

`cat combinedscores_12_1_1_9_3_6_rpt1_rand0 > combinedscores_12_10_10_10_10_6_rpt1_rand0`

at system prompt in output directory, then make a 4A-like figure using

patterns = [100, 10,10,  10, 10,10,6,1,0];
groups = {[12]};
rstages = {[8]};

What follows is the README that accompanied the 2012 release.    

4/18/12, Code prepared by Charles Kemp (ckemp@cmu.edu)

See matlabcode/README for a general introduction to the code.

#### Building the code:

To prepare the code for use you should

(1) compile the three C programs by typing 

> make

from within ccode/dancinglinks, ccode/scorecomplexity, ccode/scorecost.
Once compiled you should move the three executables to a folder that
belongs to your system path.

(2) Copy the perl scripts in perlscripts/ to a folder that belongs to your
system path.

(3) Compile matlabcode/paretorank.cpp by typing

> mex paretorank.cpp

at the Matlab prompt. Note that this function is used only for generating
the tables in the supporting material. 

#### Development environment: 

This package includes Matlab functions that were developed using Matlab
7.11 on an 8-core 2.5 GHz machine with 16 GB of RAM. Some of the functions
rely on the parallel computing toolbox.

