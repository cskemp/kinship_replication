function [cs, exm] = postprocess_cs(x, ys, cs, focals, reciprocalinds, ps)

exm = [cs.exm{1}; cs.exm{2}];
cx =  [cs.cx{1}; cs.cx{2}];
cxc = [cs.cxc{1}; cs.cxc{2}];
dependents = [cs.dependents{1}; cs.dependents{2}];


n = size(cs.preds{2},1);
nreln = size(cs.preds{2},3);
fullpredmat = transpose(reshape(cs.preds{2}, n^2, nreln));
preds2transpose = permute(cs.preds{2}, [2,1,3]);
fullpredtransmat= transpose(reshape(preds2transpose, n^2, nreln));

[c, ia, ib] = intersect(fullpredmat, fullpredtransmat, 'rows');
rpairs = zeros(nreln+2,1);
rpairs(ia+2) = ib+2;
idind = find(rpairs'==1:length(rpairs));
rpairs(idind) = 0;

% offset: adjust indices in dependency map for binary predicates 
offset = length(cs.dependents{1});
for i = 1:length(dependents)
  dpi = dependents{i};
  l = length(dependents{i});
  if l > 0
    cs = {};
    for j = 1:l
      offind = find(dpi{j}(:,1)==2);
      dpi{j}(offind,2) = dpi{j}(offind,2)+offset;
      % strip repeated indices in each dependency list
      depnew{i}{j} = unique(dpi{j}(:,2)');
      cs{j} = num2str(depnew{i}{j});
    end
    cmat = char(cs);
    % strip cases where we have multiple copies of the same dependency list
    %   for a given concept
    [uu,ii,jj] = unique(cmat, 'rows', 'first');
    %  make sure we pick case of minimum total complexity (think we'll
    %  always pick such a case anyway, but doesn't hurt to make sure 
    for iind = 1:length(ii)
      repeatind = find(jj==iind);
      [m,mind] = min(cxc{i}(repeatind));
      ii(iind) = repeatind(mind);
    end
    depnew{i} = transpose(depnew{i}(ii));
    cx{i} = cx{i}(ii);
    cxc{i} = cxc{i}(ii);
  else
    depnew{i} = [];
  end
end

dependency = depnew;

for i = 1:size(exm,1)
  ex{i} = find(exm(i,:));
end

totalcomplexity = cxc;
complexity = cx;

outfileraw = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_all']; 

save(outfileraw, 'ex', 'totalcomplexity', 'complexity', 'dependency', 'exm', 'rpairs');

makeenumsetnew(x, ys, outfileraw, focals, ps);
