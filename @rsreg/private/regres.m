  function [b,yfit,stp,res,s,R2,ypred,e,h,D]=regres(x,y,experr,w,colx,coly,intcep,ido)
% keywords: regression analysis
% call: [b,yfit,stp,res,s,R2,ypred,e,h,D]=regres(x,y,experr,w,colx,coly,intcep,ido)
% the function computes the multilinear regression.
% INPUT:   x        the design matrix (n x p)
%          y        the data matrix (n x q)
%          experr   a (q x 2) matrix of [pstd ndf] (see POOL).
%                   SUMMARY OF CHOICES:
%                      experr = 1:  computed here by POOL for all y
%                      experr = 0:  computed here by residuals for all y
%                      experr       given as precomputed by, e.g., POOL.
%                      experr       given as a (q x 1) vector of [pstd] only
%                   OPTIONAL, default experr=1. experr=0 if no replicates found
%          w        the weight matrix (n x q), for weighted least squares
%                   OPTIONAL, default: weights not used
%          colx     column indexes for the design matrix.
%                   OPTIONAL, default: all columns
%          coly     column indexes for the data matrix
%                   OPTIONAL, default: all columns
%          intcep   intercept option, intcep=1: model contains an intercept
%                   any other value:no intercept.OPTIONAL (default:intercep=1)
%          ido      p-value option,   ido = 1: compute the p-values.
%                   Any other value: not computed.
%                   OPTIONAL, default: p computed, if std not computed by residuals
% OUTPUT:  b        the estimated regression coefficients
%          yfit     the values of the response computed by the model
%          stp      (length(b),3*q) matrix: statistical analysis of 'b',
%                   s,t and p for each 'y' in the order
%                      1. the estimated std of the coefficients 'b'
%                      2. the t-values of 'b'
%                      3. the p-values of the t-values.
%          res      the residual:   'y - yfit'.
%          s        the estimated standard error of the model.
%          R2       the coefficient of determination of the fit.
%                   if 'ypred' computed, R2 also gives the 'Q2' values,
%                   the coefficient of determination of the prediction.
%          ypred    predicted y (each y is left out and predicted with a
%                   model based on the remaining data, see also crosreg)
%          e        internally (1.column) and externally (2.column)
%                   studentized residuals.
%          h        the leverages (potentials).
%          D        the influences measured by Cook's distance.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.3 $  $Date: 2004/10/06 08:39:35 $

% 2015-01-20 intcept == 2 means we already added intercept

p = [];

[nx mx]=size(x);
[ny my]=size(y);

if nx ~= ny
    error('regres: the dimensions of x and y do not fit');
end

if nargin == 7
    ido = 1;
elseif nargin == 6
    ido = 1; intcep = 1;
elseif nargin == 5
    intcep = 1; ido = 1; coly = 1:my;
elseif nargin == 4
    intcep = 1; ido = 1; coly = 1:my; colx = 1:mx;
elseif nargin == 3
    intcep = 1; ido = 1; coly = 1:my; colx = 1:mx; w = [];
elseif nargin == 2
    intcep = 1; ido = 1; coly = 1:my; colx = 1:mx; w = [];
    experr = 1;
elseif nargin<2
    error('too few inputs!!');
end
if length(ido)==0, ido = 1; end
if length(intcep)==0, intcep = 1; end
if length(coly)==0, coly = 1:my; end
if length(colx)==0, colx = 1:mx; end
if length(w)<=1, w = []; end
if length(experr)==0, experr = 1; end
[ne me] = size(experr);
[nw,mw] = size(w);

if nx <= length(colx)
   error('regres: too few observations');
end


x=x(:,colx); mx = length(colx);
y=y(:,coly); my = length(coly);

if experr == 0, ido = 0; end  % p-values not computed if 'experr'
                                           % computed by residuals
if length(w)>0
   w = w(:,coly); mw = my;
   if (ny ~= nw)
      error('the dimensions of y and weight matrix do not fit');
   end
end

if (experr ~=0 & experr ~=1 & my~=ne)
    error('regres: the dimensions of experr and y do not fit');
end

if intcep==1
    x=[ones(nx,1) x]; mx = mx+1;
end


