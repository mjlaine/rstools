function out=rsreg(x,y,varargin)
%RSREG   quadratic response surface regression
% RSREG(X,Y) fits regression model
% RSREG(X,Y,OPTIONS) gives options
% OPTIONS can be a structure with parameters as fields
% OPTIONS.PAR1 = VALUE
% OPTIONS.PAR2 = VALUE
% or they can be specifies as  'par',value pairs in the command line
% RSREG(X, Y, 'PAR1', VALUE, 'PAR2', VALUE, ...)
% Options:
% 
%  intercept  add intercept, (default 1)
%  intera     add interactions
%               0 do not add
%               1 all pairwise crossproduct interactions
%               2 quadratic model (default)
%               3 all crossproduct interactions
%  code       code the x values (1)
%  minmax     minmax as in CODE (default: calculate from data)
%  composite  assume composite design in CODE (0)
%  w          weights for observations
%  xnames     names for the X columns as char array
%  yname      name for Y
%  terms      terms to use in the model as in INTERA
%  savedata   save expanded X matrix in the result
% 
% use METHODS(RSREG) to see available methods for regression results 
%

if nargin == 0 % return empty rsreg object
  out.Class  = 'rsreg';
  out.output = 0;
  out.res = [];
  out.res.class = 'empty';
  out = class(out,'rsreg');
  return;
end

if isa(x,'rsreg') % return self
  out = x;
  return;
end

if nargin==3
  options=varargin{1};
end
if nargin>3
  [options,status]=optionpairs(varargin{:});
  if status
    error('Error with input arguments, see help')
  end
end

res.class='reg';

if nargin<3
  options=[];
end

if size(y,2) ~= 1
  error('y should be a column vector');
end
if size(x,1) ~= size(y,1)
  error('sizes of x and y do not match');
end

goodoptions = {'experr','w','intera','code','minmax','composite','xnames','yname','terms','output','intercept','savedata'};
[yn,bad]=checkoptions(options,goodoptions);
if yn==0
  fprintf('bad options for reg:\n');
  for i=1:length(bad)
    fprintf('\t%s\n',bad{i});
  end
  fprintf('available options are:\n');
  for i=1:length(goodoptions)
    fprintf('\t%s\n',goodoptions{i});
  end
  error('please check options');
end

%experr = getpar(options,'experr',[]);
experr = getpar(options,'experr',0);
w      = getpar(options,'w',[]);
colx =[];
coly =[];
intcept = getpar(options,'intercept',1);
ido     = getpar(options,'ido',1); %% mikä tämä on
int     = getpar(options,'intera',2);
docode  = getpar(options,'code',1);
minmax  = getpar(options,'minmax',[]);
imax    = getpar(options,'composite',0);
terms   = getpar(options,'terms',[]); 
output  = getpar(options,'output',1);

[nrowx,ncolx] = size(x);
xorig         = x;
xlimits       = [min(x);max(x)]; % save original limits for plots

if isempty(minmax)
  minmax = [min(x);max(x)];
  if imax
    minmax = minmax./(2^(ncolx/4));
  end  
end
if docode
  x = code(x,minmax,1);
end

yname   = getpar(options,'yname','Y');
xnames  = getpar(options,'xnames',[]);

if isempty(xnames) 
    for i=1:ncolx
      xnames{i} = sprintf('X%d',i);
    end
end

if isempty(terms)
  if int == 1
    [~,terms] = intera(x,[],[],-2);
  elseif int==2
    [~,terms] = intera(x);
  elseif int==3
    [~,terms] = intera3(x);
  else
    terms = [1:ncolx;zeros(1,ncolx)];
  end
end

[rowterms,nterms] = size(terms);
names             = xnames;
nnames            = cell(nterms,1);
for i=1:nterms
  nnames{i} = names{terms(1,i)};
  for j=2:rowterms
    if terms(j,i) > 0
      nnames{i} = [nnames{i},'*',names{terms(j,i)}];
    end
  end
end
names = nnames;

x    = products(x,terms,0);
x(abs(x)<10*eps)=0; % fix products result

% minmax to have only those variables present in options.terms
% is this really needed?
if size(minmax,2) ~= ncolx 
    minmax2 = minmax;
    xlimit2 = xlimits;
    xnames2 = xnames;
    ii = terms(:,sum(terms~=0)); % which columns have non-zero
    ii = setdiff(unique(ii(:)),0); % find all variables present
    minmax2 = minmax(:,ii);
    xlimits2 = xlimits(:,ii);
    xnames2 = xnames(ii);
end

if intcept
  names = {'intercept',names{:}};
end

[b,yfit,stp,resi,s,R2,ypred,e,h,D] = ...
    regres(x,y,experr,w,colx,coly,intcept,ido);
n      = size(y,1);
p      = length(b);
experr = pool(xorig,y);

if size(experr,2)<2 | intcept ==0% no replicates
  lof  = NaN;
  f0   = 0;
  plof = 0;
  p0   = 0;
  experr = [NaN 0];
elseif experr(:,1) == 0 % replicates but no variance
  lof  = NaN;
  f0   = 0;
  plof = 0;
  p0   = 0;
  experr = [NaN experr(1,2)];  
