function [r,k] = findrow(a,b)
% 
% FINDROW  Find indices of a given row within a matrix.
% 
%   R = FINDROW(A, B)  returns indices of the rows in A that coincide with
%   row vector B , otherwise empty. 
%   [R, I] = FINDROW(A, B)  also returns the indices of elements of rows R.
%
% Note that the use of INTERSECT for the same purpose is limited because
% the results are sorted and repeated entries are not taken care of.

% Mukhtar Ullah
% mukhtar.ullah@informatic.uni-rostock.de
% November 29, 2004

r = find(ismember(a, b, 'rows'));

if nargout > 1
    a(:) = 1:numel(a);
    k = a(r,:);
end
