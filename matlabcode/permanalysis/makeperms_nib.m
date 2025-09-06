
% we'll always think about applying the permutation first, then creating
% the 32 possible flips of the resulting system.

nchunk = 5;

chunkinds{1} = {1:4, 21:24, [15,17,16,18], [5,8,6,9], [10,13,11,14]};
chunkinds{2} = {25:28, 53:56, [39,41,40,42], [29,32,30,33], [34,37,35,38]};

flips{1} = [1:4];
flips{2} = [3,4,1,2];

chunkperms = perms(1:nchunk);
permflips = allconcepts(nchunk)+1;
nperm = size(chunkperms,1);
nflip = size(permflips,1);

origp= 1:56;
allperms = zeros(nperm*nflip, 56);
perminds = zeros(nperm*nflip,2);

sysind = 1;
for i = 1:nperm
  cp = chunkperms(i,:);
  cchange= find(cp~=1:nchunk);
  newp = origp;
  for j = 1:nchunk
    newp(chunkinds{1}{j}) = origp(chunkinds{1}{cp(j)});
    newp(chunkinds{2}{j}) = origp(chunkinds{2}{cp(j)});
  end
  permfin = newp;
  % consider flips
  for flind= 1:nflip
    pflip = permflips(flind,:);
    chflind = find(pflip==2);
    newp = permfin;
    for chind = chflind
      newp(chunkinds{1}{chind}) = permfin(chunkinds{1}{chind}(flips{2}));
      newp(chunkinds{2}{chind}) = permfin(chunkinds{2}{chind}(flips{2}));
    end
    allperms(sysind,:) = newp;
    perminds(sysind,:) = [i,flind];
    sysind = sysind+1;
  end
end

save('systemperms_nib', 'allperms', 'perminds', 'chunkperms', 'permflips', 'chunkinds', 'flips');

