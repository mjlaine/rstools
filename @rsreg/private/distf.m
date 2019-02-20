  function p = distf(F,n1,n2)
% keywords: F-distribution
% call: p = distf(F,n1,n2);
% The function computes the F_{n1,n2} - distribution probability
% values for 'F'.
%
% INPUT
%               F      the argument vector (F > 0)
%               n1,n2  the n. of degrees of freedom
%
% OUTPUT
%               p      the probability for 'x <= F'
%
% NOTE                 the points in (a vector) F must be strictly monotonic

  F = F(:)' ;
  if length(F) > 1
     x  = oneg(F)*n2./(n2 + n1 * F);
  else
     x  = n2/(n2 + n1 * F);
  end
  a  = n2/2;
  b  = n1/2;

  p  = 1 - betai(x,a,b);

