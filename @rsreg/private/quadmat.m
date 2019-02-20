  function [b0,b,B]=quadmat(bcoef)
% keywords: canonical analysis, response surface analysis, optimization
% call: [b0,b,B]=quadmat(bcoef)
%
% function forms the vector of first order coefficients and the
% matrix of quadratic coefficients of the quadratic function
%      y = b0 + x*b + x*B*x'    (x is a row vector !)
% where bcoef is the vector of the coefficients of the same function
% in scalar form. The order of coefficients in bcoef is
% constant, 1,2,..,p, (1,1),(1,2),...,(p-1,p),(p,p) where p = length(x).
%
% INPUT:       bcoef      coefficients of the quadratic function
%                         NOTE! the above order is given by INTERA
%                         with default indices. For missing terms use
%                         zero coefficients!
% OUTPUT:      b0         intercept
%              b          first order coefficients
%              B          second order coefficients
%
% SEE ALSO: INTERA, QUADEVAL, QUADGRAD, QUADCANA and QUADPLOT

n = length(bcoef);
p = (sqrt(8*n+1)-3)/2;

b0 = bcoef(1);
b  = bcoef(2:p+1);

B  = vectriu(bcoef(p+2:n),p);

B  = (B+B')/2;
