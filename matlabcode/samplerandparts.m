function samplerandparts(outfile, sampi, nsamplepersplit, partition, ncomp, npeople, exm_enum);

fid = fopen(outfile, 'w');
rand('state', sampi);

for i = 1:nsamplepersplit
  partition = 0*partition;
  compi = 1;
  indi = 1;
  candidates = ones(1,ncomp);
  while indi <= npeople
    if sum(candidates) == 0
      break;
    else
      ncand = sum(candidates);
      cinds = find(candidates);
      c = unidrnd(ncand);
      c = cinds(c);
      complist(compi) = c;
      compi = compi+1;
      newinds = find(exm_enum(c,:));
      nnew = length(newinds);
      indlist(indi:indi+nnew-1) = newinds;
      indi = indi+nnew;
      candidates(sum(exm_enum(:, newinds),2)>0)=0;
    end
  end
  if indi <= npeople
    %ndiscard = ndiscard + 1;
  else
    %nsuccess = nsuccess + 1;
    comps = complist(1:compi-1);
    fprintf(fid, '%d ', comps);
    fprintf(fid, '\n');
  end
end
fclose(fid);

