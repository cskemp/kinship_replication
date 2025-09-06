function plotsystems(x, ys, e, nvecind, r, randind, ps)

% make scatter plot to show where attested systems lie with respect to the
% optimal frontier. Used to generate Figs 4, S3 and S9.

if x == 13  % for Fig S3
  y2 = 6;
  rwenumkind = 20;
elseif ys(3) == 2 || ys(3) == 18 || ys(3) == 9  % conjunctive runs for Fig S9
  y2 = 1;
  rwenumkind = 2;
else  % Fig 4
  y2 = 1;
  rwenumkind = 1;
end

treenames = {'master', 'gp+gc', 'au+un+sib', 'grandparents', 'grandchildren', 'aunts', 'siblings', 'uncles'};

combocostfile = [ps.outdir, ps.combopref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(randind)];

cost = load('-ASCII', combocostfile);
partcomplexity = cost(:,1);
cost = cost(:,2);

rwcomplexityfile = [ps.outdir, ps.complexpref, '_', num2str(x), '_', num2str(y2), '_', num2str(1), '_', num2str(rwenumkind), '_', num2str(2), '_rpt', num2str(r), '_rand', num2str(0)];

rwcostfile = [ps.outdir, ps.costpref, '_', num2str(x), '_', num2str(y2), '_', num2str(1), '_', num2str(rwenumkind), '_', num2str(2), '_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(0)]; 

rwpartfile= [ps.outdir, ps.enumpref, num2str(x), '_', num2str(y2), '_', num2str(1), '_', num2str(rwenumkind), '_', num2str(2), '_rpt1'];

disp(rwpartfile)

rwt= load('-ASCII', rwcomplexityfile, 'partcomplexity'); 
rwc= load('-ASCII', rwcostfile, 'cost'); 
rwf= load(rwpartfile, 'rwfreqs');
rw.partcomplexity = ps.costs(1)*rwt(:,1)+ps.costs(2)*rwt(:,2);
rw.cost= rwc;
rwfreqs = rwf.rwfreqs;

fmax = max(rwfreqs);
fmax = 331;
interval = ((ps.dotmax) - (ps.dotmin))/(fmax-1);
dotsizes = ps.dotmin:interval:ps.dotmax;

figure(1); clf

axbg = [0.8, 0.8, 0.8];
subplot(2,1,1)
gray = [0.8, 0.8, 0.8];

hold on

% to reduce the filesize of the plot, only plot unique grey dots
[jnk, includeind, jj] = unique([partcomplexity, cost], 'rows');

if  x == 12
  dsz = 1;
else
  dsz = 24;
end


if  x == 12
scatter(partcomplexity(includeind), cost(includeind), '.', 'markeredgecolor', gray);
else
scatter(partcomplexity(includeind), cost(includeind), 'o', 'filled', 'sizedata', dsz, 'markeredgecolor', gray, 'markerfacecolor', gray);
end
for i = 1:length(rw.cost)
  scatter(rw.partcomplexity(i), rw.cost(i), 'ko','sizedata', dotsizes(rwfreqs(i)));
end
axis square;
v = axis;
xlabel('complexity');
ylabel('communicative cost');
titlestring = [ps.plotpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind)];

plotname =  [ps.plotdir, titlestring];

if (x == 12 ) && nvecind==6
  v = [0, 100, -.16, 4];
  axis(v);
  else
  v = [0, 100, -.16, 5];
  axis(v);
end

if x == 15 || x == 16
  v = [0, 17, -.08, 2.1];
  axis(v);
end
if  x == 17 || x == 19
  if sum(nvecind==[5,6])
  v = [0, 27, -.03, 0.42];
  axis(v);
  else
  v = [0, 27, -.08, 2.1];
  axis(v);
  end
end
if x == 18
  v = [0, 18, -.08, 2.08];
  axis(v);
end

if x == 13
  v = [0, 78, -.08, 1.8];
  axis(v);
end

if x == 14
  v = [0, 24, -.08, 2.08];
  axis(v);
end

set(gca, 'tickdir', 'out');
print(1, '-depsc', plotname);

