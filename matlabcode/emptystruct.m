function s = emptystruct(n, ps)

m = ps.memchunksize;

preds{1}= logical(zeros(m, n));
dependents{1}= cell(m,1);
cx{1}  = zeros(m,1); 
cxc{1} = zeros(m,1);
exm{1} = logical(zeros(m, 2*(n))); 

% if memory a real concern
if ps.compenumsparse
  preds{2} = sparse(logical(zeros(m, n^2)));
else
  preds{2} = logical(zeros(m, n^2));
end
dependents{2}= cell(m,1);
cx{2}  = zeros(m,1); 
cxc{2} = zeros(m,1);
exm{2} = logical(zeros(m, 2*(n))); 

s.preds = preds;
s.dependents = dependents;
s.cx = cx;
s.cxc = cxc;
s.exm= exm;
s.nind= [1,1];
s.repeatcount= 0;

