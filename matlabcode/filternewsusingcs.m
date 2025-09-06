function news = filternewsusingcs(news, cs, ps)

dim = 2;
ncands = size(news.preds{dim},1);
addind = logical(ones(ncands,1));

n = size(cs.preds{2},1);
nreln = size(cs.preds{2},3);

if ps.filtercompbyexm
  newds = news.exm{dim};
  oldds = cs.exm{dim};
else
  newds = news.preds{dim};
  if dim == 1
    oldds= cs.preds{dim};
  else
    oldds = transpose(reshape(cs.preds{dim}, n^2, nreln));
  end
end

for i = 1:size(oldds,1)
  r  = findrow(newds, oldds(i,:));  
  if ps.multidefn == 1
    expensivecands = find(news.cxc{dim}(r) > min(cs.cxc{dim}{i})+ps.nearmisstol);
  else
    expensivecands = 1:length(newinds);
  end
    addind(r(expensivecands)) = 0;
end


news.preds{dim} = news.preds{2}(addind,:);
news.dependents{dim} = news.dependents{dim}(addind);
news.cx{dim} = news.cx{dim}(addind);
news.cxc{dim} = news.cxc{dim}(addind);
news.exm{dim} = news.exm{dim}(addind,:);
  
