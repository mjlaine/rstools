  function [ivar,ivarremo,R] = crosback(x,y,maxvar,ivar,ivarremo,print,opt)
% keywords: variable selection, regression, crossvalidation
% call: [ivar,ivarremo,R] = crosback(x,y,maxvar,ivar,ivarremo,print,opt)
% The function test regression models between 'x' and 'y' using
% a backward stepwise regression based on the 'leave one out'
% crossvalidation criteria for prediction.
%
% INPUT:   x         the regressor matrix   (n x p)
%          y         the dependent variable (n x 1)
%          maxvar    the max n of variables tested for dropping, maxvar <= p
%          ivar      see below. Useful as input to continue an earlier
%          ivarremo  run. OPTIONAL.
%          print     print R2/Q2 results during the test. OPTIONAL
%                    print=0  no printing;
%                    print=1  selected variables printed /DEFAULT
%                    print=2  all candidate variables printed.
%          opt       DEFAULT opt=2 <=> crosvalidatory R^2
%                            opt=1 <=> ordinary R^2
% OUTPUT:  ivar      the variables left in the model
%          ivarremo  the ordered 'maxvar' variables removed, starting with
%                    the least predictive one.
%          R         the crossvalidatory coefficients of determination
%                    for the models given by the variables tested
%                    in 'ivarremo'

R           = zeros(maxvar,1);

if nargin < 7, opt = 2; end;

if nargin <= 3
    [nobs,nvar] = size(x);
    ivar        = (1:nvar)';
    ivarremo    = [];
    print       = 1;
    opt         = 2;
elseif nargin == 5
    nvar        = length(ivar);
    ivar        = ivar(:);
    ivarremo    = ivarremo(:);
    print       = 1;
    opt         = 2;
elseif nargin < 6
    print       = 1;
    opt         = 2;
end

if length(ivar)==0 & length(ivarremo) == 0
    [nobs,nvar] = size(x);
    ivar        = [1:nvar]';
    ivarremo    = [];
end
if length(print) == 0, print= 1; end
if ~(opt==1 | opt ==2 )
   disp('opt must be 1 or 2 for crosback!');
   break
end

for i = 1:maxvar

    RR =zeros(nvar,1);

    if print==2, disp('n of var tested   crossv R^2'), end

    for j =1:nvar
        [s,RRR,yi,e,h,D]= regstat(remove(x,[],j),y,1);
        RR(j)           = RRR(opt);
        if print==2, disp([ivar(j) RR(j)]), end
    end    

    [Rmax,imax] = max(RR);

    if (print ==1 | print == 2)
      disp('n of test   var dropped   R^2')
      disp([i ivar(imax) Rmax])
    end
    x = remove(x,[],imax);

    nvar          = nvar-1;
    ivarremo      = [ivarremo;ivar(imax)];
    R(i)          = Rmax;
    ivar          = remove(ivar,imax,[]);    

end
