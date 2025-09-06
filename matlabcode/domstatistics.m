function domstatistics(x, ys, e, vecind, r, randind, ps)

% compute dominance ranks for each partition of Tree X.

complexityfile = [ps.outdir, ps.complexpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '_rand', num2str(randind)]; ;

costfile = [ps.outdir, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(vecind), '_rpt', num2str(r), '_rand', num2str(randind)]; 

complex = load(complexityfile);
cost = load(costfile);

partcomplexity = ps.costs(1)*complex(:,1)+ps.costs(2)*complex(:,2);

disp('starting paretorank...');
domcount = paretorank(partcomplexity, cost);

domcount = zeros(size(cost));
for i = 1:length(cost)
  if rem(i, 40000) ==0
  disp(i)
  end
  bcnt= sum((partcomplexity<=partcomplexity(i)&cost<cost(i))|...
	      (partcomplexity<partcomplexity(i)&cost<=cost(i)));
  domcount(i) = bcnt;
end

enumpfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r)];
rwpartfile =   [ps.outdir, ps.rwpartpref, num2str(x)];

load(enumpfile, 'compactp');
load(rwpartfile, 'rwp', 'rwfreqs');

rwind = zeros(1, size(rwp,1));
for i = 1:size(rwp,1);
  % find entry corresponding to each real world partition
  kind = findrow(compactp, rwp(i,:));
  if ~isempty(kind)
    rwind(i) = kind;
  end
end

rwfreqs= rwfreqs(rwind>0);
rwind = rwind(rwind>0);

outfile= [ps.outdir, ps.domstatpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(vecind)];

allfreqs = domcount*0;
allfreqs(rwind) = rwfreqs;

if 1 % displaying systems
  % output results in format that matches the tables in the SOM
  tabprintfile= [ps.outdir, 'table_', num2str(x), '_', num2str(vecind)];
  fptr = fopen(tabprintfile, 'w');
  % include all attested partitions that appear twice or more, and all
  % partitions on the optimal frontier
  inclind = find(allfreqs>1 | domcount==0);
  [s,sind] = sort(allfreqs(inclind), 'descend');
  inclind = inclind(sind);
  results = [compactp(inclind,:), partcomplexity(inclind), cost(inclind), allfreqs(inclind), domcount(inclind)]
  for i = 1:length(inclind);
     fprintf(fptr, '%d ', compactp(inclind(i),:));
     fprintf(fptr, ' | ', compactp(inclind(i),:));
     fprintf(fptr, '%3d ', partcomplexity(inclind(i)));
     fprintf(fptr, '%.4f ', cost(inclind(i)));
     fprintf(fptr, '%3d ', [allfreqs(inclind(i)), domcount(inclind(i))]);   
     fprintf(fptr,'\n');
  end
  fclose(fptr);
end

save(outfile, 'domcount', 'rwind',  'rwfreqs');
