function news = add_reln(news, Rnew, deps, cx, cxc, ps);

% add Rnew to structure news
%   deps: dependents
%   cx:   complexity
%   cxc:  intrinsic complexity

dim = size(Rnew,1);
if dim > 1
  dim = 2;
end

if dim == 2
    exmrow= reln2exm(Rnew);
else
    exmrow= feat2exm(Rnew);
end


nhalf = div(length(exmrow),2);
nquart = div(nhalf,2)-1;
p1 = [1:nquart, nhalf-1];
p2 = [(nquart+1):2*nquart, nhalf];



if ps.filterstrong
  if sum(exmrow(nhalf-1:end)) > 0 || sum(sum(Rnew(p1,p2))) || sum(sum(Rnew(p2,p1))) || sum(exmrow) == 0 
    return % don't add empty row or relation that crosses family trees
  end
elseif ps.filtercompbyexm % we're keeping all distinct exms
  if sum(exmrow) == 0 % don't add empty exm row
    return
  end
else % better in principle: we're using exm to strip duplicates
  if sum(Rnew(:)) == 0  % don't add empty relation
    return
  end
end

ninds = news.nind;

n = size(Rnew,2);
addflag = 0;
if dim == 2
  addrow = transpose(reshape(Rnew, n^2, 1));
else
  addrow = Rnew;
end

nind = ninds(dim);
news.preds{dim}(nind,:) = addrow;
news.exm{dim}(nind,:) = exmrow;
news.dependents{dim}{nind,1} = deps;
news.cx{dim}(nind,1) = cx;
news.cxc{dim}(nind,1) = cxc;
news.nind(dim) = news.nind(dim)+1;
news.repeatcount = news.repeatcount+1;

if news.repeatcount >= ps.repeatcountstrip
  % strip
  disp('strip duplicates')
  nnz = news.nind(2)-1;
  lnz = max([nnz - ps.repeatcountstrip, 1]);
  range = lnz:nnz;
  news = strip_duplicates(news, range, ps);
end

if news.nind(dim) == length(news.cx{dim}) 
  disp('resize data structures')
  m = ps.memchunksize;
  n = size(news.preds{dim},2);
  news.preds{dim} = [news.preds{dim}; false(m, n)];
  news.dependents{dim} = [news.dependents{dim}; cell(m,1)];
  news.cx{dim} = [news.cx{dim}; zeros(m,1)];
  news.cxc{dim} = [news.cxc{dim}; zeros(m,1)];
  news.exm{dim} = [news.exm{dim}; zeros(m,size(news.exm{dim},2))];
end
