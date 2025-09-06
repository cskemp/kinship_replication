
[j1, home] = system('echo $HOME');
ps.home = home(1:end-1);


% Edit this path appropriately
ps.outdir = [ps.home, '/modelruns/kinshipreleasetest/'];
ps.permpref= 'perms/rwperm_treenib';

load('systemperms_nib');
rwfile = [ps.outdir, 'partitions_tree12_1_1_1_2_rpt1'];
rw = load(rwfile);

nperm = size(allperms,1);
nchunk = size(chunkperms,2);

% precompute components that violate each chunk

for i = 1:nchunk
  ininds =  [chunkinds{1}{i}, chunkinds{2}{i}];
  outinds = setdiff(1:size(rw.componentsm,2), ininds); 
  violatec{i} = transpose(find(sum(rw.componentsm(:,ininds),2) & sum(rw.componentsm(:,outinds),2)));
end

% make a logical matrix: permutations by systems. Can then address it
% either way.

nsystem = length(rw.rwfreqs);
rwpermindex = false(nsystem, nperm);

for i = 1:nperm
  if rem(i, 200)==0
    disp(i);
  end
  cp = chunkperms(perminds(i,1),:);  
  pf = permflips(perminds(i,2),:);
  % flips act second -- but the second disjunct will pick up any chunk
  % that has stayed in place and is flipped
  cchange= find(cp~=1:nchunk | pf == 2);
  allvind = unique(cell2mat(violatec(cchange)));
  rwpermindex(sum(rw.partitions(:, allvind),2) == 0,i)=1;
end

save('rwperms_nib', 'rwpermindex', 'rw');


