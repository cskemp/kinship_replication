% Make a file including just the partitions that match an attested system in size or complexity

x = 12;
ys = [1,1,16];
e = 5;
r = 1;
nvecind = 6;

ps = setps;

combscorefile=  [ps.outdir, 'combinedscoreswithdup_' num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

rwfile = [ps.outdir, 'rwpartitions_tree', num2str(x)];

enumrwscorefile= [ps.outdir, 'combinedscoreswithdup_', num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(2), '_', num2str(nvecind), '_rpt', num2str(r), '_rand0'];

ec = load(enumrwscorefile);

rwcomplex  = unique(ec(:,1));
rwcost     = unique(ec(:,2));
rwsize     = unique(ec(:,3));

complexequiv= {};
costequiv= {};
sizeequiv= {};

fid = fopen(combscorefile, 'r');

% make a filtered version of COMBSCOREFILE which includes only systems that match a rw system in complexity or cost.

wid = fopen([combscorefile, '_FILTER'], 'w');

cont = 1;
chunksize = 100000000;
cnt = 0;
while(cont)
  cols= textscan(fid, '%f%f%d', chunksize, 'delimiter',  ' ');
  if isempty(cols{1}) || length(cols{1}) < chunksize;
    cont = 0;
  end
  nc = length(cols{1});
  disp(nc);
  disp(cnt);
  bv = false(nc,1);
  for i = 1:length(rwsize)
    bv = bv | cols{2} ==rwcost(i);
    bv = bv | cols{1} ==rwcomplex(i);
  end

  m = zeros(3, sum(bv));
  m(1,:) = cols{1}(bv);
  m(2,:) = cols{2}(bv);
  m(3,:) = cols{3}(bv);
  fprintf(wid, '%.5f %.4f %d\n', m); 
end

fclose(wid);
fclose(fid);

