load('systemperms_nib');
load('rwperms_nib');

rwcomps = find(sum(rw.partitions,1));
ncomp = size(rwcomps,2);
totperm = size(allperms,1);

compmap = zeros(ncomp, totperm);
emptysys = zeros(1,56);

compsizes = sum(rw.componentsm,2);
for sz = 1:56
  compsz{sz} = find(compsizes==sz);
end


for i = 1:ncomp
  disp(i)
  rwcomp = rwcomps(i);
  compmembers = find(rw.componentsm(rwcomp,:));
  thissys = emptysys;
  thissys(compmembers) = 1;
  thissz = length(compmembers);
  for j = 1:totperm
    newsys = thissys;
    newsys = newsys(allperms(j,:));
    newmembers = find(newsys);
    outmembers = find(newsys==0);
    newcompind = find(sum(rw.componentsm(compsz{thissz}, newmembers),2) == thissz); 
    if isempty(newcompind)
      newcompind = -1;
    else
      newcompind = compsz{thissz}(newcompind);
    end
    compmap(i,j) = newcompind;
  end
end
save('comppermmap_nib', 'compmap');

