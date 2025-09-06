function scorecomplexity(x, ys, e, scoreind, r, randind, ps)

% compute complexities of a set of partitions

compfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 
if e == 5 || e == 7 || e == 8 || e == 11 | e == 12 | e == 14 | e == 15
  enumpfile= [ps.outdir, ps.linkoutpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];
else
  enumpfile= [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r)];
end

load(compfile, 'dependency', 'complexity', 'totalcomplexity', 'enumind', 'exm', 'exm_enum', 'enumindorig', 'rpairs');

% pick a single representative of each equivalence class according to
% enumind and merge dependencies and complexities

for i = 1:length(enumind)
  orig = enumind{i};
  if length(orig) > 1
    % make a new concept for this equivalence class
    newind = length(dependency)+1;
    dependency{newind} = {};
    totalcomplexity{newind} = -1*ones(length(orig),1);
    complexity{newind} = zeros(length(orig), 1);
    for j = 1:length(orig)
      dependency{newind} = [dependency{newind}; orig(j)];
    end
    [s,sind] = sort(totalcomplexity{newind});
    dependency{newind} = dependency{newind}(sind);
    totalcomplexity{newind} = totalcomplexity{newind}(sind);
    complexity{newind} = complexity{newind}(sind);
    enumind{i} = newind;
    rpairs(newind) = 0;
  end
end
newdlen = length(dependency);

% max of 180000 intensions

disp(sprintf('expanded dep size = %d: max is 180000', newdlen));
if (newdlen > 180000)
  error('change constants');
end
adjustind = logical(zeros(newdlen, 1));


% rearrange dependency file so that certain concepts come first: mother,
% father, daughter, son, sister, brother, sibling, maternal gp, paternal
% gp, maternal grandmother, maternal grandfather, paternal grandmother,
% paternal grandfather, sis of male, sis of female, bro of male, bro of
% female daughter of male, daughter of female, son of male, son of female

% The goal is to make sure that the most "natural" definitions are
% explored first in case the threshold (ps.nsearch) is reached and the
% search curtailed.

if x == 12 || x >= 14 % everything except cousins
  spec = {[7,39], [12,44], [23,55], [24,56], [15,16,47,48],[17,18,49,50],[15,16,17,18,47,48,49,50], [1,2,33,34], [3,4,35,36], [1,33], [2,34], [3,35], [4,36]};
  spind = [1,2,7,8]';
end

if x == 13 % cousin tree
  spec = {[2,18], [5,21], [11,27],[12,28],[11,12,27,28]};
  spind = [1,2]';
end


cinclude = [];
for j = 1:length(enumindorig)
  cinclude = [cinclude; enumindorig{j}];
end
exmsub = exm(cinclude,:);

for nsp = 1:length(spec)
  sp = spec{nsp};
  outsp = setdiff(1:size(exmsub,2), sp);
  thischunk = find(sum(exmsub(:,sp),2) == length(sp) & sum(exmsub(:,outsp),2)==0);
  spind = [spind; cinclude(thischunk)];
end

for i = 1:length(dependency)
  order = zeros(1, length(dependency{i}));
  for j = 1:length(dependency{i});
    order(j) = length(intersect(dependency{i}{j}, spind));
  end
  if ~isempty(order)
    [junk,newind] = sort(order, 'descend');
    dependency{i} = dependency{i}(newind);
    complexity{i} = complexity{i}(newind);
    totalcomplexity{i} = totalcomplexity{i}(newind);
  end
end

dinds = find(rpairs);
for i = 1:length(dinds)
  dind = dinds(i);
  rind = rpairs(dind);
  ds = [];
  for j = 1:length(dependency{dind})
    ds = [ds, dependency{dind}{j}];
  end
					% only add if defn not already there
  if min(totalcomplexity{dind} ~= 0) && sum(ds==rind)==0
    dependency{dind} = [dependency{dind}; rind];
    totalcomplexity{dind} = [totalcomplexity{dind}; min(totalcomplexity{rind})+3];
    complexity{dind} = [complexity{dind}; 3];
  else
    rpairs(dind) = 0;
  end
end

outfile = [ps.outdir, ps.complexpref, '_', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),'_rpt', num2str(r), '_rand', num2str(randind)];

