  function [Q2,Q2y,press,ypred] = crosreg(x,y,ind,part,intcep,perm,print)
% keywords: crossvalidation, regression
% call: [Q2,Q2y,press,ypred] = crosreg(x,y,ind,part,intcep,perm,print)
% Calculates the value of the crossvalidated prediction criterion {\bf Q2,press}
% for linear multiple regression model with selected x-variables given by 'ind'.
% The data is devided in 'part' parts. 'Q2' and 'press'are calculated by
% dropping out each part of the data. The rest of the data is used
% for calibration, the dropped part for prediction.
%
% INPUT :   x,y      data matrixes   [m,ny] = size(y)
%           ind      vector of the column numbers of selected x-variables
%           part     data is devided in 'part' parts
%           intcep   intcep = 1 => model contains intercept,
%                    any other value => model does no contain intercept
%                    OPTIONAL, default: intcep = 1
%           perm     the order of observations used in crossvalidation.
%                    OPTIONAL, default: perm randomized.
%           print    print = 0 => no printing; OPTIONAL, default: print=1
%
% OUTPUT:   Q2       crossvalidatory R2 value (mean value for multiresponse)
%           Q2y      Q2 for each response component
%           press    sum of squares of prediction error
%           ypred    predicted y


[n,m] = size(x);
if nargin == 6, print = 1; 
elseif nargin == 5
    perm = randperm(n); print = 1; 
elseif nargin == 4
    intcep = 1; perm = randperm(n); print = 1;
elseif nargin < 4
    disp('too few inputs')
    break
end

if length(print) == 0, print = 1; end
if length(perm) == 0, perm =randperm(n); end
if length(intcep) == 0, intcep = 1; end

if n < part
   txt = num2str(part);
   disp(['not enough observations to divide in ' txt ' parts']);
   break
end

ypred = zerog(y);

leaveout = floor(n/part);
keep     = n-leaveout;
j        = perm(:);

for i=1:part

   i1=j((i-1)*leaveout+1:min([i*leaveout n]));
   i2=[j(1:(i-1)*leaveout);j(i*leaveout+1:n)];

   [b,yest,stp,e]=regres(x(i2,:  ),y(i2,:),0,[],ind,[],intcep,0);
   if intcep == 1
        ypred(i1,:)=[ones(length(i1),1) x(i1,ind)]*b;
   else
        ypred(i1,:)=x(i1,ind)*b;
   end
   if print == 1
%        keyboard
        disp([i r2(y(i2,:),yest) r2(y(i1,:),ypred(i1,:))])
   end
end

press = n*(std(y-ypred)).^2;
Q2y   = r2(y,ypred);
QQ    = Q2y;
Q2y   = QQ';
Q2    = mean(QQ);



