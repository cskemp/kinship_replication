function systemcs = makeperm(systemcs, nshuffle, seed, pairindmat, swapcands, ncomp) 

halfpairmat = pairindmat.* triu(ones(size(pairindmat,1)),1);

nrw= size(systemcs, 1);

rand('state', seed);

for i = 1:nshuffle
  if rem(i, 1000) == 0
    disp(i)
  end
  swaprinds= [];
  while isempty(swaprinds)
    swapr1= unidrnd(nrw);
    rmembers = find(systemcs(swapr1,:));
    swapc1= rmembers(unidrnd(length(rmembers)));
    swap2cands = find(swapcands(swapc1,:));
    if isempty(swap2cands) 
      continue 
    end
    swapc2 = swap2cands(unidrnd(length(swap2cands)));
    paircands = find(systemcs(:, swapc2));
    if isempty(paircands) 
      continue 
    end
    swapr2= paircands(unidrnd(length(paircands)));
    swaprinds= [swapr1, swapr2];
  end
  [swapc1a, swapc1b] = find(halfpairmat==swapc1); 
  if ~isempty(swapc1a)
    swapc1 = [swapc1a, swapc1b];
  end

  [swapc2a, swapc2b] = find(halfpairmat==swapc2); 
  if ~isempty(swapc2a)
    swapc2 = [swapc2a, swapc2b];
  end

  cs1 = find(systemcs(swapr1, 1:ncomp));
  cs1 = setdiff(cs1, swapc1);
  cs1 = [cs1, swapc2];
  cs2 = find(systemcs(swapr2, 1:ncomp));
  cs2 = setdiff(cs2, swapc2);
  cs2 = [cs2, swapc1];
  systemcs([swapr1,swapr2],:) = 0;
  systemcs(swapr1, systemvec(cs1, pairindmat)) = 1;
  systemcs(swapr2, systemvec(cs2, pairindmat)) = 1;
end

