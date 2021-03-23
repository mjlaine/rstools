function R = Rsquared(ymes,yest,w)
    % keywords: coefficient of determination, R-squared, regression
    % call: R = Rsquared(ymes,yest,w)
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

    [m,n] = size(ymes); mm = size(yest,1);
    if m==1, ymes = ymes(:); n=1; end
    if mm==1,yest = yest(:); n=1; end

    if nargin < 3, w=ones(size(ymes)); end
    if isempty(w), w=ones(size(ymes)); end

    resid  = ymes - yest;
    residw = sqrt(w).*resid;
    meanw  = sum(w.*ymes)./sum(w);
    for  j = 1:n
         RSS  = sum(residw(:,j).^2);
         SYY  = sum((sqrt(w(:,j)).*(ymes(:,j)-meanw(j))).^2);
         if SYY > 0
             R(j) = 100*(1-RSS/SYY);
         else
             R(j) = (RSS==0);
         end
    end
end


