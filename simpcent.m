  function x = simpcent(q)
% keywords: mixture design, experimental design
% call: x = simpcent(q)
%
% This function forms a design a matrix that correponds to a q-simplex
% centroid, commonly used in mixture analysis
%
% INPUT:      q       number of variables
%
% OUTPUT:     x       the design matrix


levels = ones(1,q)./(1:q);
levels = [levels 0];

x = mton(q+1,q,levels);

i = find(sum(x')' == 1); x = x(i,:);

maxx = max(x')';

z    = x(:);
i    = find(z == 0); 
z(i) = Inf*ones(size(i));
y    = zeros(size(x));
y(:) = z;

i = find(maxx == min(y')'); x = x(i,:);
