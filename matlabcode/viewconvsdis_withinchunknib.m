ps = setps();
ts = maketreespecs;
sts = subtreespecs(ts);
x = 12;
ys = [1,1,1];
e = 4;
vecind = 6;
r = 1;
randind = 0;

load('condis_specsnib');

% want order gp, gc, sib, aunt, uncle, nib
is(14:19) = [6,1,2,4,3,5];

% 
chunklabels = {'gp', 'gc', 'sib', 'aunt', 'uncle', 'nib'};

for x = 14:19 
  complexityfile = [ps.outdir, ps.complexpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '_rand', num2str(randind)]; ;
  
  costfile = [ps.outdir, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(vecind), '_rpt', num2str(r), '_rand', num2str(randind)];

  domfile = [ps.outdir, ps.domstatpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(vecind)];     

  complex = load(complexityfile);
  partcomplexity = ps.costs(1)*complex(:,1);
  cost = load(costfile);
  doms = load(domfile);

  enumpfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r)];
 
  compfile= [ps.outdir, ps.compxpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))];

  parts = load(enumpfile);
  comps = load(compfile);

  i = is(x);

  alldisj = enums{1}(chunkcinds{i}{1},:);  
  allconj = enums{2}(chunkcinds{i}{2},:);  
  allrw   = enums{3}(chunkcinds{i}{3},:);  
  ncomp = size(parts.componentsm,1);
  npeople = size(parts.componentsm,2);
  npeople = npeople/2;
 
  thischunkcs = false(ncomp, 56);
  thischunkcs(:, sts{12}{x}) = parts.componentsm(:, 1:npeople);
  
  % ini: conjunctive categories w.r.t ordering in parts.componentsm
  [int, ini, ij] = intersect(thischunkcs, allconj, 'rows');
  % outi: conjunctive categories w.r.t ordering in parts.componentsm
  outi = setdiff(1:ncomp, ini);
  % inrwi: indices of real world categories
  [jk , inrwi, ij] = intersect(thischunkcs, allrw, 'rows');
  % conjnotrwi: conj but not rw
  conjnotrwi = setdiff(ini, inrwi);
  % disjnotrwi: disj but not rw
  disjnotrwi= setdiff(outi, inrwi);

  % partitions built from conjunctive indices
  conjpind = find(sum(parts.partitions(:, ini),2)==sum(parts.partitions,2));
  disjpind = find(sum(parts.partitions(:, outi),2)==sum(parts.partitions,2));
  mixpind = find(sum(parts.partitions(:, outi),2) & sum(parts.partitions(:, ini),2));

  finalscore = [];
  finalscoremean = [];
  finalscored = [];
  finalscoredmean = [];
  for compind = 1:ncomp
    % partinds: all partitions that include compind
    partinds = find(parts.partitions(:, compind));
    finalscore(compind,1) = min(partcomplexity(partinds));
    finalscore(compind,2) = min(cost(partinds));
    finalscored(compind) = min(doms.domcount(partinds));

    finalscoremean(compind,1) = mean(partcomplexity(partinds));
    finalscoremean(compind,2) = mean(cost(partinds));
    finalscoredmean(compind) = mean(doms.domcount(partinds));
  end

  partcomplexities{x} = partcomplexity;
  costs{x} = cost;
  finalscoreds{x} = finalscored;
  inis{x} = ini;
  outis{x} = outi;
  inrwis{x} = inrwi;

  disp(sprintf('chunk %d: %s', i, chunklabels{i}));
  disp(sprintf('  conjp %.2f %.4f %d', mean(partcomplexity(conjpind)), mean(cost(conjpind)), length(conjpind)));
  disp(sprintf('  disjp %.2f %.4f %d', mean(partcomplexity(disjpind)), mean(cost(disjpind)), length(disjpind)));
  disp(sprintf('  mixp  %.2f %.4f %d', mean(partcomplexity(mixpind)), mean(cost(mixpind)), length(mixpind)));
  disp('---');
  disp(sprintf('  conj   %.2f %.2f | %.2f %.4f | %.2f %.4f %d', mean(finalscored(ini)), mean(finalscoredmean(ini)), mean(finalscore(ini,1)), mean(finalscore(ini,2)), mean(finalscoremean(ini,1)), mean(finalscoremean(ini,2)), length(ini)));
  disp(sprintf('  disj   %.2f %.2f | %.2f %.4f | %.2f %.4f %d', mean(finalscored(outi)), mean(finalscoredmean(outi)), mean(finalscore(outi,1)), mean(finalscore(outi,2)), mean(finalscoremean(outi,1)), mean(finalscoremean(outi,2)),length(outi)));
  disp(sprintf('  cjnorw %.2f %.2f | %.2f %.4f | %.2f %.4f %d', mean(finalscored(conjnotrwi)), mean(finalscoredmean(conjnotrwi)),  mean(finalscore(conjnotrwi,1)), mean(finalscore(conjnotrwi,2)), mean(finalscoremean(conjnotrwi,1)), mean(finalscoremean(conjnotrwi,2)),length(conjnotrwi)));
  disp(sprintf('  djnorw %.2f %.2f | %.2f %.4f | %.2f %.4f %d', mean(finalscored(disjnotrwi)), mean(finalscoredmean(disjnotrwi)),mean(finalscore(disjnotrwi,1)), mean(finalscore(disjnotrwi,2)), mean(finalscoremean(disjnotrwi,1)), mean(finalscoremean(disjnotrwi,2)),length(disjnotrwi)));
  disp(sprintf('  realw  %.2f %.2f | %.2f %.4f | %.2f %.4f %d', mean(finalscored(inrwi)), mean(finalscoredmean(inrwi)), mean(finalscore(inrwi,1)), mean(finalscore(inrwi,2)), mean(finalscoremean(ini,1)), mean(finalscoremean(ini,2)), length(inrwi)));
  disp('****************');
end

save(['convsdisplotdatanib_',num2str(vecind)], 'partcomplexities', 'costs', 'inis', 'outis', 'inrwis', 'finalscoreds');
