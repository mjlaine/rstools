  function [xy,Z]=plotq(b,minmax,terms,xfree,xfixed,zoom,...
                        zlevels,opt,trans)
% keywords: response surface analysis, regression, optimization
% call: [xy,Z]=plotq(b,minmax,terms,xfree,xfixed,zoom,...
%                      zlevels,opt,trans)
% The function plots quadratic response surfaces. An easier-to-use version
% of the function PLOTQUAD for models given in *coded* variables.
% INPUT   b         the regression coefficients
%         minmax    the min/max values used in coding the regression
%                   variables. See CODE.
%         terms     the terms in the model, as given with 'names' by INTERA
%                   OPTIONAL, default full quadratic model
%         xfree     indices for the two free variables.
%                   OPTIONAL, default xfree = 1:2
%         xfixed    values (in original units) for the variables not in the
%                   plot. OPTIONAL, default: the mean values
%         zoom      the window for the plot:
%                   zoom = p       the plot gives 'p' percent of the
%                                  'minmax' rectangle
%                   zoom = [px,py] the plot gives 'px'and 'py' percent
%                                  of the x- and y ranges of 'minmax'
%                                  rectangle
%                   zoom = [px_low py_low
%                           px_up  py_up]  the plot expands/shrinks the lower/
%                                  upper ends of the x-range of 'minmax' by
%                                  px_low and px_up percents, respectively.
%                                  Similarly for the y-axes.
%                   OPTIONAL, default:   zoom = 100
%         zlevels   either the n of contour lines or the levels of the
%                   contour lines. OPTIONAL, default: zlevels = 10
%         opt       OPTIONAL direction of scaling (see CODE)
%                   default: opt = 1
%         trans     trans = 1 => use exp transformation
%                   trans = 0 => no transformation
%                   OPTIONAL. default: trans = 0
% OUTPUT  xy        the grid used
%         Z         the mesh points computed

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

if nargin == 1; error('at least minmax must be given in addition to b'), end

m      = length(minmax(1,:));
vals   = mean(minmax);
x      = ones(1,m);
[x,ia] = intera(x);

if nargin == 8, trans = 0; end
if nargin == 7, trans = 0; opt = 1; end
if nargin == 6, trans = 0; opt = 1; zlevels = 10; end
if nargin == 5, trans = 0; opt = 1; zlevels = 10; zoom = 100; end;
if nargin == 4, trans = 0; opt = 1; zlevels = 10; zoom = 100;
                xfixed = vals;
end
if nargin == 3, trans = 0; opt = 1; zlevels = 10; zoom = 100;
                xfixed = vals; xfree = 1:2;
end
if nargin == 2, trans = 0; opt = 1; zlevels = 10; zoom = 100;
                xfixed = vals; xfree = 1:2; terms = ia;
end

mi = size(terms,1);
if mi == 0, terms = ia; end

if length(xfree) == 0
     xfree = 1:2;
end

if length(xfixed) == 0
     xfixed = vals;
end
if length(xfixed) == m-2
   ii = 1:m;
   ixfix = remove(ii,[],xfree);
   xx(ixfix) = xfixed;
   xx(xfree) = zeros(1,2);
   xfixed    = xx;
end

if length(opt) == 0, opt = 1; end
if length(zlevels) == 0, zlevels = 10; end
if length(zoom) == 0, zoom = 100; end

limits = minmax(:,xfree);
interact = terms;

signs  = [-sign(limits(1,1)) -sign(limits(1,2));
           sign(limits(2,1))  sign(limits(2,2))];
zoom   = zoom/100;

if length(zoom(:)) == 2
   zoom = ones(2,1)*zoom;
elseif length(zoom) == 1
   zoom = ones(2,2)*zoom;
end

zoom = zoom.^signs;

limits = zoom.*limits;
limits = limits(:)';

if (length(b(:,1))-1 == length(ia(1,:)))
   bf = b;
else
   bf = quadcomp(b,terms,m);
end

[xy,Z] = plotquad(limits,zlevels,bf,xfixed,xfree,minmax,opt,trans);

