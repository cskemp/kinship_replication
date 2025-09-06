function cs = systemvec(cs, pairindmat)

%global pairindmat

if length(cs) > 1
  thisspairs = nchoosek(cs,2);
  cs = [cs, pairindmat(sub2ind(size(pairindmat), thisspairs(:,1), thisspairs(:,2)))'];
end


