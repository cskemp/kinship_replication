function dependency2text(dependency, outfile)

fid = fopen(outfile, 'w');

for i = 1:length(dependency)
  for j = 1:length(dependency{i})
    fprintf(fid, '%d %d ', i, j-1);
    fprintf(fid, '%d ', dependency{i}{j});
    fprintf(fid, '\n');
  end
end

fclose(fid);

