  function y = quadeval(x,bcoef)
% keywords: canonical analysis, response surface analysis, optimization
% call: y = quadeval(x,bcoef)
%
% function evaluates the quadratic form
%
%       y = b0 + x*b + x*B*x'  (x is a row vector or a matrix of row vectors)
%
%     where [b0,b,B] = quadmat(bcoef)  (see QUADMAT)
%
% INPUT:        x          evaluation points = rows of x
%               bcoef      coefficients of the quadratic function
%                          NOTE! the above order is given by INTERA
%                          with default indices. For missing terms use
%                          zero coefficients!
%
% OUTPUT        y          see the formula above
%
% SEE ALSO: INTERA, QUADMAT, QUADGRAD, QUADCANA and QUADPLOT

[b0,b,B] = quadmat(bcoef);

n = length(x(:,1));

y = b0*ones(n,1) + x*b + sum(((x*B).*x)')';
