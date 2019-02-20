  function y = screen(n,nrepl)
% keywords: screening design, experimental design
% call: y = screen(n,nrepl)
%
% This function constructs a screening design for 'n' variables with
% 'nrepl' replicate points (DEFAULT: nrepl = 1)

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2004/10/07 16:58:26 $

if nargin == 1
    nrepl = 1;
elseif nargin < 1
    error('too few inputs')
end

y = diag(ones(n,1));

if nrepl > 0
   y = [y;zeros(nrepl,n)];
end
