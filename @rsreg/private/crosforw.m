  function [ivar,ivarleft,R,RR]=crosforw(x,y,maxvar,ivar,ivarleft,print,opt)
% keywords: variable selection, regression, crossvalidation
% call: [ivar,ivarleft,R,RR]=crosforw(x,y,maxvar,ivar,ivarleft,print,opt)
% The function tests regression models between 'x' and 'y' using
% a forward stepwise regression based on the 'leave one out'
% crossvalidation criteria for prediction.
%
% INPUT:   x         the regressor matrix   (n x p)
%          y         the dependent variable (n x 1)
%          maxvar    the max n of variables tested,  maxvar <= p
%          ivar      see below. Useful as input to continue an
%          ivarleft  earlier run. OPTIONAL.
%          print     print R2/Q2 results during the test. OPTIONAL
%                    print=0  no printing;
%                    print=1  selected variables printed /DEFAULT
%                    print=2  all candidate variables printed.
%          opt       DEFAULT opt=2 <=> crosvalidatory R^2
%                            opt=1 <=> ordinary R^2
% OUTPUT:  ivar      the ordered 'maxvar' variables accepted, starting
%                    with the most predictive one.
%          ivarleft  the variables not selected (when maxvar < p)
%          R         the crossvalidatory coefficients of determination
%                    for the models given by the variables in 'ivar'
%          RR        r2 values for variables in the last (maxvar) step

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2004/10/06 08:37:48 $

R           = zeros(maxvar,1);

if nargin < 7, opt = 2; end

if nargin <= 3 
    [nobs,nvar] = size(x);
    ivar        = [];
    ivarleft    = [1:nvar]';
    opt         = 2;
    print       = 1;
elseif nargin <=5
    nvar     = length(ivarleft);
    ivar     = ivar(:);
    ivarleft = ivarleft(:);
    opt      = 2;
    print    = 1;
elseif length(ivar)==0 & length(ivarleft) == 0
    [nobs,nvar] = size(x);
    ivar        = [];
    ivarleft    = [1:nvar]';
else
    nvar     = length(ivarleft);
    ivar     = ivar(:);
    ivarleft = ivarleft(:);
end

if (length(print)==0) print = 1; end
if ~(opt==1 | opt ==2 )
   error('opt must be 1 or 2 for crosforw !');
end

for i = 1:maxvar

    RR =zeros(nvar,1);

    if print==2, disp('n of var tested   crossv R^2'), end
    for j = 1:nvar

        if rank(x(:,[ivar;ivarleft(j)])) >= length([ivar;ivarleft(j)])
            [s,RRR,yi,e,h,D]= regstat(x(:,[ivar;ivarleft(j)]),y,1);
        else
            RRR = [min(RR) min(RR)]
        end
        RR(j)           = RRR(opt);
        if print == 2, disp([ivarleft(j) RR(j)]), end

    end    

    [Rmax,imax] = max(RR);

    if (print ==1 | print == 2)
      disp('n of test   var chosen   R^2')
      disp([i ivarleft(imax) Rmax])
    end

    nvar          = nvar - 1;
    R(i)          = Rmax;
    ivar          = [ivar;ivarleft(imax)];
    ivarleft      = remove(ivarleft,imax);    

end

