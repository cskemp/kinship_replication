function rpairs2text(rpairs, outfile)

fid = fopen(outfile, 'w');

dinds = find(rpairs);

for i = 1:length(dinds)
  fprintf(fid, '%d %d\n', dinds(i), rpairs(dinds(i)));
end

fclose(fid);

