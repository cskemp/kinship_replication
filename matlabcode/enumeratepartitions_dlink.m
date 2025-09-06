function enumeratepartitions_dlink(compfile, x, ys, e, r, trees, matflag, ps)

load(compfile, 'exm_enum');

infile = [ps.outdir, ps.linkinpref, num2str(x), '_',  num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '.txt'];

outfile = [ps.outdir, ps.linkoutpref, num2str(x), '_',  num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r), '.txt'];

mat2dance(exm_enum, infile);
[s,w] = system(['dancinglinks 1 < ', infile, ' > ', outfile]);
disp(w)
disp('.. dancing links finished');

if matflag % save results in matlab format
  finalfile = [ps.outdir, ps.enumpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_rpt', num2str(r)];
  linkout2mat(outfile, finalfile, exm_enum);
end

