
x  = 12;
ys = [1,1,16];
e = 5;
r = 1;
nvecind = 6;

ps = setps;

equivfile = [ps.outdir, 'complexcostequivnib', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r)];

load(equivfile);

combscorefile=  [ps.outdir, 'combinedscoreswithdup_' num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0', '_FILTER'];

cc = load(combscorefile);

enumrwscorefile= [ps.outdir, 'combinedscoreswithdup_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(2), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

ec = load(enumrwscorefile);
enumrwfile = [ps.outdir, ps.enumpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(2),  '_rpt', num2str(r)];
enumrw = load(enumrwfile);
freqs = enumrw.rwfreqs;

nperm = 1000;

nsys = size(ec,1);
for i = 1:nsys
  cmp = ec(i,1); cst = ec(i,2); sz = ec(i,3);
  cmpind = find(rwcomplex==cmp);
  cstind = find(rwcost==cst);
  csts{i} = cc(complexequiv{cmpind},2);
  cmps{i} = cc(costequiv{cstind},1);
  expcst(i) = mean(cc(complexequiv{cmpind},2));
  expcmp(i) = mean(cc(costequiv{cstind},1));
end


for i = 1:nperm
  for j = 1:nsys
    rcst(j) = csts{j}(unidrnd(length(csts{j})));  
    rcmp(j) = cmps{j}(unidrnd(length(cmps{j})));
  end
  permcst(i) = sum(rcst.*freqs')/sum(freqs);
  permcmp(i) = sum(rcmp.*freqs')/sum(freqs);
end

subplot(2,2,1)
hist(permcst);
v = axis;  v(1) = min([v(1), 0.95*mean(ec(:,2))]); axis(v);
line([mean(ec(:,2)),mean(ec(:,2))], [0, v(4)]);

subplot(2,2,3)
hist(permcmp);
v = axis;  v(1) = min([v(1), 0.95*mean(ec(:,1))]); axis(v);
line([mean(ec(:,1)),mean(ec(:,1))], [0, v(4)]);

outfile =  [ps.outdir, 'randanalysissummarynib' num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

save(outfile, 'ec', 'permcmp', 'permcst',  'expcst', 'expcmp', 'enumrw');

