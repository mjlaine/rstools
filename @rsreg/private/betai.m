  function y = betai(x,a,b);
% keywords: special functions
% call: y = betai(x,a,b);
% The function computes the incomplete beta function I_x(a,b) at the
% points x (cf NUMERICAL RECIPES, p. 167)
%
% INPUT     x      the argument vector,   0 <= x <= 1
%           a,b    the constants,         a,b > 0
%
% OUTPUT
%           y      I_x(a,b)

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

 [xx,ind]    = sort(x);
 n           = length(xx);
 xmin   = min(xx); imin = 1;
 xmax   = max(xx); imax = n;
 betai1 = [];
 betai2 = [];
 g = exp(gammaln(a+b)-gammaln(a)-gammaln(b));

 if xmin < 0 | xmax > 1, error('bad argument x in BETAI'); end

 if xmin == 0
    bt(imin) = 0;
 else
    bt(imin) = g * xx(imin)^a * (1 - xx(imin))^b;
 end
 if xmax == 1
    bt(imax) = 0;
 else
    bt(imax) = g * xx(imax)^a * (1 - xx(imax))^b;
 end
 n1     = 2:n-1;
 bt(n1) = g * (xx(n1).^a) .* ((1 - xx(n1)).^b);

 spoint = (a+1)/(a+b+1);
 i1     = find(xx < spoint);    i2 = find(xx >= spoint);
 
 if length(i1) > 0
     x1     = xx(i1); betai1 = betacf(a,b,x1);
     betai1 = bt(i1) .* betai1/a;
 end
 if length(i2) > 0
     x2     = xx(i2); betai2 = betacf(b,a, 1-x2);
     betai2 = 1 - bt(i2) .* betai2/b;
 end

 y      = [betai1 betai2];
 y(ind) = y;
 y      = y(:);

