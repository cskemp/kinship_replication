
% we'll always think about applying the permutation first, then creating
% the 32 possible flips of the resulting system.

nchunk = 5;

chunkinds{1} = {7:8, 9:10, 11:12, 13:14, 15:16};
chunkinds{2} = {23:24,25:26, 27:28, 29:30, 31:32};

flips{1} = [1:2];

chunkperms = perms(1:nchunk);
nperm = size(chunkperms,1);
nflip = 1;
permflips = [1,1,1,1,1]; 

origp= 1:32;
allperms = zeros(nperm*nflip, 32);
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
  allperms(sysind,:) = newp;
  perminds(sysind,:) = [i,1];
  sysind = sysind+1;
end

save('systemperms_cousin', 'allperms', 'perminds', 'chunkperms', 'permflips', 'chunkinds', 'flips');

