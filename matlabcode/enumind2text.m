function enumind2text(enumind, outfile)

fid = fopen(outfile, 'w');

for i = 1:length(enumind)
  fprintf(fid, '%d\n', enumind{i});
end

fclose(fid);
