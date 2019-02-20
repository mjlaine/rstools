  function p = distt(t,n,ido);
% keywords: t-distribution
% call: p = distt(t,n,ido);
% The function computes Student's  t - distribution probability
% values for 't'.
%
% INPUT
%              t      the argument vector
%              n      the n. of degrees of freedom
%              ido    the case
%                        ido = 1:    probability for 'x <= t'
%                        ido = 2:    probability for '|x| <= t'
%                     OPTIONAL, default ido = 1
% OUTPUT
%              p      the probability
%                     NOTE: if ido = 2, 't' has to be positive

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.3 $  $Date: 2003/04/15 07:44:16 $

  t  = t(:);
  abst = abs(t); post = find(t >= 0); negt = find(t < 0);
  npos = [1:length(post)]'; nneg = [1:length(negt)]';


  a  = n/2;
  b  = 1/2;

  if isempty(npos)
     xpos=[];
  else
     xpos  = n*oneg(npos)./(n + t(post).^2);
  end
  if isempty(nneg)
     xneg = [];
  else
     xneg  = n*oneg(nneg)./(n + t(negt).^2);
  end

  if nargin ==2 ido = 1; end

  if nargin > 2 & ido == 2 & length(negt) > 0
        error('with ido=2 t must be positive');
  else
     if length(xpos) > 0 ppos  = 1 - betai(xpos,a,b); end
     if ido == 2
         p = ppos;
     else
         if length(xpos) > 0, p(post) = (ppos + 1)/2; end
         if length(negt) > 0
           pneg     = 1 - betai(xneg,a,b);
           p(negt) = (1 - pneg)/2;
         end
     end
  end
  p = p(:);

