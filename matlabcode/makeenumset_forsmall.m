function makeenumset(x, ys, fulltreefile, focals, ps)

% extract components for subtree X from the set of full-tree components

load(fulltreefile);

if x == 14 % drop Alice's daughters from nibling tree
  outfocal = setdiff(1:size(exm_enum,2), [focals, 19,20]);
else
  outfocal = setdiff(1:size(exm_enum,2), focals);
end

includeind = sum(exm_enum(:, outfocal),2)==0;
smallenuminds = find(includeind);
exm_enum = exm_enum(:,focals);
s = sum(exm_enum(smallenuminds,:),2);
seinclude= find(s~=0);
smallenuminds = smallenuminds(seinclude);

exm_enum = exm_enum(smallenuminds,:);
ex_enum = ex_enum(smallenuminds);

senumind = {};
for i = 1:length(smallenuminds)
  senumind{i} = enumind{smallenuminds(i)};
end

enumind = transpose(senumind);

% now make uu unique (needed for nephews/nieces only)
[exm_enum,ii,jj] = unique(exm_enum, 'rows');
ex_enum = ex_enum(ii);
nenumind = {};
for i = 1:length(ii)
  inds = find(jj==i);
  nenumind{i} = cell2mat(enumind(inds));
end
enumind = nenumind;

outfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

save(outfile, 'ex', 'totalcomplexity', 'complexity', 'dependency', 'exm', 'enumind', 'exm_enum', 'ex_enum', 'enumindorig', 'rpairs');
