function complex2test(complex, outfile)

fid = fopen(outfile, 'w');

for i = 1:length(complex)
  for j = 1:length(complex{i})
    fprintf(fid, '%d %d ', i, j-1);
    fprintf(fid, '%d ', complex{i}(j));
    fprintf(fid, '\n');
  end
end

fclose(fid);

