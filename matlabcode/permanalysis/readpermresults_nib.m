
nvec = 6;

% edit path appropriately
scores = load(['~/modelruns/kinshipreleasetest/combinedscoreswithdup_12_1_1_1_11_', num2str(nvec), '_rpt1_rand0']);
load('systemperms_nib');
load('systemperms_nib');
load('rwperms_nib');
load('comppermmap_nib')

[sysi, permi]= find(rwpermindex);

nsys = size(rwpermindex,1);
nperm = size(rwpermindex,2);

stablepermind = 3457;

cases = double(rwpermindex);
cases(find(rwpermindex)) = 1:length(find(rwpermindex));
basescores = scores(cases(:, stablepermind),:);

% analysis by permutation
for j = 1:nperm
  caseinds = find(permi==j);
  thissys = sysi(caseinds);
  thisbase = basescores(thissys,:);
  thisnew = scores(caseinds,:);
  permsummary(:,j) = transpose(profile(thisnew, thisbase));
  permsummaryfreq(:,j) = 0*permsummary(:,j);
  for k = 1:length(caseinds)
    rind = thissys(k);
    permsummaryfreq(:,j) = permsummaryfreq(:,j) + rw.rwfreqs(rind)*transpose(profile(thisnew(k,:), thisbase(k,:)));
  end
end

% analysis by rw system
for j = 1:nsys
  caseinds = find(sysi==j);
  thisperm= permi(caseinds);
  thisbase = repmat(basescores(j,:), length(caseinds),1);
  thisnew = scores(caseinds,:);
  syssummary(j,:) = profile(thisnew, thisbase);
end


diffmat = zeros(size(rwpermindex));
for k = 1:length(sysi)
  sys = sysi(k);
  perm = permi(k);
  base = basescores(sys,:);
  prf = profile(scores(k,:), base);
  if prf(1) == 1
    diffmat(sys,perm) = -1;
  elseif prf(2) == 1
    diffmat(sys,perm) = 1;
  end
end

syssummaryfreq = syssummary.*repmat(rw.rwfreqs,1,4);

diffinds = find(syssummary(:,1) > syssummary(:,2));
diff = syssummary(:,1)./syssummary(:,2);

permdiffind = find(permsummaryfreq(1,:) > permsummaryfreq(2,:));

freqs = rw.rwfreqs;
save(['permresultsnib_', num2str(nvec)], 'permsummaryfreq', 'syssummaryfreq', 'permsummary', 'syssummary', 'diffmat', 'freqs');



