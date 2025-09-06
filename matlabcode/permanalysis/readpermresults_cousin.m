nvec = 6;
load('systemperms_cousin');


% edit this path appropriately
scores = load(['~/modelruns/kinshipreleasetest/combinedscoreswithdup_13_6_1_20_14_', num2str(nvec), '_rpt1_rand0']);
load('comppermmap_cousin')

[sysi, permi]= find(rwpermindex==1);

nsys = size(rwpermindex,1);
nperm = size(rwpermindex,2);

stablepermind = 109;
cases = double(rwpermindex);
cases(find(rwpermindex==1)) = 1:length(find(rwpermindex==1));
basescores = scores(cases(:, stablepermind),:);

ntotperm = size(rwpermindex,2);
ntotsys = size(rwpermindex,1);

% analysis by permutation
for j = setdiff(1:nperm, stablepermind)
  caseinds = find(permi==j);
  thissys = sysi(caseinds);
  thisbase = basescores(thissys,:);
  thisnew = scores(caseinds,:);
  permsummary(:,j) = transpose(profile(thisnew, thisbase));
  % allow for cases that couldn't be coded
  permsummary(2,j) = permsummary(2,j) + sum(rwpermindex(:, j)==0);

  permsummaryfreq(:,j) = 0*permsummary(:,j);
  for k = 1:length(caseinds)
    rind = thissys(k);
    permsummaryfreq(:,j) = permsummaryfreq(:,j) + rw.rwfreqs(rind)*transpose(profile(thisnew(k,:), thisbase(k,:)));
  end

  % allow for cases that couldn't be coded
  leftoutsys = setdiff(1:ntotsys, thissys);
  permsummaryfreq(2,j) = permsummaryfreq(2,j) + sum(rw.rwfreqs(find(rwpermindex(:, j)==0)));
end

% analysis by rw system
for j = 1:nsys
  caseinds = find(sysi==j);
  thisperm= setdiff(permi(caseinds), stablepermind);
  thisbase = repmat(basescores(j,:), length(caseinds),1);
  thisnew = scores(caseinds,:);
  syssummary(j,:) = profile(thisnew, thisbase);
  % allow for cases that couldn't be coded
  syssummary(j,2) = syssummary(j,2) + sum(rwpermindex(j,:)==0);
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

diffmat(rwpermindex==0) = 1;
diffmat(isnan(rwpermindex)) = nan;

syssummaryfreq = syssummary.*repmat(rw.rwfreqs,1,4);

diffinds = find(syssummary(:,1) > syssummary(:,2));
diff = syssummary(:,1)./syssummary(:,2);

permdiffind = find(permsummaryfreq(1,:) > permsummaryfreq(2,:));

freqs = rw.rwfreqs;
save(['permresultscousin14_', num2str(nvec)], 'permsummaryfreq', 'syssummaryfreq', 'permsummary', 'syssummary', 'diffmat', 'freqs');

