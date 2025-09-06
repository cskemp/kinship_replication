function makerwpartitions(treeind, trees, ps)

subsetind = trees{treeind}{1};
focals = trees{treeind}{2};
allrw = load([ps.datadir, ps.masterrwpart]);
freqs = allrw(:,1); allrw = allrw(:, 2:end);

absfocals = subsetind(focals);
rws = allrw(:, absfocals);

% strip any case with missing data for this tree
includeind = sum(rws<0, 2)==0;
rws = rws(includeind,:);
freqs = freqs(includeind);

% canonical label
for i = 1:size(rws,1)
  rws(i, :) = canonicallabel(rws(i, :));
end

% collect repeats
[uu,ii,jj] = unique(rws, 'rows');
for i = 1:length(ii)
  repeatind = find(jj==i);
  newfreqs(i) = sum(freqs(repeatind));
end

% sort by frequency
[s,sind] = sort(newfreqs, 'descend');
rwfreqs = transpose(s);
rwp= uu(sind,:);

outfile=[ps.outdir, ps.rwpartpref, num2str(treeind)];
save(outfile, 'rwfreqs', 'rwp');

