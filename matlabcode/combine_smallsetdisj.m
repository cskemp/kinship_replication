function combine_smallsetdisj(x, ys, conjdisjind, ps, varargin)

args = varargin;

smallsetfile= [ps.outdir, ps.compxpref, num2str(x), '_', num2str(4), '_', num2str(ys(2)), '_', num2str(5)]; 

for i = 1:2:length(args)
  switch args{i}
    case 'smallsetfile', smallsetfile = args{i+1};
  end
end

% take intersection of conjunctive components, disjunctive components, to
% create a set of conjunctive components with complexities

disjfile= [ps.outdir, ps.compxpref, num2str(x), '_', num2str(1), '_', num2str(ys(2)), '_', num2str(conjdisjind)]; 

ss= load(smallsetfile);
disj= load(disjfile);

nss = size(ss.exm_enum,1);
for i = 1:nss
  ssc = ss.exm_enum(i,:);
  mapind = findrow(disj.exm_enum, ssc);
  if ~isempty(mapind)
    enumind2ss(mapind) = i;
  end
end

ex = disj.ex;
totalcomplexity = disj.totalcomplexity;
complexity = disj.complexity;
dependency = disj.dependency;
exm = disj.exm;
rpairs= disj.rpairs;

includeind = find(enumind2ss > 0);
enumind = disj.enumind(includeind);
exm_enum = disj.exm_enum(includeind,:);
ex_enum = disj.ex_enum(includeind);
ssind = enumind2ss(includeind);
enumindorig = disj.enumindorig;

outfile= [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

save(outfile, 'ex', 'totalcomplexity', 'complexity', 'dependency', 'exm', 'rpairs', 'enumind', 'exm_enum', 'ex_enum', 'ssind', 'enumindorig');


