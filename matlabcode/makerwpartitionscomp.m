function makerwpartitionscomp(compfile, x, ys, e, r, ps)

% get componentfile stuff
load(compfile, 'exm_enum');

ncomp= size(exm_enum,1);
npeople = size(exm_enum,2);

componentsm = logical(zeros(ncomp,2*npeople));
for i = 1:ncomp
  components{i} = find(exm_enum(i,:));
  componentsm(i,components{i})=1;
end

rwpartfile=[ps.outdir, ps.rwpartpref, num2str(x)];
load(rwpartfile, 'rwp', 'rwfreqs', 'orig_indices');

compactp = rwp;
npart = size(compactp,1);
partitions = logical(zeros(npart, ncomp));
includeind = logical(ones(1, npart));
for i = 1:npart
  m = max(compactp(i,:));
  for j = 1:m
    members = find(compactp(i,:)==j);
    nonmembers = setdiff(1:npeople, members);
    compind = find(sum(exm_enum(:,members),2)==length(members) & sum(exm_enum(:, nonmembers),2)==0); 
    if isempty(compind)
      includeind(i) = 0;
    else 
      partitions(i,compind) = 1;
    end
  end
end

partitions = partitions(includeind,:);
compactp = compactp(includeind,:);
rwfreqs = rwfreqs(includeind,:);
orig_indices = orig_indices(includeind);

outfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),  '_rpt', num2str(r)];

save(outfile, 'components', 'componentsm', 'partitions', 'compactp', 'rwfreqs')


% We've created the list of attested partitions (compatcp) that will be actually used in the analyses -- so create and write a mapping matrix [original_row_index, final_system_index] that lets us identify specific cultures among the attested systems
mapping = [];
for k = 1:length(orig_indices)
    prev_indices = transpose(orig_indices{k});  % Extract vector from cell k
    final_indices = repmat(k, length(prev_indices), 1);  % Create matching pattern indices
    mapping = [mapping; prev_indices, final_indices];  % Concatenate to mapping matrix
end

% Sort by prev row index for easier reading
mapping = sortrows(mapping, 1);

% Write to file
mapfile=[ps.extradir, ps.mapindex, num2str(x), '.csv'];
writematrix(mapping, mapfile, 'Delimiter', ',');


