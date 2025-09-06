function news = strip_duplicates(news, range, ps)

% strip duplicate relations using only information in news

if ps.filtercompbyexm 
  [uu,ii,jj] = unique(news.exm{2}(range,:), 'rows', 'first');
else 
    [uu,ii,jj] = unique(news.preds{2}(range,:), 'rows', 'first');
end
iiorig = ii;
icnt = 1;
for i = 1:length(iiorig)
  repeatind = find(jj==i);
 [m,mind] = min(news.cxc{2}(range(repeatind)));
  if ps.multidefn == 0
    ii(i) = repeatind(mind);
  else
    minds = find(news.cxc{2}(range(repeatind))<=m+ps.nearmisstol);
    ii(icnt:icnt+length(minds)-1) = repeatind(minds);
    icnt = icnt+length(minds);
  end
end
rii = range(ii);
nii = length(rii);
newrange = range(1):(range(1)+nii-1);
news.preds{2}(newrange,:) = news.preds{2}(rii,:);
news.dependents{2}(newrange) = news.dependents{2}(rii);
news.cx{2}(newrange) = news.cx{2}(rii);
news.cxc{2}(newrange) = news.cxc{2}(rii);
news.exm{2}(newrange,:) = news.exm{2}(rii,:);
news.nind(2) = range(1)+nii; 
news.repeatcount = 0;
