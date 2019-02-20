  function [xy,Z]=plotquad(limits,zlevels,bcoef,xfixed,xfree,...
                           minmax,opt,trans)
% keywords: response surface analysis, regression, optimization
% call: [xy,Z]=plotquad(limits,zlevels,bcoef,xfixed,xfree,...
%                          minmax,opt,trans)
% The function plots a contourplot of a quadratic function with respect to
% two given variables (xfree) on a given square. The values for the other x's
% are given in xfixed.
% INPUT: limits   a vector of length 4 with [xmin, xmax, ymin, ymax]
%        zlevels  number of contour lines or a vector of contour levels
%        bcoef    coefficients of the quadratic function (see INTERA,
%                 QUADMAT and QUADEVAL)
%        xfixed   the fixed values of x. The values must be given for
%                 all components of x, the values of the free variables
%                 are arbitrary, e.g. zeros.
%        xfree    indices of the two free variables (varying within the limits)
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

if nargin == 5 trans=0; opt = 1; end
if nargin > 5
   if nargin == 8
      if length(opt) == 0, opt = 1; end
   elseif nargin == 7
      trans = 0;
   elseif nargin == 6
      trans = 0; opt = 1;
   end
   if length(minmax) > 0
       lim       = zeros(2,2);
       lim(:)    = limits;
       lim       = code(lim,minmax(:,xfree),opt);
       limits(:) = lim;
       xfixed    = code(xfixed,minmax,opt);
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

[X Y]  = meshgen(xaxis,yaxis);
[n,m]  = size(X);
Z      = zerog(X);
XX     = X(:);
YY     = Y(:);
x      = XX;
y      = YY;
i      = xfree(1); 
j      = xfree(2);

u      = ones(length(x),1)*xfixed;

u(:,i) = x;
u(:,j) = y;

z      = quadeval(u,bcoef);

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
       xy     = code([xaxis' yaxis'],minmax(:,xfree),-opt);
   else
       xy     = [xaxis' yaxis'];   
   end
else
   xy     = [xaxis' yaxis'];   
end


 vers=abs(version); vers = vers(1);
 if vers<53    %Matlab 3.5 & 4
    cs=contour(Z,zlevels,xy(:,1),xy(:,2)); clabel(cs)
 else          %Matlab 5
    cs=contour(xy(:,1),xy(:,2),Z,zlevels); clabel(cs);
 end
%meshc(xy(:,1),xy(:,2),Z)

