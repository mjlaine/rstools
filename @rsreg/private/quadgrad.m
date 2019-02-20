  function y = quadgrad(x,bcoef)
% keywords: canonical analysis, response surface analysis, optimization
% call: y = quadgrad(x,bcoef)
%
% function evaluates the gradient of the quadratic form
%
%       f = b0 + x*b + x*B*x'  (x is a row vector or a matrix of row vectors)
%
%     where [b0,b,B] = quadmat(bcoef)  (see QUADMAT)
%
% INPUT:        x          evaluation points = rows of x
%               bcoef      coefficients of the quadratic function
%
% OUTPUT        y          the gradient of f at x

[b0,b,B] = quadmat(bcoef);

n = length(x(:,1));

y = ones(n,1)*b' + 2*x*B;
