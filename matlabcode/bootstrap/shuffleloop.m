function shuffleloop(systemcs, nshuffle, i, ncomp, pairindmat, swapcands)

% edit path appropriately
outdir = '/Users/ckemp/modelruns/kinshipreleasetest/bootstrap/';

m = makeperm(systemcs, nshuffle, i, pairindmat, swapcands, ncomp);
smallm = m(:, 1:ncomp);
partitions2txt(smallm, [outdir, 'bootstrap', num2str(i), '_', num2str(nshuffle)]);
bootfile = [outdir, 'boot', num2str(i), '.opt'];
[s,w] = system(['cp boottemplatenib.opt ', bootfile]); 
outfile = [outdir, 'complex_', num2str(i), '_', num2str(nshuffle)];
partfile = [outdir, 'bootstrap', num2str(i), '_', num2str(nshuffle)];
strings = {outfile, partfile};
placeholders = {'outXX', 'partXX'};
for j = 1:length(placeholders)
  [ss, ww]=system(['perl -pi -e"s#', placeholders{j}, '#', strings{j}, '#g" ', bootfile]);
end
[s,w] = system(['scorecomplexity @', bootfile, ' &']); 

