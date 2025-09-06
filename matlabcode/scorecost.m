function scorecost(x, ys, e, nvecind, r, randind, ss, ps)

% compute communicative cost for partitions using need probability vector
% NVECIND

compfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 
if e == 5 || e == 7 || e == 8 || e == 11 || e == 12 || e == 14 || e == 15
  enumpfile= [ps.outdir, ps.linkoutpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];
else
  enumpfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r)];
end

if nvecind == 8 % stable population analysis
  origps = ps;
  nrun = size(ss.needp{nvecind}{x},1);
  costtot = 0;
  for j = 1:nrun 
    % set up needp for this run
    ss.needp{9}{x} = ss.needp{8}{x}(j,:);
    scorecost(x, ys, e, 9, r, randind, ss, ps);
    outfile = [ps.outdirtmp, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(9), '_rpt', num2str(r), '_rand', num2str(randind)];
    cost = load(outfile);
    costtot = costtot+ss.vecprob{8}{x}(j)*cost;
  end
  % compile results
  outfile = [ps.outdir, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(8), '_rpt', num2str(r), '_rand', num2str(randind)];
  cost2txt(costtot,outfile); 
else
  needp = ss.needp{nvecind}{x};
  npeople= size(needp,2);
  % individuals 1:nhalf are in the first speaker's family tree
  if x == 14   % niblings
    nhalf = 10; % only one speaker -- Bob
  elseif x == 12
    nhalf= 24; % first speaker is Alice, who has 24 relatives in her tree
  
    % Bob has more individuals in his family tree than Alice. We normalize
    % so that the two trees have the same total probability mass -- which
    % means that the overall commmunicate cost will end up being the average
    % for Alice and Bob.
    needp(1:nhalf) = 0.5*needp(1:nhalf)/sum(needp(1:nhalf));
    needp(nhalf+1:end) = 0.5*needp(nhalf+1:end)/sum(needp(nhalf+1:end));
  else
    nhalf = npeople/2;
  end
  
  if nvecind == 9
    outpref = ps.outdirtmp;
  else
    outpref = ps.outdir;
  end
  
  outfile = [outpref, ps.costpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_', num2str(nvecind), '_rpt', num2str(r), '_rand', num2str(randind)];
   
  if (e ~= 5 && e~=3 && e ~= 7 && e ~= 8 && e ~= 11 && e ~= 12 && e ~= 14 && e~=15)
    load(enumpfile, 'partitions');
    partfile = [outpref, 'dlinkout_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];
    partitions2txt(partitions, partfile);
  end
  
  compexfile = [outpref, 'compex', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
  load(compfile, 'exm_enum');
  exmenum2text(exm_enum, compexfile);
  needpfile= [outpref, 'needprobs', num2str(x),  '_', num2str(nvecind), '.txt'];
  needprob2text(needp, needpfile);
  partfile = [ps.outdir, 'dlinkout_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt',  num2str(r), '.txt'];
  placeholders = {'outXX', 'partXX', 'compXX', 'needXX', 'nhalfXX'};
  strings = {outfile, partfile, compexfile, needpfile, num2str(nhalf)};
  optfile = [ps.outdir, 'cost', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind)];
  
  % set up optfile
  [ss, sw] = system(['cp costopt.template ', optfile, '.opt']); 
  for i = 1:length(placeholders)
    [ss, ww]=system(['perl -pi -e"s#', placeholders{i}, '#', strings{i}, '#g" ', optfile, '.opt']);
  end
  [ss, sw] = system(['scorecost @', optfile, '.opt']); 
end
  
