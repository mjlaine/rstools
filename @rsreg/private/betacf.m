  function y = betacf(a,b,x);
% keywords: special functions
% call: y = betacf(a,b,x);
% Continued fraction for incomplete beta function from NUMERICAL RECIPES.
% Used by BETAI.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

 x  = x(:)';
 n  = length(x);

 itmax = 100; epsil = 3e-7;
 am    = ones(1,n); bm = ones(1,n); az = ones(1,n); aold = zeros(1,n);
 qab   = a+b; qap = a+1; qam = a-1; m = 0;
 az    = ones(1,n);
 bz    = 1 - qab*x/qap;

 while length(find(abs(az-aold) > epsil*abs(az))) > 0  & m < itmax
     m     = m + 1;
     em    = m; tem = 2*m;
     d     = em*(b-m)*x/((qam+tem)*(a+tem));
     ap    = az + d .* am;
     bp    = bz + d .* bm;
     d     = -(a+em)*(qab+em)*x / ((a+tem)*(qap+tem));
     app   = ap + d .* az;
     bpp   = bp + d .* bz;
     aold  = az;
     am    = ap ./ bpp;
     bm    = bp ./ bpp;
     az    = app./ bpp;
     bz    = ones(1,n);
 end
 if m == 100, error('a or b too big, or itmax too small'); end

 y = az;


