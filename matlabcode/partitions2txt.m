function partitions2txt(p, outfile, varargin)

args = varargin;
order = [];
for i=1:2:length(args)
  switch args{i}
   case 'order', order = args{i+1};
  end
end

fid = fopen(outfile, 'w');

npart = size(p,1);

spflag = 0;
if issparse(p)
  p = p';
  spflag = 1;
end

for i = 1:npart
  if spflag
    compinds = find(p(:,i));
  else
    compinds = find(p(i,:));
  end
  if ~isempty(order)
    [s,sind] = sort(order(compinds));
    compinds = compinds(sind);
  end
  fprintf(fid, '%d ', compinds);
  fprintf(fid, '\n');
end
fprintf(fid, 'Altogether %d solutions, after 103 updates\n', npart);

fclose(fid);
