function makecomponents(x, ys, trees, analyses, ps)

if ismember(x, [14,15,16,17,18,19]) && ismember(ys(3), [1,2,4,5])  % pull conjunctive components out of the master file 
  sts = subtreespecs(trees);
  focals= sts{12}{x};
  outfilebig= [ps.outdir, ps.compxpref, num2str(12), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 
  makeenumset_forsmall(x, ys, outfilebig, focals, ps);
elseif  ys(3) == 3 || ys(3) == 13 || ys(3) == 18 % intersect existing conj components with real-world components 
  combine_rwdisj(x, ys, 2, ps);
elseif  ys(3) == 7 % intersect existing disj components with real-world components 
  combine_rwdisj(x, ys, 1, ps);
elseif ys(3) == 9
  % combine conjunctive components with existing disjunctive components
  ssetfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(2)]; 
  combine_smallsetdisj(x, ys, 1, ps, 'smallsetfile', ssetfile);
elseif  ys(3) == 10 || ys(3) == 16 || ys(3) == 17 % intersect existing disj components with real-world components 
  combine_rwdisj(x, ys, 1, ps);
else % call cfunct to enumerate components
  subsetind = trees{x}{1};
  focals = trees{x}{2};
  
  baseinds = analyses.base{ys(1)};
  psetstruct = analyses.psetstruct{ys(2)};
  cfunct = analyses.cfunctions{ys(3)};
  
  % make base for this subset
  [preds, reciprocalinds] = componentbase(ps);
  
  preds{2} = preds{2}(:,:,baseinds);
  for i = 4:6
    psetstruct{i} = psetstruct{i}(baseinds);
  end
  
  % include only the individuals in current subset
  for i = 1:size(preds{1},1)
    treepreds{1}(i,:) = preds{1}(i, subsetind);
  end
  for i = 1:size(preds{2},3)
    treepreds{2}(:,:,i) = preds{2}(subsetind, subsetind, i);
  end
  preds = treepreds;
  
  cs.exm{1} = feat2exm(preds{1});
  cs.exm{2} = reln2exm(preds{2});
  cs.preds = preds;
  cs.dependents{1} = psetstruct{1};
  cs.cx{1} = psetstruct{2};
  cs.cxc{1} = psetstruct{3};
  cs.dependents{2} = psetstruct{4};
  cs.cx{2} = psetstruct{5};
  cs.cxc{2} = psetstruct{6};
  
  % reciprocalinds for this subset
  n = length(reciprocalinds);
  rmat = zeros(n);
  pairs = [1:n; reciprocalinds];
  pairs = pairs(:, reciprocalinds>0);
  matind = sub2ind(size(rmat), pairs(1,:), pairs(2,:));
  rmat(matind) = 1;
  rmat = rmat(subsetind,subsetind);
  [r c] = find(rmat);
  reciprocalinds = zeros(1, length(subsetind));
  reciprocalinds(r) = c;
  
  ps.depth    = analyses.depth(ys(3));
  ps.disjflag = analyses.disjflag(ys(3));
  ps.conjflag = analyses.conjflag(ys(3));
  % call composition function
  cfunct(x, ys, cs, focals, reciprocalinds, ps);
end

