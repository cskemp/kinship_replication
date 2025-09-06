x  = 12;
ys = [1,1,16];
e = 5;
r = 1;
nvecind = 6;

ps = setps;

summfile =  [ps.outdir, 'randanalysissummarynib' num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

load(summfile);
bresults = load('bootstrap/bootstrapsummary_disjnib');


freqs = enumrw.rwfreqs;
mec    = sum([freqs, freqs].*ec(:, 1:2),1)/sum(freqs);
mexpcst= sum(freqs.*expcst')/sum(freqs);
mexpcmp= sum(freqs.*expcmp')/sum(freqs);



mec(1) = bresults.rwmean; 

xs = [mec(1), mec(1), mean(permcmp), mean(bresults.cx)];
ys = [mec(2), mean(permcst), mec(2), mec(2)];


clf;
subplot('position', [0.2, 0.2, 0.4, 0.35]);
hold on;
scatter(xs(2:4), ys(2:4), 'k.');
scatter(xs(1), ys(1), 64, 'kx');

[s,sind] = sort(permcst);

u = s(end-4) - mean(permcst);
l = mean(permcst)-s(5);

errorbar(xs(2), ys(2), l, u, 'color', [0 0 0]);

[s,sind] = sort(permcmp);
l = mean(permcmp)-s(5);
r = s(end-4) - mean(permcmp);

myherrorbar(xs(3), ys(3), l, r, 'k-');

v = axis;

bresults = load('bootstrap/bootstrapsummary_disjnib');
[s,sind] = sort(bresults.cx);
l = xs(4)-s(5);
r = s(end-4) - xs(4);
myherrorbar(xs(4), ys(4), l, r, 'k-');
axis square;

fs= 9;
set(gca, 'fontsize', fs);
xadj = 0.5;
yadj = 0.008;
text(xs(2)+xadj, ys(2), 'complexity matched', 'horizontalalign', 'left', 'fontsize', fs);
text(xs(3)+0, ys(3)+yadj, 'cost matched', 'horizontalalign', 'center', 'fontsize', fs);
text(xs(4)+0, ys(4)+yadj, 'shuffled', 'horizontalalign', 'center', 'fontsize', fs);


xlabel('complexity');
ylabel('communicative cost');

v(1) = 22.2; v(2) = 29; v(3) = 0.24; v(4) = 0.31; axis(v); 
set(gca, 'ytick', [0.25, 0.30, 0.35]);

plotname =  [ps.plotdir, 'randprofilenib_', num2str(nvecind)];

print(gcf, '-depsc', plotname);

