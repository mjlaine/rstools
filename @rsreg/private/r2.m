  function R = r2(ymes,yest,w)
% keywords: coefficient of determination, R-squared, regression
% call: R = r2(ymes,yest,w)
% The function computes the coefficient of determination, R^2
%
% INPUT
%          ymes        the data, the measured values
%          yest        the estimated values
%          w           the weight matrix. OPTIONAL
%                      default: weights not used
%
% OUTPUT
%          R           the coefficient of determination
%

[m,n] = size(ymes); [mm,nn] = size(yest);
if m==1, ymes = ymes(:); n=1; end
if mm==1,yest = yest(:); n=1; end

if nargin < 3, w=oneg(ymes); end;
if length(w) ==0, w=oneg(ymes); end;

resid  = ymes - yest;
residw = sqrt(w).*resid;
meanw  = sum(w.*ymes)./sum(w);
for  j = 1:n,
     RSS  = sum(residw(:,j).^2);
     SYY  = sum((sqrt(w(:,j)).*(ymes(:,j)-meanw(j))).^2);
     if SYY > 0
         R(j) = 100*(1-RSS/SYY);
     else
         R(j) = (RSS==0);
     end
end;

