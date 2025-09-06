function news = foldnews(oldnews, ps)

dim = 2;

[uu,ii,jj] = unique(oldnews.preds{dim}, 'rows', 'first');
news.preds{dim}  = uu;
news.exm{dim} = oldnews.exm{dim}(ii,:);
for i = 1:length(ii)
    repeatind = find(jj==i);
    news.dependents{dim}{i} = oldnews.dependents{dim}(repeatind);
    news.cx{dim}{i} = oldnews.cx{dim}(repeatind);
    news.cxc{dim}{i} = oldnews.cxc{dim}(repeatind);
end
