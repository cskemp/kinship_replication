function partitions2txt(p, outfile)

fid = fopen(outfile, 'w');

npart = size(p,1)
for i = 1:npart
  compinds = find(p(i,:));
  fprintf(fid, '%d ', compinds);
  fprintf(fid, '\n');
end


