function compactp = part2compactp(part, comp)

% convert distributed partition PART to compact representation COMP


ncomp = size(comp,1);
npeople = size(comp,2);

zcomp = zeros(ncomp, npeople);
for i = 1:ncomp
  zcomp(i, find(comp(i,:))) = i;
end

compactp = zeros(size(part,1), npeople);
for i = 1:size(compactp,1)
  cs = part(i,:)';
  cp = sum(zcomp(cs,:),1);
  compactp(i,:) = canonicallabel(cp);
end
