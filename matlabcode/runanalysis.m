clear all 

%    X: tree index	12: full tree for main text
%			13: cousin tree
%			14: niblings
%			15: gp 
%			16: gc
%			17: aunts. 
%			18: siblings. 
%			19: uncles. 


% Y(1): base predicates  (1 = non-cousin analyses
%			  6 = cousin analysis)
% Y(2): primitive set	 (always 1 for this release)
% Y(3): component enumeration strategy. 0 = rw (ie attested),
%				        1 = disj, 
%					2 = conj, 
%				        3 = intersect conj with rw
%				        7 = intersect disj with rw
%				        9 = intersect disj with conj
%				        10 = intersect disj with rw (2+)
%				        13 = intersect conj with rw (2+)
%				        16 = intersect disj with rw (3+)
%				        17 = intersect disj with rw (4+)
%				        18 = intersect conj with rw (3+)
%					20 = cousins enumeration
%
% E(1): partition enumeration strategy. 
%					2 = rw with complexities
%					3 = sample
%					4 = dancinglinks -> .mat
%					5 = dancinglinks -> .txt
%                                       11 = rw perms for permanalysis
%                                       14 = rw perms for cousin permanalysis
% S(1): complexity strategy.		
%					2 = C code, no splits
%					3 = parallel C code
% V(1): need prob vector		1 = uniform
%					6 = eng + germ 
%					8 = stable population
% 
% ---------------


% Run specification goes here. See the README file for the specifications
% used for the different analyses in the paper.

patterns = [100, 1,1, 2, 3,3,6,1,0];  
groups = {[12]};  
rstages = {[1,2,3]};

thisrun = [];


% CK_2025
% patterns = [100, 1,1, 9, 3,3,6,1,0];
% groups = {[12]};
%rstages = {[3,4,5,6,10]};

patterns = [100, 10,10,  10, 10,10,6,1,0];
groups = {[12]};
rstages = {[8]};

% end CK_2025 

for i = 1:length(groups)
  gs = groups{i};
  rs =  rstages{i};
  for g = gs
    row = patterns(i,:);
    row(row==100) = g;
    thisrun = [thisrun; row];
    % runstages: specify what must be done for each X, Y pair
    runstages{size(thisrun,1)} = rs;
  end
end

trees	     = maketreespecs();
ases	     = makeanalysisspecs();
sses         = makescorespecs();
ps	     = setps();

n = size(thisrun, 1);

for i = 1:n
  x = thisrun(i,1); 
  ys(1) = thisrun(i,2); 
  ys(2) = thisrun(i,3); 
  ys(3) = thisrun(i,4); 
  e     = thisrun(i,5); 
  s = thisrun(i,6);
  v = thisrun(i,7);
  r = thisrun(i,8);
  randind = thisrun(i,9);
  stages = runstages{i};
  for sind = 1:length(stages)
    stage = stages(sind);
    switch stage
      case 1 % make file with attested partitions
        makerwpartitions(x, trees, ps);  
      case 2 % make file with attested components
        makerwcomponents(x, trees, ps);  
      case 3 % enumerate concepts that can be defined using a set of primitives
        makecomponents(x, ys, trees, ases, ps);
      case 4 % enumerate partitions that can be constructed using a set of concepts
        enumeratesystems(x, ys, e, r, trees, ps);
      case 5 % compute complexity of a set of partitions
        scorecomplexity(x, ys, e, s, r, randind, ps);
      case 6 % compute communicative cost of a set of partitions
        scorecost(x, ys, e, v, r, randind, sses, ps);
      case 7 % compute dominance ranks
        domstatistics(x, ys, e, v, r, randind, ps);
      case 8 % make plots for Figs 4, S3 and S9
        plotsystems(x, ys, e, v, r, randind, ps);
      case 9 % currently unused

      case 10  % strip duplicates
        makenodupscore(x, ys, e, v, r, randind, 0, ps);
      case 11  % include duplicates
        makenodupscore(x, ys, e, v, r, randind, 1, ps);
      otherwise
        disp('unknown stage')
    end
  end
end
