
close all; 
nshuffle = 100000;
% edit path appropriately
rwcomplex= '/Users/ckemp/modelruns/kinshipreleasetest/complex_12_1_1_7_2_rpt1_rand0';
rwpart= '/Users/ckemp/modelruns/kinshipreleasetest/partitions_tree12_1_1_7_2_rpt1';

rwp = load(rwpart);
r = load(rwcomplex);
% because rwcomplex only has one token for each type
rwmean = sum(rwp.rwfreqs.*r(:,1))/sum(rwp.rwfreqs);
disp(sprintf('real world: %.2f', rwmean));

% edit path appropriately
outdir = '/Users/ckemp/modelruns/kinshipreleasetest/bootstrap/';

allcfiles= dir([outdir, 'complex_*_', num2str(nshuffle)]);
inds = [];
for i = 1:length(allcfiles)
  name = allcfiles(i).name;
  name = name(9:end);
  name = name(1:end-7);
  inds = [inds, str2num(name)];
end

cx = [];
keyboard
for i = inds;
  % note that each complex file has multiple tokens for each type
  complexfile= [outdir, 'complex_', num2str(i), '_', num2str(nshuffle)];
  l = load(complexfile);
  cx(i) = mean(l(:,1));
end

rwmean = rwmean/3;
cx = cx/3;

save('bootstrapsummary_disjnib', 'cx', 'rwmean');

