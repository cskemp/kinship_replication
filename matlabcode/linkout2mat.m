function linkout2mat(linkoutfile, finalfile, componentsm)

% convert dancinglinks output file to matlab file


npeople = size(componentsm,2);
ncomp = size(componentsm,1);
fid= fopen(linkoutfile, 'r');
n = getnpartitions(fid);

partitions = logical(zeros(n, ncomp));
for i = 1:n
  partitions(i,:) = getpartition(fid, partitions(i,:));
end
fclose(fid);

compactp= part2compactp(partitions, componentsm);
for i = 1:size(componentsm,1)
  components{i} = find(componentsm(i,:));
end

componentsm = logical([componentsm, 0*componentsm]);
save(finalfile, 'components', 'componentsm', 'partitions', 'compactp')
