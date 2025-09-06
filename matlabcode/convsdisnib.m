ps = setps();
x = 12;
ys = [1,1,1];

compfiled = [ps.outdir, ps.compxpref, num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(1)];

compfilec = [ps.outdir, ps.compxpref,  num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(2)];

compfilerw = [ps.outdir, ps.compxpref,  num2str(x), '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(7)];

disj = load(compfiled);
conj = load(compfilec);
rw   = load(compfilerw);

enums{1} = disj.exm_enum;
enums{2} = conj.exm_enum;
enums{3} = rw.exm_enum;

chunkinds{1} = {1:4, 21:24, [15,17,16,18], [5:7,10:11], [12:14,8:9], []};
chunkinds{2} = {25:28, 53:56, [39,41,40,42], [29:31,34:35], [36:38,32:33], [43:52]};

chunkfiles = {'gpchunk', 'gcchunk', 'sibchunk', 'auntchunk', 'unclechunk', 'nibchunk'};

for ci = 1:length(chunkinds{1})
  ini = [chunkinds{1}{ci}, chunkinds{2}{ci}];    
  if ci == 6
		  % allow for son, daughter of Alice
    outbase = setdiff(1:56, 19:20);
  else
    outbase = 1:56;
  end
  outi = setdiff(outbase, ini);
  ininds{ci} = ini;
  outinds{ci} = outi;
  for j = 1:3
    chunkcinds{ci}{j} = find(sum(enums{j}(:, ini),2) > 0 & sum(enums{j}(:,outi),2)==0);
  end
end

save('condis_specsnib', 'enums', 'chunkcinds');

