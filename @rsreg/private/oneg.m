function y = oneg(x)
% keywords: version compability
% call: y = oneq(x)
% the function produces a matrix of ones with the same
% size as the matrix 'x'.
% NOTE. Only for compatibility between Matlab3.5, Matlab4, Matlab5

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2003/04/15 08:37:55 $

y = ones(size(x));

%if sum(size(x)>0)
%   y = ones(length(x(:,1)),length(x(1,:)));
%else
%   y = [];
%end
