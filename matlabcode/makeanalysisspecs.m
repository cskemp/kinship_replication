function as = makeanalysisspecs()

% AS: data structure storing analysis specifications. 

% ------------------------------
% The "base" specifies which concepts are used to enumerate all remaining
% concepts. Indices refer to labels in componentbase.m

% Base 1: core set.  parent, child, same sex, diff sex, older, younger
% Base 6: concepts used for cousins analysis. 

as.base = { [1:6], [], [], [], [], [1,11:12,40:47, 2,13:14,48:55, 10,17:18,56:63,  15,64:73, 16, 74:83]}; 

% psetstruct will store DEP, CX, CXC for unary and binary predicates
%  DEP: dependency map -- records which predicates each predicate depends
%       (e.g. sibling will depend on parent and child)
%  CX:  complexity of predicate definition (3 in all cases)
%  CXC: intrinsic complexity of predicate definition (3 + intrinsic
%	 complexity of each predicate on RHS of definition)

% Note that the notion of "depth" in the SOM is referred to as
% "complexity" here.

% Initialize information in PSETSTRUCT

nsets = 1;
nbinpred = 83;
for i = 1:nsets
  % dependency, cx, cxc for unary predicates
  dep1 = cell(2,1);  
  cx1 = {0;0};
  cxc1 = cx1;

  % dependency, cx, cxc for binary predicates
  dep2 = cell(nbinpred,1);  
  cx2 = mat2cell(zeros(nbinpred,1), ones(nbinpred,1),1);
  cxc2 = cx2;
  as.psetstruct{i} = {dep1, cx1, cxc1, dep2, cx2, cxc2};
end

% Parameters that affect how the enumeration is carried out

% 1. Basic enumeration (disjunctions and conjunctions)
as.cfunctions{1} =  @makecomp;     % Handle to the function that will be 
				   % used to enumerate components. 
as.depth(1) = 3;		   % expand to level 3
as.disjflag(1) = 1;		   % allow disjunctions
as.conjflag(1) = 1;		   % allow conjunctions


% 2. Conjunctions only
as.cfunctions{2} =  @makecomp;
as.depth(2) = 3;		   
as.disjflag(2) = 0;		   
as.conjflag(2) = 1;		   

% 20. Cousins enumeration
as.cfunctions{20} = @makecomp_cousin;
as.depth(20) = 1; 
as.disjflag(20) = 0;		   
as.conjflag(20) = 1;		   


