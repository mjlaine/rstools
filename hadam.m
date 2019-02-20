  function x=hadam(n)
% keywords: Hadamard matrix, experimental design
% call: x=hadam(n)
% The function generates a Hadamard matrix (without the constant column)
% for a given n,  n = 8,12,16,20 or 24.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/09 15:16:12 $

g8=[1 1 1 -1 1 -1 -1];
g12=[1 1 -1 1 1 1 -1 -1 -1 1 -1];
g16=[1 1 1 1 -1 1 -1 1 1 -1 -1 1 -1 -1 -1];
g20=[1 1 -1 -1 1 1 1 1 -1 1 -1 1 -1 -1 -1 -1 1 1 -1];
g24=[1 1 1 1 1 -1 1 -1 1 1 -1 -1 1 1 -1 -1 1 -1 1 -1 -1 -1 -1];

if n == 8
   gen = g8;
elseif n == 12
   gen = g12;
elseif n == 16
   gen = g16;
elseif n == 20
   gen = g20;
elseif n == 24
   gen = g24;
else
   error('n must be 8,12,16,20 or 24')
end
gen=gen(:);

m = length(gen);
x = zeros(m+1,m);

x(1:m,1)=gen;

for i = 1:m-1
    j=[1+i:m 1:i]';
    x(j,1+i)=gen;
end

x(m+1,1:m)=-ones(1,m);