enumindfile = [ps.outdir, 'enumind', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
complexityfile= [ps.outdir, 'complexity', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
totalcomplexityfile= [ps.outdir, 'totalcomplexity', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
rmatfile= [ps.outdir, 'rmat', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
dependencyfile= [ps.outdir, 'dependency', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];
optfile = [ps.outdir, 'cx', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e)];
enumind2text(enumind, enumindfile);
complex2text(complexity, complexityfile);
complex2text(totalcomplexity, totalcomplexityfile);
dependency2text(dependency, dependencyfile);
rpairs2text(rpairs, rmatfile);
partfile = [ps.outdir, 'dlinkout_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];
if (e ~= 5 &&  e~=3 && e ~= 7 && e ~= 8 && e ~= 11 && e ~= 12 && e ~= 14 && e ~=15)
  load(enumpfile, 'partitions')
  if x == 18

    % ISORT (argument to partitions2txt()) affects the order in which
    % partition components will be listed in the input file for
    % scorecomplexity. This may affect whether scorecomplexity finds the
    % true minimal complexity solution before hitting the threshold set
    % by ps.nsearch. 

    newexm = exm_enum(:, [1,2,7,8,3,4,5,6]); 
    [junk, isort, jsort] = unique(newexm, 'rows');
  else
    isort = [];
  end
  partitions2txt(partitions, partfile, 'order', isort);
  npart = size(partitions,1);
elseif e == 3
  npart = ps.nsamplepartition;
elseif e == 5 || e == 7 || e == 8 || e == 11 || e == 12  || e == 14 || e == 15
  fid= fopen(enumpfile, 'r');
  npart = getnpartitions(fid);
  fclose(fid)
end
splitsize = ceil(npart/ps.nsplit);
placeholders = {'psnsXX', 'outXX', 'partXX', 'enumXX', 'depXX', 'complexXX', 'totalcxcXX', 'rmatXX','rhXX'};
if ps.rheuristic <= 1
  rtmps = ps.rheuristic;
else
  rtmps = [0,1];
end
for rtmp = rtmps
  strings = {num2str(ps.nsearch), outfile, partfile, enumindfile, dependencyfile, complexityfile, totalcomplexityfile, rmatfile, num2str(rtmp)};
  if scoreind == 2
    % set up optfile
    [ss, sw] = system(['cp opt.template ', optfile, '.opt']); 
    for i = 1:length(placeholders)
      [ss, ww]=system(['perl -pi -e"s#', placeholders{i}, '#', strings{i}, '#g" ', optfile, '.opt']);
    end
    [ss, sw] = system(['scorecomplexity @', optfile, '.opt']); 
  elseif scoreind == 3
    % split partition file
    [ss, ww] = system(['split -a 1 -l ', num2str(splitsize), ' ', partfile, ' ', partfile, '__']);
    splitchars = 'a'*ones(1,26);
    splitchars = splitchars + (0:25);
    % make ps.nsplit optfiles
    for i = 1:ps.nsplit
      optfiles{i}= [optfile, '.opt', '__', char(splitchars(i))];
      [ss, sw] = system(['cp opt.template ', optfiles{i}]); 
      strings{2} = [outfile, '__', char(splitchars(i))];
      strings{3} = [partfile, '__', char(splitchars(i))];
      for j = 1:length(placeholders)
        [ss, ww]=system(['perl -pi -e"s#', placeholders{j}, '#', strings{j}, '#g" ', optfiles{i}]);
      end
    end
    % run in parallel
    %matlabpool('open', ps.parconf); 
    %parfor i = 1:ps.nsplit
    %  disp(sprintf('parallel job %d', i));
    %  [ss,ww] = system(['scorecomplexity @', optfiles{i}]);
    %end
    %matlabpool('close');

    % CK25
    %pool = parpool('local', ps.parnumWorkers);


    pool = gcp('nocreate'); % Get the current pool if it exists, but don't create one.
    if isempty(pool)
        % No pool exists, so create one.
        numWorkers = ps.parconf;
        pool = parpool('local', ps.parnumWorkers);
        % Use onCleanup to ensure the new pool is closed when the function finishes.
        c = onCleanup(@() delete(pool));
    end

    %pool = parpool('local', 8);
    % Ensure the pool is closed when done, even if errors occur
   % if ~isempty(pool)
   %   c = onCleanup(@() delete(pool));
      % Use parfor for parallel execution
      parfor i = 1:ps.nsplit
        disp(sprintf('parallel job %d', i));
        % Execute your system command within the parfor loop
        [ss, ww] = system(['scorecomplexity @', optfiles{i}]);
      end
   % end
    % END_CK25


    % combine output files
    [ss, ww] = system(['cat ', outfile, '__?', ' > ', outfile]);
    if (ps.rheuristic == 2)
      [ss, ww] = system(['mv ', outfile, ' ', outfile, '__rtmp', num2str(rtmp)]);
    end
  end
end

if (ps.rheuristic == 2) % combine scores
  [ss, ww] = system(['complexmin.pl ', outfile, '__rtmp0 ', outfile, '__rtmp1 ', outfile]);
  [ss, ww] = system(['rm ', outfile, '__rtmp0 ', outfile, '__rtmp1']);
end
