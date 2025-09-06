function ss = makescorespecs()

% Parameters and data structures for scoring communicative cost

% ALLVS: vectors of need probabilities

% Weights based on corpus statistics 

gma = 21.4; gpa = 16.3; ant = 4.7; unc = 7.1;
dad = 438.1; mom = 432.1; sis = 39.1; bro = 50.5; 
son = 145.7; dau = 130.9; gda = 2.1; gso = 3.3;
nie = [1.0];
nep = [1.2];
cou = 0.93;

onetree = [gma, gpa, gma, gpa, ant, ant, mom, unc, unc, ant, ant, dad, unc, unc, sis, sis, bro, bro, dau, son, gda, gso, gda, gso];

onetreenib = [gma, gpa, gma, gpa, ant, ant, mom, unc, unc, ant, ant, dad, unc, unc, sis, sis, bro, bro, nie, nep, nie, nep, dau, son, nie, nep, nie, nep, gda, gso, gda, gso];

minimalcousin = [ant, mom, unc, ant, dad, unc, cou, cou, cou, cou, sis, bro, cou, cou, cou, cou];

niball  = [onetree, onetreenib];
ss.needp{6}{12} = niball/sum(niball);

couall = [minimalcousin, minimalcousin];
ss.needp{6}{13} = couall/sum(couall);


% Weights based on stable population assumption 

ant = 4*ant; unc = 4*unc; 
sis = 4*sis; bro = 4*bro; 
nep = 4*nep; nie = 4*nie; 
cou = 4*cou;
onetree = [gma, gpa, gma, gpa, ant, ant, mom, unc, unc, ant, ant, dad, unc, unc, sis, sis, bro, bro, dau, son, gda, gso, gda, gso];

onetreenib = [gma, gpa, gma, gpa, ant, ant, mom, unc, unc, ant, ant, dad, unc, unc, sis, sis, bro, bro, nie, nep, nie, nep, dau, son, nie, nep, nie, nep, gda, gso, gda, gso];

niball  = [onetree, onetreenib];
ss.needp{7}{12} = niball/sum(niball);

ts = maketreespecs();
sts = subtreespecs(ts);

for i = [6,7]
  for j = 14:19
      inds = sts{12}{j};
      ss.needp{i}{j} = ss.needp{i}{12}(inds);
      ss.needp{i}{j} = ss.needp{i}{j}/sum(ss.needp{i}{j});
  end
end

% making need vectors for balanced population

antvs = ant*allconcepts(4);
uncvs = unc*allconcepts(4);
sisvs = sis*allconcepts(2);
brovs= bro*allconcepts(2);
[a b] = meshgrid(1:4,1:4);
sibvs = [sisvs(a(:),:), brovs(b(:),:)];
nienepvs = sibvs(:, [1,1,2,2,3,3,4,4]);
nienepvs(find(nienepvs))=1;
nienepvs(:, [1,3,5,7]) = nie*nienepvs(:, [1,3,5,7]);
nienepvs(:, [2,4,6,8]) = nep*nienepvs(:, [2,4,6,8]);

% aunts, uncles, siblings have 0.25 probability of existing
antprobs = 0.25.^sum(antvs>0,2).*0.75.^(sum(antvs==0,2));
uncprobs = 0.25.^sum(uncvs>0,2).*0.75.^(sum(uncvs==0,2));
sibprobs = 0.25.^sum(sibvs>0,2).*0.75.^(sum(sibvs==0,2));

[a b c] = ndgrid(1:16,1:16,1:16);
allvs = [antvs(a(:),:), uncvs(b(:),:), sibvs(c(:),:), nienepvs(c(:),:)];
allprobs = antprobs(a(:)).*uncprobs(b(:)).*sibprobs(c(:));
allnvs = repmat([onetree,onetreenib], 16^3,1);
allnvs(:, [5,6,10,11,29,30,34,35]) = allvs(:,[1:4,1:4]);
allnvs(:, [8,9,13,14,32,33,37,38]) = allvs(:,[5:8,5:8]);
allnvs(:, [15:18,39:42]) = allvs(:,[9:12,9:12]);
allnvs(:, [43:46,49:52]) = allvs(:,[13:20]);

ss.needp{8}{12} = allnvs./repmat(sum(allnvs,2), 1, size(allnvs,2));
ss.vecprob{8}{12} = allprobs;
for j = 14:19
  inds = sts{12}{j};
  suballnvs = allnvs(:,inds);
  [uu ii jj] = unique(suballnvs, 'rows');
  vp = [];
  for jind = 1:length(ii)
    vp(jind) = sum(allprobs(jj==jind));
  end
  suballnvs = uu;
  ss.needp{8}{j} = suballnvs./repmat(sum(suballnvs,2), 1, size(suballnvs,2));
  ss.vecprob{8}{j} = vp';
end


