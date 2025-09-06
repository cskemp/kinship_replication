function enumeratesystems(x, ys, e, r, trees, ps)

if ys(3) == 0 % pull components from rwfile 
  compfile = [ps.outdir, ps.rwcomppref, num2str(x)];
else	      % pull components from compx file
  compfile = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3))]; 
end

switch e
  case 2 % create partition file that includes real-world partitions
	 % with complexities based on the ys component file
    makerwpartitionscomp(compfile, x, ys, e, r, ps);
  case 3 % sample
    samplepartitions2textPAR(compfile, x, ys, e, r, trees, ps);
  case 4 % dlinks -> mat
    enumeratepartitions_dlink(compfile, x, ys, e, r, trees, 1, ps);
  case 5 % dlinks -> txt
    enumeratepartitions_dlink(compfile, x, ys, e, r, trees, 0, ps);
  case 11 % create permutation file
    makepartitions_perm(compfile, x, ys, e, r, ps);
  case 14 % create permutation file for cousins
    makepartitions_permcousins(compfile, x, ys, e, r, ps);
end

