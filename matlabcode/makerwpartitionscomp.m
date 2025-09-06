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
load(rwpartfile, 'rwp', 'rwfreqs');

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

outfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),  '_rpt', num2str(r)];

save(outfile, 'components', 'componentsm', 'partitions', 'compactp', 'rwfreqs')

