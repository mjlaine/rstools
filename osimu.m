  function y = osimu(x);
% keywords: demo
% call: y = osimu(x);
% a demonstration function for 'demoquad'.
%
% INPUT:   x     a matrix whose rows give the (non-coded) coordinates
%                of the experimental points.
%
% OUTPUT   y     the data values 'measured' at the x-points.

% b: a row containing the coefficients of the quadr. function:
% b(1) the constant, b(2:3) the linear terms, b(4:6) the quadr.terms

  r = 0.5;
 [m,n] = size(x);

 b=[4.4669e+00 -1.5827e-02 9.7008e-03 -2.6751e-02 -4.0211e-02 -6.1617e-02];
 xo=x;
 x=code(x,[80 140;100 150],1);
 x=[ones(m,1) x];

 A     = [b(4)   ,b(6)/2,
          b(6)/2 ,b(5)] ;
 xx    =  x(:,2:3);
 y     =  x*b(1:3)' + (sum(xx'.*(A*xx')))';
 y     =  (exp(y) + (exp(y)>0.1) .* (r*randn(m,1))) .* (xo(:,1)>0 & xo(:,2)>0);
