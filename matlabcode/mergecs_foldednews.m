function cs = mergecs_foldednews(cs, news, ps)

n = size(cs.preds{2},1);
nreln = size(cs.preds{2},3);

% add some items in news to interior of cs
cspreds= transpose(reshape(cs.preds{2}, n^2, nreln));

addind = true(size(news.preds{2},1),1);

for i = 1:size(cspreds,1)
  [r,newinds] = findrow(news.preds{2}, cspreds(i,:));  
  if ~isempty(r)
			     % added for cousins
    if min(news.cxc{2}{r}) + ps.nearmisstol < min(cs.cxc{2}{i}) % new defn actually better
      disp('new defn better');
      cs.dependents{2}{i} = [news.dependents{2}{r}]; 
      cs.cx{2}{i} = [news.cx{2}{r}]; 
      cs.cxc{2}{i} = [news.cxc{2}{r}]; 
    else
      cs.dependents{2}{i} = [cs.dependents{2}{i}; news.dependents{2}{r}]; 
      cs.cx{2}{i} = [cs.cx{2}{i}; news.cx{2}{r}]; 
      cs.cxc{2}{i} = [cs.cxc{2}{i}; news.cxc{2}{r}]; 
    end
    addind(r) = 0;
  end
end

% add the rest (ie new items) to the end
nadd = sum(addind);
					% full in case matrix is sparse
cs.preds{2}(:,:,end+1:end+nadd) = reshape(transpose(full(news.preds{2}(addind,:))),n,n, nadd) ;
cs.dependents{2}(end+1:end+nadd) = news.dependents{2}(addind);
cs.cx{2}(end+1:end+nadd) = news.cx{2}(addind);
cs.cxc{2}(end+1:end+nadd) = news.cxc{2}(addind);
cs.exm{2}(end+1:end+nadd,:) = news.exm{2}(addind,:);

