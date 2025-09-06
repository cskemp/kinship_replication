
ps = setps();
ys = [1,1,1];
e = 4;
nvecind = 6;

treenames = {'master', 'gp+gc', 'au+un+sib', 'grandparents', 'grandchildren', 'aunts', 'siblings', 'uncles', 'niblings'};

xs = [15:19,14];

for x = xs
  clf;
  subplot(2,3,1)
  domstatfile= [ps.outdir, ps.domstatpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind)];
  load(domstatfile);
  allfreqs = domcount*0;
  allfreqs(rwind) = rwfreqs;
  scatter(log(allfreqs+1.5), log(domcount+1.5), 20, 'ko');
  xlabel('frequency');
  ylabel('dominance rank');
  set(gca, 'tickdir', 'out') ;
  rwavgdom = sum(rwfreqs.*domcount(rwind))/sum(rwfreqs);
  totalavgdom = mean(domcount);
  labs = {sprintf('r. world = %.1f', rwavgdom),... 
	  sprintf('all = %.1f',  totalavgdom)};
  box off;
  titlestring = [ps.domplotpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind)];
  plotname =  [ps.plotdir, titlestring];

  ytsn = {'0', '9', '99', '999', '9999'};
  xtsn = {'0', '99'};
  v = axis; v(1) = 0; v(2) = log(360); v(4) = log(1900); axis(v);
  set(gca, 'ytick', log(1.5+[0,10,100,1000]), 'yticklabel', {'0', '10', '100', '1000'});
  set(gca, 'xtick', log(1.5+[0,10,100]), 'xticklabel', {'0', '10', '100'});
  print(1, '-depsc', plotname);

  allpfile= [ps.outdir, 'partitions_tree', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt1'];
  allp = load(allpfile);
  sz = max(allp.compactp, [], 2);
  usz = unique(sz);
  sizecom = [];
  for uind = 1:length(usz)
    u = usz(uind);
    sizecom(u) = mean(domcount(sz==u)); 
  end
  sizecom = sizecom';
  rwsz = sz(rwind);
  swdom = sum(rwfreqs/sum(rwfreqs).*sizecom(sz(rwind)));
  disp(sprintf('tree %d: size-based dom score %.2f', x, swdom));
  nodoms = setdiff(find(domcount==0), rwind);
  disp(allp.compactp(nodoms,:));
  alldomscores(x,:) = [rwavgdom, swdom, totalavgdom];
  disp(sprintf('rw zerodom: %d', sum(domcount(rwind)==0)));
  disp(domcount(rwind)');
end


