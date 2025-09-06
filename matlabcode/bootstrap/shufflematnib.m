clear all


nshuffle =  100000; 
% edit path appropriately
load('~/modelruns/kinshipreleasetest/compx_12_1_1_7');
load('~/modelruns/kinshipreleasetest/partitions_tree12_1_1_7_2_rpt1');

% make swap matrix
ncomp = size(exm_enum,1);
pairs = nchoosek(1:ncomp, 2);
pairindmat = zeros(ncomp);
indices = sub2ind(size(pairindmat), pairs(:,1), pairs(:,2)); 
pairindmat(indices) = ncomp+(1:size(pairs,1))';
pairindmat = pairindmat + pairindmat';

pairs = [zeros(ncomp,2); pairs];
pairs(1:ncomp,1) = 1:ncomp;

npair = size(pairs,1);
pairexm = logical(zeros(npair,56));

for i = 1:npair
  comps = pairs(i,:);
  comps = comps(comps~=0);
  if max(sum(exm_enum(comps,:),1))==1
    pairexm(i,:)= sum(exm_enum(comps,:),1)>0; 
  end
end

[ucomb, ii, jj] = unique(pairexm, 'rows');

npairext = size(ucomb,1);
swapcands = logical(zeros(npairext));

for i=1:npairext
  gs = find(jj==i);
  swapcands(gs,gs) = 1;
end
swapcands  = swapcands & logical(1 - eye(npair));

rwm = zeros(0, ncomp);
for i = 1:length(rwfreqs)
  rwm = [rwm; repmat(partitions(i,:), rwfreqs(i), 1)];
end
nrw = size(rwm,1);

% make matrix with one row per system, one column per pair                   

systemcs = logical(zeros(nrw, npair));
for i = 1:nrw
  cs = find(rwm(i,:));
  systemcs(i, systemvec(cs, pairindmat)) = 1;
end


matlabpool local 8
parfor i = 1:1000
for i = 1:1000
  disp(sprintf('loop iteration %d', i));
  shuffleloop(systemcs, nshuffle, i, ncomp, pairindmat, swapcands);
end

