function comp_compare(enumcomp, focals, rwcomp, rwcompfreqs)

% show most common components in RWCOMP that don't appear in ENUMCOMP

n = size(enumcomp,2);
nhalf = div(n,2);

rincl = find(sum(enumcomp(:, (nhalf-1):end),2)==0);
enumcomp= enumcomp(rincl,:);
[dd,i] = setdiff(rwcomp, enumcomp(:, focals), 'rows');
[s,sind]= sort(rwcompfreqs(i), 'descend');
dl = min([10, length(s)]);
disp(sprintf('%d total missing', length(s)));
disp(s(1:dl));
disp('-------')
dd = dd(sind,:);
for i = 1:dl
  disp(find(dd(i,:)));
end
disp('********************************')

