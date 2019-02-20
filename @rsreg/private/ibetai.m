function x = ibetai(p,a,b)
% keywords: inverse, special functions
% call: x = ibetai(p,a,b)
% the function computes the inverse value of the incomplete beta
% function, i.e the value x for which betai(x) = p.
%
% INPUT:
%            p      the probabilty (0 <= p <= 1)
%            a,b    the constants  a,b > 0
% OUTPUT:
%            x      the inverse value for p

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.3 $  $Date: 2003/04/15 08:37:55 $

if (any(p<0) | any(p> 1))
     error('the value of p must be between 0 and 1');
end

if (a <= 0 | b <=0)
     error(' the value for both constants must be > 0');
end

p     = p(:);
x     = zerog(p);

k1    = find(p==1);
x(k1) = oneg(k1);

k     = find(p>0 & p<1);

% find the value of the inverse at p by applying the Newton's method
% on the function f(x) = betai(x,a,b)-p.

if length(k) > 0
     ak   = a*oneg(k); bk = b*oneg(k);
     x0   = ak./(ak+bk); x0 = x0(:);
     step = ones(length(k),1);
     tol  = 1e-8;
     while (any(abs(step) > tol*abs(x0)) & max(abs(step)) > tol)
          step1 = betai(x0,a,b)-p(k);
          step2 = (x0.^(a-1).*(1-x0).^(b-1))./beta(a,b);
          step  = step1./step2;
          xnew  = x0 -step;
          % check wheter we're within bounds
          ksm   = find(xnew <0); kla = find(xnew > 1);
          if length(ksm) > 0
               xnew(ksm) = x0(ksm)/10;
          end
          if length(kla)> 0
               xnew(kla) = 1-(1-x0(kla))/10;
          end
          x0 = xnew;
     end
     x(k) = x0;
end