elseif n-p-experr(1,2) <=0
  lof  = NaN;
  f0   = 0;
  plof = 0;
  p0   = 0;
else
  [~,~,lof,~,plof] = lackofit(y,yfit,p,experr(:,1).^2,experr(:,2),1);
end

if size(stp,2) == 2
  for i=1:size(stp,1)
    if isnan(stp(i,2))
      stp(i,3) = NaN;
    else
      stp(i,3) = 1-distt(abs(stp(i,2)),n-p,2);
    end
%    if stp(i,3) < 1e-4, stp(i,3) = 0; end
  end
end

SSres = sum(resi.^2);
if intcept == 0
  SStot = sum(y.^2);
  R2(1) = (1-SSres/SStot)*100; % fix R2 % (1-...)*100 lisätty / VMT 21.3.
else
  SStot = sum((y-mean(y)).^2);
end
SSreg = SStot-SSres;
dftot = n-1;
dfres = n-p;
dfreg = p-1;
if dfres>0
  MSres = SSres/dfres;
else
  MSres = NaN;
end
MSreg = SSreg/dfreg;
f0 = MSreg/MSres;
if isnan(f0)|dfres<=0|f0<0
  p0 = NaN;
else
%  f0,dfreg,dfres
  p0 = 1-distf(f0,dfreg,dfres);
end
%if p0<1e-4; p0=0;end

% SSreg
SS0 = 0; SS1 = 0; SS2 = 0; df0=0;df1=0;df2=0;
if size(terms,1)<3
    terms0 = prod(terms)==0;
    terms1 = diff(terms)>=1;
    terms2 = diff(terms)==0 & ~terms0;
    if sum(terms0)>0
      [~,yfit0]= regres(x(:,terms0),y,0,w,colx,coly,intcept,ido);
      SS0 = SStot-sum((y-yfit0).^2); % linear terms
      df0 = sum(terms0);
    end
    if sum(terms1)>0
      [~,yfit1]= regres(x(:,terms0|terms1),y,0,w,colx,coly,intcept,ido);
      SS1 = SStot-sum((y-yfit1).^2)-SS0; % cross product
      df1 = sum(terms1);
    end
    if sum(terms2)>0
      [~,yfit2]= regres(x(:,terms0|terms1|terms2),y,0,w,...
                        colx,coly,intcept,ido);
      SS2 = SStot-sum((y-yfit2).^2)-SS0-SS1; % quadratic terms
      df2 = sum(terms2);
    end
end
% lack-of-fit
SSpe  = experr(:,1).^2.*experr(:,2);
dfpe  = experr(:,2);
SSlof = SSres-SSpe;
dflof = dfres-dfpe;
if dfpe==0
  MSpe=Inf;
else
  MSpe  = SSpe/dfpe;
end
if dflof==0
  MSlof =Inf;
else
  MSlof = SSlof/dflof;
end

res.x      = x;
res.b      = b;
res.names  = names;
res.xnames = xnames;
res.yname  = yname;
if exist('minmax2','var')
  res.minmax2 = minmax2;
  res.xnames2 = xnames2;
  res.xlimits2 = xlimits2;
end
res.yfit  = yfit;
res.stp   = stp;
res.res   = resi;
res.studres = e;
res.Cook  = D;
res.rmse  = s;
res.r2 = R2(1);
if (n-p)<=0|SStot==0
  res.r2adj = NaN;
else
  res.r2adj = (1-SSres/SStot*(n-1)/(n-p))*100;
end
res.q2 = R2(2);
res.ypred  = ypred;
res.minmax = minmax;
res.xlimits = xlimits;
res.code   = docode;
res.terms  = terms;
res.n      = n;
res.nx     = ncolx;
res.intcept = intcept;
res.intera  = int;
%disp('rsreg/378')
%disp(int)
res.ssreg = SSreg;
res.sslin   = SS0;
res.sscro   = SS1;
res.ssqua   = SS2;
res.ssres = SSres;
res.sstot = SStot;
res.sspe  = SSpe;
res.sslof = SSlof;
res.dfreg = dfreg;
res.dflin = df0;
res.dfcro = df1;
res.dfqua = df2;
res.dfres = dfres;
res.dftot = dftot;
res.dfpe  = dfpe;
res.dflof = dflof;
res.f     = f0;
res.pf    = p0;
res.flof  = lof;
res.plof  = plof;

if getpar(options,'savedata',0)
  if intcept==1
    res.x  = [ones(size(x,1),1),x];
  else
    res.x  = x;
  end
  res.y  = y;
end

% save x'x 24.11.2005
if intcept==1
  X  = [ones(size(x,1),1),x];
  if isempty(w)
    res.xtx = X'*X;
  else
    res.xtx = X'*diag(w)*X;
  end
else
  if isempty(w)
    res.xtx  = x'*x;
  else
    res.xtx  = x'*diag(w)*x;
  end
end
res.w = w;

out.Class = 'rsreg';
out.output = output;
out.res = res;
out = class(out,'rsreg');  
%disp(out.res)
%disp('out.res.intera from rsreg')
%disp(out.res.intera)
%if nargout > 0
%  out=res;
%else
%  show(res);
%end
