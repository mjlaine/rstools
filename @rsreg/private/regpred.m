  function [ypred, sy] = regpred(xpred,b,intcep,ind,x,s)
% keywords: regression analysis, prediction
% call: [ypred, sy] = regpred(xpred,b,intcep,ind,x,s)
% The function calculates predictions for given regressor values
% 'xpred(:,ind)'. If standard deviations for the predictions are wanted,
% the regressor values 'x' that were used to estimate b and the standard
% error of 'y' (s) must be given.
%
% INPUT:      xpred              regressor values
%             b                  regression coefficients
%             intcep             1:  intercept IS in the model (DEFAULT)
%                                any other value:intercept is NOT in the model
%             ind                column numbers of selected variables
%                                length(ind) must equal length(b)
%                                OPTIONAL. Default: all selected
%             x                  original data (the "calibration" set)
%             s                  the estimated standard error of y
%                                'x' and 's' are OPTIONAL, but if either is
%                                supplied then both must be supplied
% OUTPUT:     ypred              predicted 'y' values
%             sy                 standard deviations of 'y'

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

[n mx]=size(xpred);

if nargin == 3
    ind = 1:mx;
elseif nargin == 2
    intcep=1; ind = 1:mx;
elseif nargin < 2
    error('too few inputs!!');
end

if length(intcep)==0, intcep = 1; end
if length(ind)==0, ind = 1:mx; end

xpred = xpred(:,ind);

if intcep == 1
    xpred = [ones(n,1) xpred];
end

ypred = xpred*b;

if nargin == 6
    x = x(:,ind);
    if intcep == 1
        x = [oneg(x(:,1)) x];
    end
    sy    = oneg(xpred(:,1))*s;
    sy    = sy.*(sqrt(sum(((xpred*inv(x'*x)).*xpred)')')*ones(1,length(s)));
elseif nargin == 5
    disp('s must be supplied')
end

