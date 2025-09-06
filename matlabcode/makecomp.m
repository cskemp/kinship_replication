function makecomp(x, ys, cs, focals, reciprocalinds, ps)

% enumerate concepts that can be defined from a set of primitives
% concept structure CS has the following fields
%   PREDS{1}: unary relations
%   PREDS{2}: binary relations
%   EXM{1}, EXM{2}: ego-relative extensions corresponding to preds
%   DEPENDENTS: dependency map indicating how the concepts in PREDS were
%		defined
%   CX: complexities of the definitions of PREDS
%   CXC: intrinsic complexities of the definitions of PREDS

n = size(cs.preds{1},2);

npeople = size(cs.preds{2},1);
nonidR = not(logical(eye(npeople)));

depth = ps.depth;
news = emptystruct(n, ps);

rwcompflag = 0;
rwcompfile =[ps.outdir, ps.rwcomppref, num2str(x), '.mat'];
if exist(rwcompfile)
  rw = load(rwcompfile);
  rwcompflag = 1;
end

for d = 1:depth
  n1 = size(cs.preds{1},1);
  n2 = size(cs.preds{2},3);

  disp(sprintf('\n depth = %d, num = %d', d, n1+n2));
  news.nind = [1,1];
  if  d ==3 || d == depth % since the components introduced now won't be used in any defns
    ps.filterstrong= 1;         % don't add components that cross trees
    if x ~= 13  % NB: don't want filtering for initial cousin run
      ps.filtercompbyexm= 1;      % for final round can use exm to filter
    end
  end

  % one binary
  for j = 1:n2
    Rj = cs.preds{2}(:,:,j);
    % complement: R(x,y) <-> R(y,x)
    Rnew = transpose(Rj);
    news = add_reln(news, Rnew, [2,j], 3, 3+min(cs.cxc{2}{j}), ps);
    % symmetric closure: R(x,y) | R(y,x)
    Rnew = Rj | Rj';
    news = add_reln(news, Rnew, [2,j], 3, 3+min(cs.cxc{2}{j}), ps);
    % transitive closure: TC(R,R)
        % pull out original diagonal
    origdiag = diag(Rj,0);
    Rnewd = double(Rj)|eye(n);
    Rnew = logical(Rnewd^ps.tclosuremax & (ones(n)-eye(n)));
        % replace original diagonal
    Rnew = Rnew | diag(origdiag);
    news = add_reln(news, Rnew, [2,j], 3, 3+min(cs.cxc{2}{j}), ps);
  end

  % one unary one binary
  for i = 1:n1
    Ri = cs.preds{1}(i,:);
    Ri1 = zeros(n); Ri1(find(Ri),:) = 1;
    Ri2 = zeros(n); Ri2(:, find(Ri)) = 1;
    for j = 1:n2
      Rj = cs.preds{2}(:,:,j);
      if ps.conjflag
        %  conjunction: R(x,y) ^ R(x)
        Rnew = Ri1 & Rj;
        news = add_reln(news, Rnew, [1,i;2,j], 3, 3+min(cs.cxc{1}{i})+min(cs.cxc{2}{j}),ps);
        %  conjunction: R(x,y) ^ R(y)
        Rnew = Ri2 & Rj;
        news = add_reln(news, Rnew, [1,i;2,j], 3, 3+min(cs.cxc{1}{i})+min(cs.cxc{2}{j}),ps);
      end
      if ps.disjflag
        %  disjunction: R(x,y) | R(x)
        Rnew = (Ri1 | Rj) & nonidR;
        news = add_reln(news, Rnew, [1,i;2,j], 3, 3+min(cs.cxc{1}{i})+min(cs.cxc{2}{j}),ps);
        %  disjunction: R(x,y) | R(y)
        Rnew = (Ri2 | Rj) & nonidR;
        news = add_reln(news, Rnew, [1,i;2,j], 3, 3+min(cs.cxc{1}{i})+min(cs.cxc{2}{j}),ps);
      end
    end
  end
  
  % two binary
  fprintf('* %d:', n2); 
  for i = 1:n2
    Ri = cs.preds{2}(:,:,i);
    Rid = double(Ri);
    fprintf(' %d ', i); 
    if rem(i,20)==0
      fprintf('\n'); 
    end
    for j = 1:n2
      Rj = cs.preds{2}(:,:,j);
      Rjd = double(Rj);
      if j > i % don't need to add conjunctions, disjunctions twice
        if ps.conjflag
          % conjunction: R(x,y) ^ R(x,y)
          Rnew = Ri & Rj;
          news = add_reln(news, Rnew, [2,i;2,j], 3, 3+min(cs.cxc{2}{i})+min(cs.cxc{2}{j}), ps);
        end

        if ps.disjflag
          % disjunction: R(x,y) | R(x,y)
          Rnew = Ri | Rj;
          news = add_reln(news, Rnew, [2,i;2,j], 3, 3+min(cs.cxc{2}{i})+min(cs.cxc{2}{j}), ps);
	end
      end
      % combination: R(x,z) ^ R(z,y)
      Rnew = logical(Rid*Rjd) & nonidR;
      news = add_reln(news, Rnew, [2,i;2,j], 3, 3+min(cs.cxc{2}{i})+min(cs.cxc{2}{j}), ps);
    end
  end
  cs = mergecs(cs, news, ps);

  % if real world component file exists, show the most common real-world
  % components that don't appear in cs
  if rwcompflag
    new = [cs.exm{1}; cs.exm{2}];
    disp(sprintf('\nafter depth = %d', d));
    comp_compare(new, focals, rw.exm_enum, rw.rwcompfreqs);
  end
end

n1 = size(cs.preds{1},1);
n2 = size(cs.preds{2},3);

disp(sprintf('\n finish: depth = %d, num = %d', d, n1+n2));

outfileallcs= [ps.outdir, 'rawgencomponents', num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 

save(outfileallcs, 'x', 'ys', 'cs', 'focals', 'reciprocalinds', 'ps');

cs= postprocess_cs(x, ys, cs, focals, reciprocalinds, ps);
