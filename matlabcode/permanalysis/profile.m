function prf = profile(ccnew, ccbase)

% new dominates base

prf(1)   = sum((ccnew(:,1)<=ccbase(:,1)&ccnew(:,2)< ccbase(:,2))|...
               (ccnew(:,1)< ccbase(:,1)&ccnew(:,2)<=ccbase(:,2)));

% base dominates new

prf(2)   = sum((ccbase(:,1)<=ccnew(:,1)&ccbase(:,2)< ccnew(:,2))|...
               (ccbase(:,1)< ccnew(:,1)&ccbase(:,2)<=ccnew(:,2)));

% equal
prf(3)   = sum(ccbase(:,1)==ccnew(:,1)&ccbase(:,2)==ccnew(:,2));


% indeterminate
prf(4)   = sum((ccbase(:,1)<ccnew(:,1)&ccbase(:,2)> ccnew(:,2))|...
               (ccbase(:,1)>ccnew(:,1)&ccbase(:,2)<ccnew(:,2)));

