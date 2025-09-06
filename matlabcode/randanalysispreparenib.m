x = 12;
ys = [1,1,16];
e = 5;
r = 1;
nvecind = 6;

ps = setps;

combscorefile=  [ps.outdir, 'combinedscoreswithdup_' num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0', '_FILTER'];

rwfile = [ps.outdir, 'rwpartitions_tree', num2str(x)];

enumrwfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(2), '_rpt', num2str(r)];

enumrwscorefile= [ps.outdir, 'combinedscoreswithdup_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(2), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

ec = load(enumrwscorefile);

rwcomplex  = unique(ec(:,1));
rwcost     = unique(ec(:,2));
rwsize     = unique(ec(:,3));

complexequiv= {};
costequiv= {};
sizeequiv= {};


cc = load(combscorefile);

for i = 1:length(rwcomplex)
  disp(i);
  complexequiv{i} = find(cc(:,1) == rwcomplex(i));
end

for i = 1:length(rwcost)
  disp(i);
  costequiv{i} = find(cc(:,2) == rwcost(i));
end


outfile = [ps.outdir, 'complexcostequivnib', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r)];

save(outfile, 'complexequiv', 'costequiv', 'rwcomplex', 'rwcost', 'rwsize');


