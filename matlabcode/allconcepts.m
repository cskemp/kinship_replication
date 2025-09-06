function concepts=allconcepts(n, varargin)

args = varargin;
base = 2;
for i=1:2:length(args)
  switch args{i}
   case 'base', base=args{i+1};
  end
end

% generate the power set of a collection of n objects 


for i=1:base^n
    bin=double(dec2base(i-1, base))-48;
    l=length(bin);
    bin=[zeros(1,n-l),bin];
    concepts(i,:)=bin;
end

