function cost2text(cost, outfile)

fid = fopen(outfile, 'w');
fprintf(fid, '%f\n', cost);
fclose(fid);

