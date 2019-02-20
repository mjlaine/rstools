function F = idistf(p,n1,n2)
% keywords: F-distribution, inverse
% call: F = idistf(p,n1,n2)
% The function computes the inverse of the F_{n1,n2} - distribution
% for probability values in p.
%
% INPUT
%               p      the probability
%               n1,n2  the n. of degrees of freedom
%
% OUTPUT
%               F      the value for which P(x <= F) = p

a = n2/2; b = n1/2;
z = ibetai(1-p,a,b);
F = (n2./z-n2)./n1;

