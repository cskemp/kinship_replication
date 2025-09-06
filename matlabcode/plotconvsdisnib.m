ps = setps();
nvecind = 6;

load(['convsdisplotdatanib_', num2str(nvecind)]);

treenames = {'master', 'gp+gc', 'au+un+sib', 'grandparents', 'grandchildren', 'mother + aunts', 'siblings', 'father + uncles', 'children + niblings'};


for x = [15,16,18,17,19,14]
  results(1,x) = mean(finalscoreds{x}(inis{x}));
  results(2,x) = mean(finalscoreds{x}(outis{x}));
end


fs = 9;
plotr = results(:, [15,16,18,17,19,14]);
plotr = plotr';
subplot('position', [0.5, 0.5, 0.2, 0.15]);
bar(plotr); colormap gray; box off;
v = axis; v(1) = 0.5; v(2) = 6.6; v(4) = 350; axis(v);
set(gca, 'ytick', [150,300], 'yticklabel', {'150','300'});
set(gca, 'xticklabel', [], 'fontsize', fs, 'xtick', []);
nameorder = [4,5,7,6,8,9];
for i = 1:6
  text(i, -10, treenames{nameorder(i)}, 'rotation', 90, 'horizontalalign', 'right', 'fontsize', fs);
end
plotname =  [ps.plotdir, 'convsdisnib', '_nvec', num2str(nvecind)];
set(gca, 'tickdir', 'out');

v = axis;
xinc1 = 0.05*(v(2)-v(1));
set(gca, 'yaxislocation', 'right', 'yticklabel', {});
text( (v(2)+xinc1)*ones(1, 3),  [0, 150,300], {'0', '150','300'}, 'rotation', 90, 'horizontalalign', 'center', 'verticalalign', 'top', 'fontsize', fs); 

h = ylabel('average rank');

xinc2 = 0.1*(v(2)-v(1));
hpos = get(h, 'position'); hpos(1) = hpos(1)+xinc2; set(h, 'position', hpos);

print(1, '-depsc', plotname);



