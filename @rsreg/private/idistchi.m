function x  = idistchi(prob,n);
% keywords: chi-squared distribution, inverse
% call: x  = idistchi(prob,n);
% The function computes the inverse Chi-squared distribution function
% values for 'prob'.
%
% INPUT
%              prob   the probability (a scalar!)
%              n      the n. of degrees of freedom
% OUTPUT
%              x      the argument for which
%                         P(-inf,x) = p,

% Copyright (c) 1994,2003 by ProfMath Ltd
% $Revision: 1.3 $  $Date: 2006/05/02 07:04:58 $

% Initialization  by inverse Normal distribution

  x  = idistn(prob);
  x  = n*(1 - 0.2222222/n + x*sqrt(0.222222/n))^3;

% OK for n big enough

  if n > 40 return; end

% Otherwise the value of 'x' by iteration (modified 'fzero')

  n2  = n/2;
  tol = 1e-5;
  dx =  x/20;
  if x < 0,
     dx = -dx; x = -x + dx;
  else
     if x ==0 dx = .05 ;x = 3*dx; end
  end
  
  a = x - dx;  fa = prob - gammainc(a/2,n2);
  b = x + dx;  fb = prob - gammainc(b/2,n2);

% Find change of sign.

while (fa > 0) == (fb > 0)
  dx = 1.4*dx;
  a = x - dx;  
  while (a<0)
    dx=dx/1.5; a = x-dx;
  end
  fa = prob - gammainc(a/2,n2);
  if (fa > 0) ~= (fb > 0), break, end
  b = x + dx;  fb = prob - gammainc(b/2,n2);
end

fc = fb;
% Main loop, exit from middle of the loop
while fb ~= 0
  % Insure that b is the best result so far, a is the previous
  % value of b, and c is on the opposite of the zero from b.
  if (fb > 0) == (fc > 0)
    c = a;  fc = fa;
    d = b - a;  e = d;
  end
  if abs(fc) < abs(fb)
      a = b;    b = c;    c = a;
      fa = fb;  fb = fc;  fc = fa;
  end

  % Convergence test and possible exit
  m = 0.5*(c - b);
  toler = 2.0*tol*max(abs(b),1.0);
  if (abs(m) <= toler) + (fb == 0.0), break, end

  % Choose bisection or interpolation
  if (abs(e) < toler) + (abs(fa) <= abs(fb))
    % Bisection
    d = m;  e = m;
  else
    % Interpolation
    s = fb/fa;
    if (a == c)
      % Linear interpolation
      p = 2.0*m*s;
      q = 1.0 - s;
    else
      % Inverse quadratic interpolation
      q = fa/fc;
      r = fb/fc;
      p = s*(2.0*m*q*(q - r) - (b - a)*(r - 1.0));
      q = (q - 1.0)*(r - 1.0)*(s - 1.0);
    end;
    if p > 0, q = -q; else p = -p; end;
    % Is interpolated point acceptable
    if (2.0*p < 3.0*m*q - abs(toler*q)) * (p < abs(0.5*e*q))
      e = d;  d = p/q;
    else
      d = m;  e = m;
    end;
  end % Interpolation
  
  % Next point
  a = b;
  fa = fb;
  if abs(d) > toler
    b = b + d;
  elseif b > c
    b = b - toler;
  else 
    b = b + toler;
  end
  fb = prob -  gammainc(b/2,n2);
end % Main loop

x = b;

