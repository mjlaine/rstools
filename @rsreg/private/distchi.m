  function p = distchi(x2,n);
% keywords: chi-squared distribution
% function p = distchi(x2,n);
% The function computes the chi^2 - distribution probability values
% for 'x2'.
%
% INPUT
%              x2     the argument vector
%              n      the n. of degrees of freedom
%
% OUTPUT
%              p      the probability  for 'x <= x2'.

  a  = n/2;
  x  = x2/2;

  vers=abs(version); vers = vers(1);
  if vers<53
     p = gamma(a,x);
  else
     p = gammainc(x,a);
  end
