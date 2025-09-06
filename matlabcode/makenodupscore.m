function makenodupscore(x, ys, e, nvecind, r, randind, dupflag, ps)

% combine complexities and costs into a single file. 
%   if DUPFLAG == 0, strip duplicates
%   if DUPFLAG == 1, keep scores for all partitions


complexfile = [ps.outdir, ps.complexpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_rpt', num2str(r), '_rand', num2str(randind)];

costfile = [ps.outdir, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(randind)];


if dupflag == 0
  progname = 'combinescorecost_nodupes.pl';
  outfile= [ps.outdir, ps.combopref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(randind)];
else
  progname = 'combinescorecost.pl';
  outfile= [ps.outdir, ps.combopref, 'withdup_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(randind)];
end

[s,w] = system([progname, ' ', num2str(ps.costs(1)), ' ', num2str(ps.costs(2)), ' ', complexfile, ' ', costfile, ' ', outfile]);

