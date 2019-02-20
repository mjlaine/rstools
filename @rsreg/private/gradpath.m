  function [path,ypath,sy] = gradpath(bcoef,x0,step,n,fixed,x,s,iprint)
% keywords: gradient path, experimental design, optimization
% call: [path,ypath,sy] = gradpath(bcoef,x0,step,n,fixed,x,s,iprint)
%
% function calculates a path along the gradient of quadratic function
% (coefficients given in bcoef).
%
% INPUT:      bcoef       coefficients of the function (see QUADMAT & QUADEVAL)
%             x0          starting point (OPTIONAL, DEFAULT = 0)
%             step        relative step in path (OPTIONAL, DEFAULT = 0.1)
%                         delta(x) = step*grad/norm(grad)
%             n           points in path (OPTIONAL, DEFAULT = 20)
%             fixed(nf,2) optional nf fixed variables and their values
%             x           original design matrix (OPTIONAL, needed for sy)
%                         NOTE! without second order terms
%             s           experimental error (estimated std of y)
%             iprint      printing option (OPTIONAL, DEFAULT = 1 <=> print,
%                         any other value <=> no printing )
% OUTPUT:     path        points along the path
%             ypath       function values along the path
%             sy          estimated standard errors of ypath (design matrix
%                         needed)

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

p = (sqrt(8*length(bcoef)+1)-3)/2;

if nargin == 6
    error('s must be supplied!')
elseif nargin == 5
   iprint =1;
elseif nargin == 4
   fixed = []; iprint =0;
elseif nargin == 3
   n = 20; fixed = []; iprint = 0;
elseif nargin == 2
   n = 20; step =0.1; fixed = []; iprint = 0;
elseif nargin == 1
   n = 20; step =0.1; x0=zeros(1,p); fixed = []; iprint = 0;
end

if length(x0)   == 0,  x0   = zeros(1,p); end
if length(step) == 0,  step = 0.1;        end
if length(n)    == 0,  n    = 20;         end

path  = zeros(n,p); 
ypath = zeros(n,1); 
sy    = zeros(n,1); 

z    = x0; 

if length(fixed) > 0;
    k    = remove((1:p)',fixed(:,1));
    l    = fixed(:,1);
    z(l) = fixed(:,2)';
end

if nargin == 7
    xx = intera(x);
end

for i = 1:n
    grad      = quadgrad(z,bcoef);
    if length(fixed) == 0
        z         = z + step*grad/norm(grad);
    else
        z(k)      = z(k) + step*grad(k)/norm(grad(k));
        z(l)      = fixed(:,2)';
    end

    path(i,:) = z;

    if nargin == 7
        [ypath(i),sy(i)] = regpred(intera(z),bcoef,1,1:length(xx(1,:)),xx,s);
    else
        [ypath(i)]       = regpred(intera(z),bcoef);
    end

    if iprint == 1
        if nargin == 7
            disp([i path(i,:) ypath(i) sy(i)])
        else
            disp([i path(i,:) ypath(i)])
        end
    end
end
