function cs = mergecs(cs, news, ps)

% combine CS with NEWS

n = size(cs.preds{2},1);
nreln = size(cs.preds{2},3);

nnz = news.nind(2)-1;
if nnz == 0
  return;
end
news = strip_duplicates(news, 1:nnz, ps);

nnz = news.nind(2)-1;
news.preds{2}      = news.preds{2}(1:nnz,:);
news.dependents{2} = news.dependents{2}(1:nnz);
news.cx{2} = news.cx{2}(1:nnz);
news.cxc{2} = news.cxc{2}(1:nnz);
news.exm{2} = news.exm{2}(1:nnz,:);

% strip items from news that are duplicated with better scores in cs
% (filter by exm if ps.filtercompbyexm is set)
news = filternewsusingcs(news, cs, ps);

% fold up news
news = foldnews(news, ps);

% combine folded news with cs
cs = mergecs_foldednews(cs, news, ps);

