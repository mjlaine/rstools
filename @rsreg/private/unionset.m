  function c = unionset(a,b);
% keywords: set operations
% call: c = unionset(a,b);
% The function gives the union set of the values of
% the sets (vectors or matrixes) 'a' and 'b'.
%
% INPUT:           a,b     original sets
%
% OUTPUT:          c       the union set, in increasing order

a = a(:);
b = b(:);
a = [a;b];

n = length(a);

a = sort(a);
b = a;

b = [b(2:n);max(b)+1];

k = find(abs(a-b) > 0);

c = a(k);
