function needprob2text(needprob, outfile)

fid = fopen(outfile, 'w');
fprintf(fid, '%f ', needprob);
fclose(fid);

