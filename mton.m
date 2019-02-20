function x=mton(m,n,levels)
% keywords: experimental design, combinatorics
% call: x=mton(m,n,levels)
% The function computes a full m^n factorial design
% INPUT:     m       number of levels
%            n       the number of factors in the design
%            levels  the levels whose all possible cobinations are given
%                    'levels' is OPTIONAL (default = 0:m-1)
% OUTPUT:    x       the design matrix.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

i=0:m^n-1;i=i';

for j=1:n
    x(:,n-j+1)=rem(floor(i./m^(j-1)),m);
%    x(:,j)=rem(floor(i./2^(j-1)),2);
end

if nargin == 3
    ind  = x(:); ind = ind + 1;
    x(:) = levels(ind);
elseif nargin < 2
    error('too few inputs');
end

