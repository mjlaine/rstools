  function x = idistn(p,ido);
% keywords: normal distribution, inverse
% call: x = idistn(p,ido);
% The function computes the inverse standard Normal distribution function
% values for 'p'.
%
% INPUT
%              p      the probability
%              ido    the case
%                        ido = 1:    'p' cumulative probability
%                        ido = 2:    'p' symmetric  probability
%                     OPTIONAL, default ido = 1
% OUTPUT
%              x      the argument for which
%                         P(-inf,x) = p,    with ido = 1
%                         P(|x|)    = p,    with ido = 2

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

smallp = find(p < 0.5); bigp = find(p>=0.5);

 if (any(p > 1) | any(p < 0) )
    error('p must be between 0 and 1!')
 end
 if nargin ==1, ido = 1; end

 if ido == 1
    if length(smallp)>0
       x(smallp) = - erfinv(1-2*p(smallp))* sqrt(2);
    end
    if length(bigp)>0
       x(bigp)   = erfinv(2*p(bigp)-1)*sqrt(2);
    end
 else
 if ido == 2
    if length(smallp)>0
       x(smallp) = -erfinv(p)*sqrt(2);
    end
    if length(bigp)>0
       x(bigp) = erfinv(p)*sqrt(2);
    end
 end
 end
