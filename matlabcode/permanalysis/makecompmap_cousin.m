load('systemperms_cousin');

cousibind = [7:16, 23:32];
outind = setdiff(1:32, cousibind);


[j1, home] = system('echo $HOME');
ps.home = home(1:end-1);
% Edit this path appropriately
ps.outdir = [ps.home, '/modelruns/kinshipreleasetest/'];
ps.permpref= 'perms/rwperm_treecous';

load('systemperms_cousin');
rwfile = [ps.outdir, 'partitions_tree13_6_1_20_2_rpt1'];
rw = load(rwfile);

nperm = size(allperms,1);
nchunk = size(chunkperms,2);

% make a logical matrix: permutations by systems. Can then address it
% either way.

nsystem = length(rw.rwfreqs);
rwpermindex = ones(nsystem, nperm);

rwcomps = find(sum(rw.partitions,1));
ncomp = size(rwcomps,2);
totperm = size(allperms,1);
comp2orig(rwcomps) = 1:length(rwcomps);

compmap = zeros(ncomp, totperm);
emptysys = zeros(1,32);

compsizes = sum(rw.componentsm,2);
for sz = 1:32
  compsz{sz} = find(compsizes==sz);
end


for i = 1:ncomp
  disp(i)
  rwcomp = rwcomps(i);
  compmembers = find(rw.componentsm(rwcomp,:));
  thissys = emptysys;
  thissys(compmembers) = 1;
  thissz = length(compmembers);
  for j = 1:totperm
    newsys = thissys;
    newsys = newsys(allperms(j,:));
    newmembers = find(newsys);
    outmembers = find(newsys==0);
    newcompind = find(sum(rw.componentsm(compsz{thissz}, newmembers),2) == thissz); 
    if isempty(newcompind)
      newcompind = -1;
    else
      newcompind = compsz{thissz}(newcompind);
    end
    compmap(i,j) = newcompind;
  end
end

% 0 for permutations that can't be defined given the space of components
for i = 1:nsystem
  compi = find(rw.partitions(i,:));  
  for j = 1:nperm
    if sum(compmap(comp2orig(compi),j)==-1)
      rwpermindex(i,j) = 0;
    end
  end
end

% NaN for "chunk violating" permutations
for i = 1:nsystem
  origsys = rw.compactp(i,:);
  for j = 1:nperm
    perm = allperms(j,:);
    permsys = origsys(perm);
    cands = intersect(permsys(cousibind), permsys(outind));
    fineflag = 1;
    for c = cands
      discrep = sum( (origsys==fineflag) ~= (permsys ==fineflag));
      if discrep > 0
        fineflag = 0;  % don't include chunk violating partitions
	break;
      end
    end

    if sum(origsys~=canonicallabel(permsys))==0
      rwpermindex(i,j) = nan; % NaN indicates identical partition...
    end 

    if fineflag == 0
      % ... or "chunk violating" permutation, 
      rwpermindex(i,j) = nan;
    end
  end
end
% put back one copy of each partition. remember this later.
rwpermindex(:,109) = 1;


save('comppermmap_cousin', 'compmap', 'rwpermindex', 'rw', 'comp2orig');



