function t = idistt(p,n,ido)
% keywords: t-distribution, inverse
% call: t = idistt(p,n,ido);
% The function computes the inverse of Student's  t - distribution
% i.e the value t for which P(x<=t) = p (if ido=2, P(|x|<=t) )
%
% INPUT
%              p      the probability
%              n      the n. of degrees of freedom
%              ido    the case
%                        ido = 1:    the value t for 'x <= t'
%                        ido = 2:    the value t for '|x| <= t'
%                     OPTIONAL, default ido = 1
% OUTPUT
%              t      the t-value corresponding to p
%                     NOTE: if ido = 2, the function returns the
%                     positive value of t.

if nargin < 3
     ido = 1;
end

p  = p(:);
z  = zerog(p);
tt = z;
a  = n/2; b = 1/2;

ks = find(p < 0.5); kl = find(p >= 0.5);
%keyboard
if ido == 1
     if length(kl) > 0
          z(kl)  = ibetai(2*(1-p(kl)),a,b);
          tt(kl) = sqrt(n./z(kl)-n);
     end
     if length(ks) > 0
          z(ks)  = ibetai(2*p(ks),a,b);
          tt(ks) = -sqrt(n./z(ks)-n);
     end
else
     z  = ibetai(1-p,a,b);
     tt = sqrt(n./z-n);
end
t = tt;
