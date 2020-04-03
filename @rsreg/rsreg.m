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
  return;
end

%experr = getpar(options,'experr',[]);
experr = getpar(options,'experr',0);
w      = getpar(options,'w',[]);
colx =[];
coly =[];
intcept = getpar(options,'intercept',1);
ido     = getpar(options,'ido',1);
int     = getpar(options,'intera',2);

docode  = getpar(options,'code',1);
minmax  = getpar(options,'minmax',[]);

imax    = getpar(options,'composite',0);

inames  = getpar(options,'terms',[]);

output  = getpar(options,'output',1);

[mx,nx] = size(x);
xorig = x;

xlimits = [min(x);max(x)]; % save original limits for plots

if isempty(minmax)
  minmax = [min(x);max(x)];
  if imax
    minmax = minmax./(2^(nx/4));
  elseif size(x,1)>4 & size(x,2)>1
    % try to remove axial experiments
    m = mean(minmax); s = abs(diff(minmax));
    xx=x(abs(x(:,1)-m(1))>s(1)*.05&abs(x(:,2)-m(2))>s(2)*0.05,:);
    if size(xx,1)>1
      minmax = [min(xx);max(xx)];
    end
  end  
end
if docode
  x = code(x,minmax,1);
else
%  minmax = [-ones(1,nx);ones(1,nx)];
end

yname=getpar(options,'yname','Y');

names  = getpar(options,'xnames',[]);

po=size(x,2);
if isempty(inames)
  if isempty(names)
    for i=1:size(x,2)
      names{i} = sprintf('X%d',i);
    end
  end
  if int == 1
    [x,inames] = intera(x,[],[],-2);
  elseif int==2
    [x,inames] = intera(x);
  elseif int==3
    [x,inames] = intera3(x);
  else
    inames = [1:nx;zeros(1,nx)];
  end
  if int==1 | int==2
    for i=1:size(inames,2)
      if prod(inames(:,i))
        names{i} = sprintf('%s*%s',names{inames(1,i)},names{inames(2,i)});
      end
    end
  end
  if int == 3
    for i=1:size(inames,2)
      nnames{i} = names{inames(1,i)};
      for j=2:size(inames,1)
        if inames(j,i) > 0
          nnames{i} = [nnames{i},'*',names{inames(j,i)}];
        end
      end
    end
    names = nnames;
  end
else

  int = 0; % no interactions generated
  nt = size(inames,2);
  xnew = zeros(size(x,1),nt);
  x = products(x,inames,0);
  x(abs(x)<10*eps)=0; % fix products result
  nx = max((inames(:)));
  if isempty(names)
    for i=1:nx
      names{i} = sprintf('X%d',i);
    end
  end
  for i=1:nt
    nnames{i} = names{inames(1,i)};
    for j=2:size(inames,1)
      if inames(j,i) > 0
        nnames{i} = [nnames{i},'*',names{inames(j,i)}];
      end
    end
  end
  names = nnames;

%  nx = sum(unique(inames(:))~=0);


%  int = 0; % no interactions generated
%  if size(inames,1) ~=2
%    error('terms should be 2xnterms matrix');    
%  end
%  nt = size(inames,2);
%  xnew = zeros(size(x,1),nt);  
%  nx = max((inames(:)));
%  if isempty(names)
%    for i=1:nx
%      names{i} = sprintf('X%d',i);
%    end
%  end
%  for i=1:nt
%    xnew(:,i) = x(:,inames(1,i));
%    if inames(2,i)>0
%      xnew(:,i) = xnew(:,i).*x(:,inames(2,i));
%      nnames{i} = sprintf('%s*%s',names{inames(1,i)},names{inames(2,i)});
%    else
%      nnames{i} = sprintf('%s',names{inames(1,i)});
%    end
%  end
%    names = nnames;
%  x=xnew;
%%  nx = sum(unique(inames(:))~=0);
  
  
  if size(minmax,2) ~= nx % minmax to have only those variables present in options.terms
%   minmax = [-ones(1,nx);ones(1,nx)];
%   minmax = minmax(:,inames(2,:)==0);
%    minmax = minmax(:,sum(inames~=0)==1); 
    ii = sum(inames~=0); % which columns have non-zero
    ii = setdiff(unique(ii(:)),0); % find all variables present
    minmax = minmax(:,ii);
  end
end
if intcept
  names = {'intercept',names{:}};
end

%experreg = 0;
%wstate1 = warning('off','MATLAB:singularMatrix');
%wstate2 = warning('off','MATLAB:divideByZero');
[b,yfit,stp,resi,s,R2,ypred,e,h,D]=regres(x,y,experr,w,colx,coly,intcept,ido);
n = size(y,1);
p = length(b);
%warning(wstate1);
%warning(wstate2);

%if size(experr,2)<2
%  [experr,mse,ymean,comb,icomb,irep] = pool(xorig,y);
  experr = pool(xorig,y);
%end
if size(experr,2)<2 | intcept ==0% no replicates
  lof  = NaN;
  f0   = 0;
  plof = 0;
  p0   = 0;
  experr = [NaN 0];
elseif experr(:,1) == 0 % replicates but no variance
%  [R2l,Ra2,lof]=lackofit(y,yfit,p,experr(:,1).^2,experr(:,2),0);
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
  [R2l,Ra2,lof,f0,plof,p0]=lackofit(y,yfit,p,experr(:,1).^2,experr(:,2),1);
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
  R2(1) = SSres/SStot; % fix R2
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
if size(inames,1)<3
terms0 = prod(inames)==0;
terms1 = diff(inames)>=1;
terms2 = diff(inames)==0 & ~terms0;
if sum(terms0)>0
  [b0,yfit0]= regres(x(:,terms0),y,0,w,colx,coly,intcept,ido);
  SS0 = SStot-sum((y-yfit0).^2); % linear terms
  df0 = sum(terms0);
end
if sum(terms1)>0
  [b1,yfit1]= regres(x(:,terms0|terms1),y,0,w,colx,coly,intcept,ido);
  SS1 = SStot-sum((y-yfit1).^2)-SS0; % cross product
  df1 = sum(terms1);
end
if sum(terms2)>0
  [b2,yfit2]= regres(x(:,terms0|terms1|terms2),y,0,w,colx,coly,intcept,ido);
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

res.b=b;
res.names = names;
res.yname = yname;
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
res.terms  = inames;
res.n      = n;
res.nx     = nx;
res.intcept = intcept;
res.intera  = int;

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

%if nargout > 0
%  out=res;
%else
%  show(res);
%end
