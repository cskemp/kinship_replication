function combine_rwdisj(x, ys, conjdisjind, ps)

% take intersection of conjunctive components, real world components, to
% create a set of real-world components with complexities

rwfile = [ps.outdir, ps.rwcomppref, num2str(x)];
conjfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(conjdisjind)]; 

rw = load(rwfile);
conj = load(conjfile);

nrw = size(rw.exm_enum,1);
for i = 1:nrw
  rwc = rw.exm_enum(i,:);
  mapind = findrow(conj.exm_enum, rwc);
  if ~isempty(mapind)
    enumind2rw(mapind) = i;
  end
end

ex = conj.ex;
totalcomplexity = conj.totalcomplexity;
complexity = conj.complexity;
dependency = conj.dependency;
exm = conj.exm;
rpairs= conj.rpairs;


includeind = find(enumind2rw > 0);

if ys(3) == 10  || ys(3) == 13 % only include components that appear twice or more
  incl = find(rw.rwcompfreqs(enumind2rw(includeind))>1);
  includeind = includeind(incl);
elseif ys(3) == 16 || ys(3) == 18  % components that appear three times or more
  incl = find(rw.rwcompfreqs(enumind2rw(includeind))>2);
  includeind = includeind(incl);
elseif ys(3) == 17  % components that appear four times or more
  incl = find(rw.rwcompfreqs(enumind2rw(includeind))>3);
  includeind = includeind(incl);
end


enumind = conj.enumind(includeind);
exm_enum = conj.exm_enum(includeind,:);
ex_enum = conj.ex_enum(includeind);
rwind = enumind2rw(includeind);
enumindorig = conj.enumindorig;

outfile= [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

save(outfile, 'ex', 'totalcomplexity', 'complexity', 'dependency', 'exm', 'rpairs', 'enumind', 'exm_enum', 'ex_enum', 'rwind', 'enumindorig');


