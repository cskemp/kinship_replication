function makerwpartitions(treeind, trees, ps)

subsetind = trees{treeind}{1};
focals = trees{treeind}{2};
allrw = load([ps.datadir, ps.masterrwpart]);
allrw_csv = load([ps.datadir, ps.masterrwpart]);
freqs = allrw(:,1); allrw = allrw(:, 2:end);

absfocals = subsetind(focals);
rws = allrw(:, absfocals);

% strip any case with missing data for this tree
includeind = sum(rws<0, 2)==0;
rws = rws(includeind,:);
freqs = freqs(includeind);
includerows = 1:length(includeind);
includerows = includerows(includeind);

% canonical label
for i = 1:size(rws,1)
  rws(i, :) = canonicallabel(rws(i, :));
end

% collect repeats
[uu,ii,jj] = unique(rws, 'rows');
original_rows = cell(length(uu), 1);
for i = 1:length(ii)
  repeatind = find(jj==i);
  newfreqs(i) = sum(freqs(repeatind));
  original_rows{i} = includerows(repeatind);
end

% sort by frequency
[s,sind] = sort(newfreqs, 'descend');
rwfreqs = transpose(s);
rwp= uu(sind,:);
% row i in rwp corresponds to systems in rows orig_indices{i} of ps.masterrwpart
orig_indices = original_rows(sind);


outfile=[ps.outdir, ps.rwpartpref, num2str(treeind)];
save(outfile, 'rwfreqs', 'rwp', 'orig_indices');
