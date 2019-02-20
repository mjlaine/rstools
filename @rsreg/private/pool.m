function [experr,mse,ymean,comb,icomb,irep] = pool(X,Y,colx,coly)
% keywords: pooling, regression, anova
% call: [experr,mse,ymean,comb,icomb,irep] = pool(X,Y,colx,coly)
% INPUT  X        The design matrix (n x p). 'X' contains the independent
%                 (design) variables x 
%        Y        The response matrix(n x q). 'Y' contains the y-variables
%                 i.e. the responses
%        colx     column indexes for X-matrix. OPTIONAL
%        coly     column indexes for Y-matrix. OPTIONAL
% OUTPUT experr   a (q x 2) matrix [pstd ndf]:
%                 pstd     std of pure error: square root of the 
%                          pooled variances:
%
%                                     k   ni
%                             pvar = sum(sum( y_ij-y_i)^2)/(n-k),
%                                     i   j
%
%                          where n is the n. of observations,
%                          k  the n. of groups
%                 ndf      n. of degrees of freedom of 'pvar':  n - k.
%        mse      the variances of the y-variables in each x-combination
%                 (s^2 = sum(y_ij-y_i)^2/(ni-1))
%        ymean    the means of the y-variables in each x-combination
%        comb     the x-combinations, the distinct design points
%        icomb    the row indexes for each distinct design point in X
%        irep     the replicate indexes

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.3 $  $Date: 2004/10/04 10:57:34 $

ndf =[];
[nx,mx] = size(X);
[ny,my] = size(Y);

if nargin < 2
  error(' Too few input arguments');
elseif nargin < 3
  colx = 1:mx;
  coly = 1:my;
elseif nargin < 4
  coly = 1:my;
end

if length(colx) == 0
  colx      = 1:mx;
end

X1       =   [X, Y];
[n,m]    =   size(X1);

onex = 0;
pit  = length(colx);
if pit==1
  X1   = [X1, ones(n,1)];
  colx = [colx, m+1];
  onex = 1;
end
[n,m]    =   size(X1);
[n1,m1]  =   size(X1);

group    =   0; replp = 0;
[n2,m2]  =   size(coly);
     
while n1 > 0
  group = group+1;
  ero   = ones(n1,1)*X1(1,:) - X1;
  rind  = find(sum(abs((ero(:,colx))'))==0);
  lr    = length(rind);
  if lr > 1, replp = replp + 1; end
  comb(group,:) = X1(1,colx);
  X22   = X1(rind,coly+mx);
  [n2,m2]= size(X22);
  if n2 == 1
    ymean(group,:)   = X22;
    mse(group,:)     = zeros(1,m2);
    sspool(group,:)  = zeros(1,m2);
  else
    ymean(group,:)   = mean(X22);
    mse(group,:)     = std(X22).^2;
    sspool(group,:)  = (n2-1)*std(X22).^2;
  end;
  X1      =   remove(X1,rind);
  [n1,m1] =   size(X1);
end

if group < n
  pvar = sum(sspool)/(n-group);
  ndf     = n - group;
else
  pvar = 0;
end
pstd = sqrt(pvar);
pstd = pstd(:);
[an,am]=size(pstd);
ndf=ndf*ones(an,am);
experr = [pstd, ndf];

if onex == 1
  comb = comb(:,1);
  colx = colx(:,1);
end

if nargout > 4
  [m,n] = size(X);
  [mc,n] = size(comb);
  long = 0;
  for i=1:mc
    ero = X(:,colx)-ones(m,1)*comb(i,:);
    if onex == 1
      rind= find((ero)==0)';
    else rind = find(sum(abs(ero'))==0);
    end;
    lr = length(rind);
    icomb(i,1:lr)= rind;
  end;

end

if nargout>5
  [n,m] = size(icomb);
  if m>1
    irep = find(icomb(:,2)>0);
    aux = [];
    for i=1:length(irep);
      aux = unionset(aux,icomb(irep(i),:));
    end
    irep = minusset(aux,0);
  else
    irep = [];
  end
end
