function makecomp_cousin(x, ys, cs, focals, reciprocalinds, ps)

n = size(cs.preds{1},2);
npeople = size(cs.preds{2},1);
nonidR = not(logical(eye(npeople)));

% we'll add to the results of conjunctive enumeration for cousins tree
a = load([ps.outdir, 'rawgencomponents13_1_1_2']);
prevcs = a.cs;
clear('a');

% add relations for transitive closure of daughter of female, transitive
% closure of son of male 
tcbaseinds = [1544,1103];
for tcind = 1:2
  tcbaseind = tcbaseinds(tcind);
  Rj = prevcs.preds{2}(:,:,tcbaseind);
  % transitive closure: TC(R,R)
        % pull out original diagonal
    origdiag = diag(Rj,0);
    Rnewd = double(Rj)|eye(n);
    Rnew = logical(Rnewd^ps.tclosuremax & (ones(n)-eye(n)));
        % replace original diagonal
    Rnew = Rnew | diag(origdiag);

    addrow = transpose(reshape(Rnew, n^2, 1));
    prevcs.exm{2}(end+1,:) = reln2exm(Rnew);
    prevcs.preds{2}(:,:,end+1) = Rnew;
    prevcs.dependents{2}{end+1,1} = {[2,tcbaseind]};
    prevcs.cx{2}{end+1,1} = 3;
    prevcs.cxc{2}{end+1,1} = 3+min(prevcs.cxc{2}{tcbaseind});
end

nprevreln = size(prevcs.preds{2}, 3);
prevds = transpose(reshape(prevcs.preds{2}, n^2, nprevreln));

ginds = {1:11, 12:22, 23:33, 34:44, 45:55};
                     %6    7    8    9   10    11  12
pairs = [zeros(5,2); 1,1; 3,1; 4,1; 2,6; 2,7; 5,8; 2,9];

% find indices corresponding to the relations we need

for gind = 1:5
  rs{gind} = cs.preds{2}(:,:, ginds{gind});
  thisg = zeros(1, size(rs{gind},3));
  for j = 1:size(rs{gind},3)
    rj = transpose(reshape(rs{gind}(:,:,j), n^2, 1));
    prevind = findrow(prevds, rj);
    if isempty(prevind)
      keyboard % one of the relations we need is missing from prevcs
    else
      thisg(j) = prevind;
    end
  end
  gindsprev{gind} = thisg;
end

allinds = cell2mat(gindsprev);
% add in same sex, diff sex primitives
allinds = unique([allinds, 3,4]); % there are repeats in allinds, which makes sense
		         	  % mother of m is the same as mother of m tc.

% Filter prevcs to include only relations in allinds
rmap = zeros(size(prevcs.exm{2},1),1);
rmap(allinds) = 1:length(allinds);

for i = 1:length(gindsprev)
  gindsprev{i} = rmap(gindsprev{i});
end

for ai = allinds 	
  ods = prevcs.dependents{2}{ai};
  newods = cell(0,1);
  for odi = 1:size(ods,1)
    validflag = 1;
    od = ods{odi};
    for rj = 1:size(od,1)
      if od(rj,1) == 2
        od(rj,2) = rmap(od(rj,2));
	if od(rj,2) == 0
 	  validflag = 0;
	end
      end
    end
    if validflag
      newods{end+1,1} = od;
    end
  end
  if ~isempty(ods) && isempty(newods)
    keyboard % we have a problem -- the concept can't be defined using relations in allinds
  end
  prevcs.dependents{2}{ai} = newods;
end

prevcs.exm{2} = prevcs.exm{2}(allinds,:);
prevcs.preds{2} = prevcs.preds{2}(:,:,allinds);
prevcs.dependents{2} = prevcs.dependents{2}(allinds);
prevcs.cx{2} = prevcs.cx{2}(allinds);
prevcs.cxc{2} = prevcs.cxc{2}(allinds);

