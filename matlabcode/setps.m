function ps = setps()

% Set up run parameters, location of output files, etc.

% directory for intermediate and final results
[j1, home] = system('echo $HOME');
ps.home = home(1:end-1);

% I use these for big runs
%ps.outdir = [ps.home, '/modelruns/kinship25/'];
%ps.outdirtmp = [ps.home, '/modelruns/kinship25/tmp/'];
%ps.plotdir = [ps.home, '/modelruns/kinship25/plots/'];

% but for small runs it's fine to write to folders within the repository
ps.outdir = ['../output/'];
ps.outdirtmp = ['../output/tmp/'];
ps.plotdir = ['../output/plots/'];

% prefixes for generated file

ps.rwpartpref= 'rwpartitions_tree';
ps.compxpref= 'compx_';
ps.rwcomppref= 'comprw_';
ps.linkinpref= 'dlinkin_';
ps.linkoutpref= 'dlinkout_';
ps.enumpref= 'partitions_tree';
ps.plotpref= 'plot';
ps.domplotpref= 'domplot';
ps.complexpref= 'complex';
ps.costpref= 'cost';
ps.scorepref= 'score';
ps.combopref= 'combinedscores';
ps.domstatpref= 'domstat';
ps.randindpref= 'randind';

% directory with kinship data
ps.datadir= '../murdockdata/';
% file with partitions for every culture in the Murdock files
ps.masterrwpart= 'rwpartitions.txt';
ps.tclosuremax = 12; % number of 1-link expansions that will guarantee
		     % transitive closure (OK if this is larger than necessary)


% Parameters for displaying results
ps.dotmax = 200;
ps.dotmin = 10;

% Run parameters: enumerating components
ps.filtercompbyexm = 0;      % 1 or 0: use exm to strip duplicates
ps.filterstrong= 0;	     % 1 or 0: use first half of exm to strip duplicates
ps.compenumsparse  = 0;      % 1 or 0: use sparse data structure for binary predicates
ps.repeatcountstrip = 40000; % strip duplicates after this many cases added
ps.memchunksize =     20000; % grow data structures in increments of this many cases
ps.multidefn= 1;                  % 0 or 1: store defns of minimal complexity 
ps.nearmisstol = 0;		  % tolerance for near-misses
ps.rheuristic= 1;		  % use heuristic for introducing reciprocals?
				  % 0: no heuristic 
				  % 1: use heuristic
				  % 2: try with and without, choose min 
				  %    complexity 
				  % we used 2 for all subtree runs (e.g
				  % Fig 4C, S9C) and 1 for all other runs

% Run parameters: sampling partitions
ps.nsamplepartition = 400000000; % for Fig 4  (main tree)
ps.nsamplepartition = 100000000; % for Fig S3 (cousins) 
ps.nsamplepartition = 1000     ; % for testing only

% Parameters for computing partition scores 
ps.nsearch= 100000000;      % for other runs
ps.nsearch=     10000;      % for computationally demanding runs
%ps.nsearch=        10;      % for testing only

ps.nsplit = 24;
ps.nsamplesplit = 24;
ps.randsizes = [1000, 10000, 100000];
ps.parconf = 'local';
ps.parnumWorkers = 8;

ps.costs = [1/3,0];  % chunkcost, lexical item cost. 
		     % makecomp.m currently assigns a complexity of 3 to
		     %   each rule -- so setting ps.costs(1) to 1/3 means
		     %   that the complexity of each rule is 1. 
		     % ps.costs(2) reflects the complexity associated with
		     %   remembering lexical items. If a partition
		     %   includes n categories, then there are n lexical
		     %   items to encode (we're assuming that there are no
		     %   lexical items corresponding to latent
		     %   categories). Currently we set ps.costs(2) to 0 
		     %   so that the complexity of a system is equal to
		     %   the number of rules required to define all the
		     %   terms in the system.
