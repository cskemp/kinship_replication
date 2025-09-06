function makeenumset(x, ys, rawfile, focals, ps)

load(rawfile);

nhalf= div(size(exm,2),2);

% Make set for enumerating. 
enumind= find(sum(exm(:, (nhalf-1):end),2)==0);
s = sum(exm(enumind, 1:(nhalf-2)),2);
% strip any zero component
enumind = enumind(s~=0);
% Only include focals
exm_enum = exm(enumind,focals);
ex_enum = ex(enumind);

% can have repeats since different predicates can map to the same exm row
% strip repeats, using cxc (intrinsic complexity) to break ties
[uu, ii, jj] = unique(exm_enum, 'rows');

for i = 1:length(ii)
  repeatind = find(jj==i);
  allcxcs= cell2mat(totalcomplexity(enumind(repeatind)));
  [m,mind] = min(allcxcs);
  thiseind = [];
  clx = [];
  for j = 1:length(repeatind) 
    if  min(totalcomplexity{enumind(repeatind(j))}<=m+ps.nearmisstol)
      thiseind = [thiseind; enumind(repeatind(j))];
      clx = [clx; totalcomplexity{enumind(repeatind(j))}(1)];
    end
  end
  % sort by total complexity
  [s,sind] = sort(clx);
  enuminds{i} = thiseind(sind);
end

s = sum(exm_enum(ii,:),2);
% strip any zero component
iiinclude = find(s~=0);
ii = ii(iiinclude);

exm_enum = exm_enum(ii,:);
ex_enum = ex_enum(ii);

enumind = enuminds(iiinclude);

outfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

enumindorig = enumind;
save(outfile, 'ex', 'totalcomplexity', 'complexity', 'dependency', 'exm', 'enumind', 'exm_enum', 'ex_enum', 'enumindorig', 'rpairs');
