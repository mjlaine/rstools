function [s,R,yi,e,h,D]=regstat(x,y,intcep,ind)
% keywords: regression analysis
% call: [s,R,yi,e,h,D]=regstat(x,y,intcep,ind)
% The function computes the standars error of the model, coefficients
% of determination, crossvalidatorily predicted y, the internally and
% externally studentized residuals, the leverages  and influences
% (Cook's distances D).
% Useful e.g. for outlier detection (see Weisberg 1985).
% INPUT:   x        the regressor matrix (n x p)
%          y        the dependent variable (n x 1)
%          intcep   the intercept option,
%                   intcep=1: model contains an intercept, else: no intercept
%                   OPTIONAL (default: intcep = 1)
%          ind      the column numbers for selected regressor variables
%                   OPTIONAL (default: ind=1:p)
% OUTPUT:  s        the estimated standard error ("sigma hat")
%          R        coefficient of determination for both fitted and predicted y
%          yi       predicted y (each y is left out and predicted with a model
%                   based on the remaining data, see also crossreg)
%          e        internally (column 1) and externally (column 2) studentized
%                   residuals
%          h        the leverages (potentials)
%          D        the influences measured by Cook's distance

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

[n mx]=size(x);
[n my]=size(y);

if nargin == 3
    ind = 1:mx;
elseif nargin==2
    intcep=1; ind = 1:mx;
elseif nargin<2
    error('too few inputs!!');
end

if intcep ~= 1 
    intcep = 0;
end

x=x(:,ind); mx = length(ind);

if intcep==1
    x=[ones(n,1) x];
end

p    = mx+intcep;
b    = x\y;
yest = x*b;                              %  estimated (fitted) y
e    = y-yest;                           %  residuals
R    = r2(y,yest);                       %  coefficient of determination
RSS  = sum(e.^2);                        %  residual sum of squares
s    = ones(n,1)*(sqrt(RSS/(n-p)));      %  "sigma hat"

%H    = x*inv(x'*x)*x';
%h    = diag(H)*ones(1,my);               %  leverages
h    = sum(((x*inv(x'*x)).*x)')'*ones(1,my);   % this formula needs less memory    

r    = e./sqrt(oneg(h)-h)./s;            %  internally studentized residuals

si   = s.*sqrt(((n-p)*oneg(r)-r.^2)/(n-p-1));

t    = e./sqrt(oneg(h)-h)./si;           %  externally studentized residuals

D    = (r.^2).*(h./(oneg(h)-h))/p;       %  Cook's distances

ei   = e./(oneg(h)-h);                   %   predicted residuals
yi   = y - ei;                           %   predicted y
R    = [R r2(y,yi)];

e    = [r t];
s    = s(1,:);