if length(w) == 0
      b       = x\y;
      dinvxtx = sqrt(diag(inv(x'*x))) * ones(1,my);
 else
     miss = [];
     for i=1:my
       miss(i) = length(find(w(:,i)==0));    
       wx = diag(sqrt(w(:,i)))*x;
       wy = sqrt(w(:,i)).*y(:,i);
       b(:,i) = wx\wy;
       dinvxtx(:,i) = sqrt(diag(inv(wx'*wx)));
     end
 end

yfit = x*b;

if nargout == 2, return; end

res  = y-yfit;

if length(w)>0
 wres    = sqrt(w).*res;
else 
 wres  = res;
 miss  = zerog(y(1,:));
end

if  me == 1                            % if experr is a scalar or column vector
    if (experr == 0 | experr == 1)     % if experr has values 0 or 1
       if intcep >= 1
          x1 = remove(x,[],1);
       else
          x1 = x;
       end
       if (experr==1)
           exer = pool(x1,y);
       end
       
       if (experr == 0 | exer == 0)        % also case no replicates found
          for i = 1:my,
            if nx-mx-miss(i)<=0
             experr(i) = NaN; % no degrees of freedom
            else
             experr(i) = norm(wres(:,i))/sqrt(nx-mx-miss(i));
            end
             stdb(:,i) = dinvxtx(:,i) * experr(i);
          end
          t    = b./stdb;
       else
          experr = exer;
          for i = 1:my
             stdb(:,i) = dinvxtx(:,i) * experr(i,1);
             if stdb(:,i)==0
               error(['no variance in response variable ',num2str(i)]);
             end
          end
          t    = b./stdb;
          if ido == 1
             for i = 1:my
                p(:,i) = 1 - distt(abs(t(:,i)), experr(i,2),2);
             end
          end
       end
    else                           % "experr" given without ndf
       exer(:,1) = experr * sqrt((nx-1)/(nx-mx));
       [in,im] = size(experr);
       exer(:,2) = (nx-mx) * ones(in,im);
       experr    = exer;
       for i = 1:my
          stdb(:,i) = dinvxtx(:,i) * experr(i,1);
       end
       t    = b./stdb;
       if ido == 1
          for i = 1:my
             p(:,i) = 1 - distt(abs(t(:,i)),experr(i,2),2);
          end
       end
    end
 else
      for i = 1:my
         stdb(:,i) = dinvxtx(:,i) * experr(i,1);
      end
      t    = b./stdb;
      if ido == 1
         for i = 1:my
             p(:,i) = 1 - distt(abs(t(:,i)),experr(i,2),2);
         end
      end
 end

 if ido == 1
   stp = [stdb t p];
 else
   stp = [stdb t];
 end

if nargout > 4        % the estimated standard error and coefficient of
                      % determination are calculated
  R2  = r2(y,yfit,w);
  RSS = sum(wres.^2);
  if nx-mx-miss<=0
    s=NaN;
  else
    s   = sqrt(RSS./(nx-mx-miss));
  end
end

if nargout > 6  % some diagnostic measures are calculated
   ss  = ones(nx,1)*s;
   if length(w) == 0
      w = oneg(y);
   end
   for i =1:my
     wx      = diag(sqrt(w(:,i)))*x;
     h(:,i)  = sum(((wx*inv(wx'*wx)).*wx)')';
     hh = oneg(h(:,i))-h(:,i); hh(hh==0) = NaN;
     r(:,i)  = wres(:,i)./sqrt(hh)./ss(:,i);
     if nx-mx-1-miss(i) <= 0
       si(:,i) = NaN;
     else
       si(:,i) = ss(:,i).*sqrt(((nx-mx-miss(i))*oneg(r(:,i))-r(:,i).^2)...
                               /(nx-mx-1-miss(i)));
     end
     tr(:,i) = wres(:,i)./sqrt(hh)./si(:,i);
     D(:,i)  = (r(:,i).^2).*(h(:,i)./hh)/mx;
     ei(:,i) = wres(:,i)./hh;
     ypred(:,i) = y(:,i)-ei(:,i);
     e       = [r tr];
   end
   R2       = [R2 r2(y,ypred,w)];

end


