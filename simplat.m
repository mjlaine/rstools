  function x = simplat(q,m)
% keywords: mixture design, experimental design
% call: x = simplat(q,m)
%
% This function forms a design a matrix that correponds to a (q,m)-simplex
% lattice, commonly used in mixture analysis
%
% INPUT:      q       number of variables
%             m       division of the interval [0,1] (i.e. each variable
%                     has m+1 levels 1/m apart
%
% OUTPUT:     x       the design matrix

x = mton(m+1,q);

i = find(sum(x')' == m);

x = x(i,:)/m;
