nvecind = 6;

% edit path appropriately

ps.plotdir = '/Users/ckemp/modelruns/kinshipreleasetest/plots/';

load(['permresultsnib_', num2str(nvecind)]);

fileprefs = {'permallnib_', 'permgpgcnib', 'permsibmatsibnib', 'permsibpatsibnib'};

results = [sum(permsummaryfreq,2), permsummaryfreq(:, [2913,3521,3585])];

results = results([2,3,4,1],:);

labs = {'better', 'equal', 'indet.',  'worse'};
yticks{1} = [0,200000,400000];
ylabs{1} = {'0', '200', '400'};
yname{1} = {'frequency',  '(ten thousands)'};
for k = 2:4
  yticks{k} = [0,100,200];
  ylabs{k} = {'0', '100', '200'};
  yname{k} = {'frequency'};
end
axs = [400000,200,200,200];

figure(1);
clf;
fontsize = 9; 
pwid = 0.2; ph = 0.125;

for i = 1:length(fileprefs)
  clf;
  subplot('position', [0.2, 0.2, pwid, ph]);
  plotname =  [ps.plotdir, fileprefs{i}, num2str(nvecind)];
  set(gca, 'fontsize', fontsize);
  bar(results(:, i), 'k');
  um = axis;  v(1) = 0.2; v(2) = 4.8; v(4) = axs(i); axis(v);
  %v(4) = 240; axis(v);
  box off;
  xinc1 = 0.05*(v(2)-v(1));
  xinc2 = 0.1*(v(2)-v(1));
  yinc= 0.03*(v(4)-v(3));

  set(gca, 'tickdir', 'out');
  set(gca, 'xticklabel', [], 'fontsize', fontsize, 'xtick', []);
  set(gca, 'yaxislocation', 'right','yticklabel', {});
  xs = 1:4;
  if i == 1 || i == 3
  for j = 1:4
    text(xs(j), -yinc, labs{j}, 'rotation', 90, 'horizontalalign', 'right', 'fontsize', fontsize);
  end
  end
  text( (v(2)+xinc1)*ones(1, 3),  yticks{i}, ylabs{i}, 'rotation', 90, 'horizontalalign', 'center', 'verticalalign', 'top', 'fontsize', fontsize); 
  h = ylabel(yname{i});
  hpos = get(h, 'position'); hpos(1) = hpos(1)+xinc2; set(h, 'position', hpos);
  keyboard
  print(gcf, '-depsc', plotname);
end


