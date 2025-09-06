function makerwcomponents(treeind, trees, ps)

rwpartfile=[ps.outdir, ps.rwpartpref, num2str(treeind)];
load(rwpartfile, 'rwfreqs', 'rwp');

n = size(rwp,2);
nrw = size(rwp,1);
rwcompm = logical(zeros(0,n));
rwcompfreqs = zeros(0,1);
erow = zeros(1,n);
nrow = 1;
for i = 1:nrw
  for k = 1:max(rwp(i,:))
    gind = find(rwp(i,:)==k);
    row = erow; row(gind) = 1;
    rind = findrow(rwcompm,row);
    if isempty(rind)
      rwcompm(nrow,:) = row;
      rwcompfreqs(nrow)= rwfreqs(i);
      nrow = nrow+1;
    else
      rwcompfreqs(rind) = rwcompfreqs(rind)+rwfreqs(i);
    end
  end
end

% add the single component that includes every relative -- ie corresponds to a
% term for everybody in your family tree

rwcompm(end+1,:) = ones(1,n);
rwcompfreqs(end+1) = 0;

[rwcompfreqs,sind] = sort(rwcompfreqs, 'descend');
rwcompm = rwcompm(sind,:);

exm_enum = rwcompm;

outfile=[ps.outdir, ps.rwcomppref, num2str(treeind)];
save(outfile, 'exm_enum', 'rwcompfreqs');

