function s = canonicallabel(s)

% compute canonical label for partition vector

nanind = find(isnan(s));
nonanind = find(not(isnan(s)));
if ~isempty(nanind)
  out = s;
  snonan = s(nonanind);
  out(nonanind) = canonicallabel(snonan);
  out(nanind)= nan;
  s = out;
else
  [uu ii jj] = unique(s, 'first');
  [junk,sind] = sort(ii);
  [junk,sind] = sort(sind);
  uu = 1:length(ii);
  a = uu(sind);
  s = a(jj);
end

