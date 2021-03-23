function [xy,Z]=plotquad2(limits,zlevels,bcoef,xfixed,xfree,...
    terms,minmax,intcep,opt)
% keywords: response surface analysis, regression, optimization
% call: [xy,Z]=plotquad2(limits,zlevels,bcoef,xfixed,xfree,...
%                        terms,minmax,intcep,opt)
% The function plots a contourplot of a plynomial function with respect to
% two given variables (xfree) on a given square. The values for the other x's
% are given in xfixed. The polynomial terms are given in terms.
% INPUT: limits   a vector of length 4 with [xmin, xmax, ymin, ymax]
%        zlevels  number of contour lines or a vector of contour levels
%        bcoef    coefficients of the quadratic function (see INTERA,
%                 QUADMAT and QUADEVAL)
%        xfixed   the fixed values of x. The values must be given for
%                 all components of x, the values of the free variables
%                 are arbitrary, e.g. zeros.
%        xfree    indices of the two free variables (varying within the limits)
%        terms    polynomial terms (see products)
%        minmax   OPTIONAL scaling limits for x's (see CODE)
%        opt      see code
% OUTPUT xy       the grid used
%        Z        the mesh points computed
% NOTE! If the function is parametrisized for coded units and you want
%       the plot in physical units (or vice versa) give 'minmax' and opt'
%       (see CODE for more information).
% SEE ALSO: QUADMAT, QUADEVAL, QUADCANA and GRADPATH

limits = limits(:);

% (limits,zlevels,bcoef,xfixed,xfree,terms,minmax,intcep,opt)
%    1       2      3      4     5     6     7     8     9
if nargin == 9 
    opt = 1; 
elseif nargin == 8
    opt = 1; intcep = 1;
else
    error('Too few inputs for plotquad2!')
end
if ~isempty(minmax)
   lim       = zeros(2,2);
   lim(:)    = limits;
   lim       = code(lim,minmax(:,xfree),opt);
   limits(:) = lim;
   xfixed    = code(xfixed,minmax,opt);
else
    error('minmax must be given for this model')
end
xmin   = limits(1);
xmax   = limits(2);
ymin   = limits(3);
ymax   = limits(4);
xstep  = (xmax-xmin)/30;
ystep  = (ymax-ymin)/30;
xaxis  = xmin:xstep:xmax;
yaxis  = ymin:ystep:ymax;
[X,Y]  = meshgrid(xaxis,yaxis);
[n,m]  = size(X);
Z      = zeros(size(X));
XX     = X(:);
YY     = Y(:);
x      = XX;
y      = YY;
i      = xfree(1); 
j      = xfree(2);
u      = ones(length(x),1)*xfixed;
u(:,i) = x;
u(:,j) = y;
uu     = products(u,terms,0);
if intcep == 1
    uu  = [ones(size(x)) uu];
end
z    = uu*bcoef;
Z(:) = z;
%if trans == 1
%    Z(:)   = exp(z);
%else
%    Z(:)   = z;
%end

% (limits,zlevels,bcoef,xfixed,xfree,terms,minmax,intcep,opt)
%    1       2      3      4     5     6     7     8     9
xy     = code([xaxis' yaxis'],minmax(:,xfree),-opt);

cs = contour(xy(:,1),xy(:,2),Z,zlevels); 
clabel(cs);