news = emptystruct(n, ps);

% want to keep all definitions
ps.nearmisstol = 10000000;

for gind = 6:size(pairs,1)
  disp(gind);
  news.nind = [1,1];
  p1 = pairs(gind,1); p2 = pairs(gind,2);
  n1 = size(rs{p1},3); n2 = size(rs{p2},3);
  cnt = 1;
  for i = 1:n1
    indi = gindsprev{p1}(i);
    Ri = rs{p1}(:,:,i);
    Rid = double(Ri);
    for j = 1:n2;
      indj = gindsprev{p2}(j);
      Rj = rs{p2}(:,:,j);
      Rjd = double(Rj);
      % combination: R(x,z) ^ R(z,y)
      Rnew = logical(Rid*Rjd) & nonidR;
      if sum(sum(Rnew))
        news = add_reln(news, Rnew, [2,indi;2,indj], 3, 3+min(prevcs.cxc{2}{indi})+min(prevcs.cxc{2}{indj}), ps);
	% need to build up rs anyway
        rs{gind}(:,:,cnt) = Rnew; 
        rows{gind}(cnt,:) = transpose(reshape(Rnew, n^2, 1));
        cnt = cnt+1;
	
      end
    end
  end
  disp('pre merge...');
  prevcs = mergecs(prevcs, news, ps);
  disp('post merge...');

  [uu,ii,jj] = unique(rows{gind}, 'rows', 'first');
  rows{gind} = uu;
  rs{gind} = rs{gind}(:,:,ii);
  for k = 1:size(rs{gind},3)
    exm{gind}(k,:) = reln2exm(rs{gind}(:,:,k));
  end

  gindsprev{gind} = zeros(1, size(rs{gind},3));
  nprevreln = size(prevcs.preds{2}, 3);
  prevds = transpose(reshape(prevcs.preds{2}, n^2, nprevreln));
  for k = 1:size(rs{gind},3)
    rk = transpose(reshape(rs{gind}(:,:,k), n^2, 1));
    prevind = findrow(prevds, rk);
    gindsprev{gind}(k) = prevind;
  end
end

Rmf{1} = zeros(n); Rmf{1}(find(cs.preds{1}(1,:)),:) = 1;
Rmf{2} = zeros(n); Rmf{2}(:,find(cs.preds{1}(1,:))) = 1;
Rmf{3} = zeros(n); Rmf{3}(find(cs.preds{1}(2,:)),:) = 1;
Rmf{4} = zeros(n); Rmf{4}(:,find(cs.preds{1}(2,:))) = 1;
% same sex, diff sex
Rmf{5} = prevcs.preds{2}(:,:,3); 
Rmf{6} = prevcs.preds{2}(:,:,4); 


% add conjunctions with male, female, same sex, diff sex

mfarity= [1,1,1,1,2,2];
mfinds = [1,1,2,2,3,4];

news.nind = [1,1];
for i = 1:length(rs)
  for j = 1:size(rs{i},3)
    indj = gindsprev{i}(j);
    R = rs{i}(:,:,j);
    for k = 1:length(mfarity)
      Rnew = R & Rmf{k};
        if sum(sum(Rnew~=R))
      news = add_reln(news, Rnew, [mfarity(k),mfinds(k);2,indj], 3, 3+min(prevcs.cxc{2}{indj}), ps);
	end
    end
  end
end

disp('pre merge...');
cs = mergecs(prevcs, news, ps);
clear prevcs;
disp('post merge...');

n1 = size(cs.preds{1},1);
n2 = size(cs.preds{2},3);

disp(sprintf('\n finish: cousin with complexity, num = %d', n1+n2));

outfileallcs= [ps.outdir, 'rawgencomponents', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

save(outfileallcs, 'x', 'ys', 'cs', 'focals', 'reciprocalinds', 'ps');

cs= postprocess_cs(x, ys, cs, focals, reciprocalinds, ps);

