  function p = distn(x,ido);
% keywords: normal distribution
% call: p = distn(x,ido);
% The function computes the N(0,1) Normal distribution probability
% values for 'x'.
%
% INPUT
%              x      the argument
%              ido    the case
%                        ido = 1:    probability for 'xx <= x'
%                        ido = 2:    probability for '|xx| <= x'
%                     OPTIONAL, default ido = 1
% OUTPUT
%              p      the probability
%                     NOTE: if ido = 2, x has to be positive

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

 absx = abs(x); posx = find(x >= 0); negx = find(x < 0);

 if nargin == 1 ido = 1; end

 if nargin > 1 & ido == 2 & length(negx) > 0
    error('x must be positive')
 else
    pabs = erf(absx/sqrt(2));
    if ido == 2
       p = pabs;
    else
       p(posx) = (pabs(posx) + 1)/2;
       p(negx) = (1 - pabs(negx))/2;
    end
 end

