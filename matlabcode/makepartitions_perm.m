function makepartitions_perm(compfile, x, ys, e, r, ps)

load(compfile, 'exm_enum');

outfile = [ps.outdir, ps.linkoutpref, num2str(x), '_',  num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];

load('permanalysis/systemperms_nib');
load('permanalysis/rwperms_nib');
load('permanalysis/comppermmap_nib');

rwcomps = find(sum(rw.partitions,1));
rwcomplabs = zeros(1, size(rw.partitions,2));
ncomp = size(rwcomps,2);
rwcomplabs(rwcomps) = 1:ncomp;
totperm = size(allperms,1);

[sysinds, perminds]= find(rwpermindex);
nperm = length(sysinds);

fid = fopen(outfile,'w');

for i = 1:nperm
  sysind = sysinds(i);
  permind = perminds(i);
  comps = find(rw.partitions(sysind,:));
  newcomps = compmap(rwcomplabs(comps),permind);
  if sum(newcomps==-1)
    error('missing component!');
  end
  fprintf(fid, '%d ', newcomps);
  fprintf(fid, '\n');
end

fprintf(fid, 'Altogether %d solutions, after 103 updates\n', nperm);
fclose(fid)
