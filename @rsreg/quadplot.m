function out=quadplot(rsres,varargin)
%QUADPLOT plot quadratic response surface
% QUADPLOT(RSRES,OPTIONS)
% options:
%  type     'contour' or 'mesh'
%  ifree    indexes of two free x variables
%  xfixed   values for the fixed x's, in original units,
%           the values must be given for all components of x
%           xfixed = 'mean' uses mean values (default)
%           xfixed = 'opt' uses the stationary point of the fit
%  zoom     relative zoom factor, default 100
%           with coded units the limits are multiplied by zoom/100,
%           and with physical units the lower limits are divided
%           by zoom/100, and upper limits are multiplied by zoom/100
%  x        x-points to be added in the plot in original units
%  y        y-values for the x points
%  zlevels  contour levels as in CONTOUR
%  limits   limits for the free variables (x and y coordinates) 
%            in the form [xmin ymin; xmax ymax]

res=rsres.res;

if isfield(res,'class');
  class = res.class;
else
 error('input argument is incorrect for quadplot');
end

if ~strcmp(class,'reg')
  error('this funtion works only for rsreg output');
end

if nargin<2
  options=[];
end

if nargin==2
  options=varargin{1};
end
if nargin>2
  [options,status]=optionpairs(varargin{:});
  if status
    error('Error with input arguments, see help')
  end
end

goodoptions = {'ifree','xfree','xfixed','zoom','type','x','y','zlevels','limits',...
    'terms','minmax','code'};
[yn,bad]=checkoptions(options,goodoptions);
if yn==0
  fprintf('bad options for quad:\n');
  for i=1:length(bad)
    fprintf('\t%s\n',bad{i});
  end
  fprintf('available options are:\n');
  for i=1:length(goodoptions)
    fprintf('\t%s\n',goodoptions{i});
  end
  error('check your options')
  return;
end

xdata = getpar(options,'x',[]);
ydata = getpar(options,'y',[]);


terms = getpar(options,'terms',res.terms);
minmax = getpar(options,'minmax',res.minmax);
docode =getpar(options,'code',res.code);

ifree=getpar(options,'ifree',1:2);
ifree=getpar(options,'xfree',ifree); % for backward compatibility
xfixed=getpar(options,'xfixed','mean');

if ischar(xfixed)
  switch xfixed(1:3)
   case 'mea'
    xfixed=[];
    xfixed = mean(minmax);
   case 'opt'
    o = cana(rsres);
    xfixed = o.xs; % coded or not? CHECK THIS
   otherwise
    error('Unknown value for xfixed: %s',xfixed);
    % xfixed = 1:2;
  end
end
% only fixed values given
nx = size(minmax,2);
if length(xfixed) == nx - 2
  dum = zeros(1,nx);
  ifix = setdiff(1:nx,ifree);
  dum(ifix) = xfixed;
  xfixed = dum;
end
zoom = getpar(options,'zoom',100);
type = getpar(options,'type','mesh');
zlevels = getpar(options,'zlevels',10);
limits = getpar(options,'limits',[]);
%minmax=res.minmax;
if docode
  opt = +1;
else
  opt = -1;
  n= size(minmax,2);
  minmax=[-ones(1,n);ones(1,n)];
end
trans = 0;

if isempty(limits)
%  limits = minmax(:,ifree);
  limits = res.xlimits(:,ifree);
elseif size(limits,1) ~=2 | size(limits,2)~= 2
  error('limits should be 2x2 matrix of [x1min x2min;x1max x2max] values')
end
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
if size(terms,1)<=2
    bfull  = quadcomp(res.b,terms,res.nx);
    [xy,Z] = plotquad(limits,zlevels,bfull,xfixed,ifree,minmax,opt,trans);
else
    [xy,Z] = plotquadTerms(terms,res.nx,limits,zlevels,res.b,...
                    xfixed,ifree,minmax,opt,trans);
end
h=gca;

i = res.intcept==1;
if strcmp(type,'mesh')
  meshc(xy(:,1),xy(:,2),Z);
  i = res.intcept==1;
  xlabel(res.xnames{ifree(1)})
  ylabel(res.xnames{ifree(2)})
  zlabel(res.yname);
else  
  xlabel(res.xnames{ifree(1)})
  ylabel(res.xnames{ifree(2)})
end
h=gca;

if ~isempty(xdata)
  zlim=get(h,'zlim');z0=zlim(1);
  hold on
  if ~isempty(ydata)
    plot3(xdata(:,ifree(1)),xdata(:,ifree(2)),ydata,'o');
  else
    plot3(xdata(:,ifree(1)),xdata(:,ifree(2)),ones(size(xdata,1),1)*z0,'o');
  end
  hold off
end

if nargout>0
  out=[];
  out.x = xy(:,1);
  out.y = xy(:,2)
  out.z = Z;
end
