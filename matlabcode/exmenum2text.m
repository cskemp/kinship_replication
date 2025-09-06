function exmenum2text(exm_enum, outfile)

ncomp = size(exm_enum,1);
fid = fopen(outfile, 'w');
for i = 1:ncomp
  fprintf(fid, '%d ', find(exm_enum(i,:)));
  fprintf(fid, '\n');
end
fclose(fid);

