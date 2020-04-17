function [xy,Z]=plotquadTerms(terms,nx,limits,zlevels,bcoef,xfixed,ifree,...
                           minmax,opt,trans)
% keywords: response surface analysis, regression, optimization
% call: [xy,Z]=plotquadTerms(limits,zlevels,bcoef,xfixed,ifree,...
%                          minmax,opt,terms,trans)
% The function plots a contourplot of a quadratic function with respect to
% two given variables (ifree) on a given square. The values for the other x's
% are given in xfixed.
% INPUT: terms    terms of the model given as in products
%        nx       original # of x variables
%        limits   a vector of length 4 with [xmin, xmax, ymin, ymax]
%        zlevels  number of contour lines or a vector of contour levels
%        bcoef    coefficients of the quadratic function (see INTERA,
%                 QUADMAT and QUADEVAL)
%        xfixed   the fixed values of x. The values must be given for
%                 all components of x, the values of the free variables
%                 are arbitrary, e.g. zeros.
%        ifree    indices of the two free variables (varying within the limits)
%        minmax   OPTIONAL scaling limits for x's (see CODE)
%        opt      OPTIONAL direction of scaling (see CODE) DEFAULT: opt=1
%        trans    trans = 1 => use exp transformation (or any transformation
%                 if user changes the code on the line 'Z(:) = exp(z)')
%                 trans = 0 => no transformation (OPTIONAL, DEFAULT: trans=0)
% OUTPUT xy       the grid used
%        Z        the mesh points computed
% NOTE! If the function is parametrisized for coded units and you want
%       the plot in physical units (or vice versa) give 'minmax' and opt'
%       (see CODE for more information).
% SEE ALSO: QUADMAT, QUADEVAL, QUADCANA and GRADPATH

limits = limits(:);
ifixed = 1:nx;

if nargin == 7 
    trans  = 0; 
    opt    = 1; 
    minmax = [];
end
if nargin > 7
   if nargin == 10
      if isempty(opt), opt = 1; end
   elseif nargin == 9
      trans = 0;
   elseif nargin == 8
      trans = 0; opt = 1;
   end
   if ~isempty(minmax)
       lim             = zeros(2,2);
       lim(:)          = limits;
       lim             = code(lim,minmax(:,ifree),opt);
       limits(:)       = lim;
       minmaxfix       = minmax;
       minmaxfix(:,ifree) = [];
       xfixed          = code(xfixed,minmaxfix,opt);
   end
end

xmin   = limits(1);
xmax   = limits(2);
ymin   = limits(3);
ymax   = limits(4);

xstep  = (xmax-xmin)/30;
ystep  = (ymax-ymin)/30;

xaxis  = xmin:xstep:xmax;
yaxis  = ymin:ystep:ymax;

[X,Y]        = meshgrid(xaxis,yaxis);
[n,m]        = size(X);
Z            = zeros(n,m); % for the response
XX           = X(:);
YY           = Y(:);
x            = XX;
y            = YY;
i            = ifree(1); 
j            = ifree(2);
xfix         = zeros(1,nx);
ifix         = 1:nx;
ifix(ifree)  = [];
xfix(ifix)   = xfixed;
xfix         = zeros(1,nx);
xfix(ifixed) = xfixed;
u            = ones(length(x),1)*xfix;
u(:,i)       = x; % first free variable
u(:,j)       = y; % second free variable
U            = products(u,terms,0);
U            = [ones(size(x)) U]; % change later fo no intercept models
z            = U*bcoef; 
if trans == 1
    Z(:)   = exp(z);
else
    Z(:)   = z;
end

if nargin > 5
   if nargin == 6
      opt = 1;
   end
   if length(minmax) > 0
       xy     = code([xaxis' yaxis'],minmax(:,ifree),-opt);
   else
       xy     = [xaxis' yaxis'];   
   end
else
   xy     = [xaxis' yaxis'];   
end


cs=contour(xy(:,1),xy(:,2),Z,zlevels); clabel(cs);

