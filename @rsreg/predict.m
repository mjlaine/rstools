function [y,ystd,yostd]=predict(rsres,x)
%PREDICT predict new observations
% usage: YNEW = PREDICT(RESULT,XNEW), where RESULT is output from
% REG or RSREG run and XNEW is a matrix with same number of columns
% as in RSREG call.

% KORJAA
[n,p]=size(x);

res     = rsres.res;
int     = res.intera;
intcept = res.intcept;
b       = res.b;

if rsres.res.code == 1 %Muutos 15.3.21/VMT
    x = code(x,rsres.res.minmax,1);
end
%if int == 1 %Muutos kommenteiksi 15.3.21/VMT
%  x = intera(x,[],[],-2);
%elseif int==2
%  x = intera(x);
%elseif int==3
%  x = intera3(x);
%end

x = products(x,rsres.res.terms,0); %Muutos 15.3.21/VMT

if intcept >= 1
  x = [ones(n,1),x];
end

y = x*b;

%if not(isempty(res.w)) %Muutos kommentiksi 15.3.21/VMT
%Tarkista, miten ystd pitäisi laskea painotetussa tapauksessa
%  x = diag(sqrt(res.w))*x; 
%end

if nargout>1
  % prediction error for the mean
  %ystd = sqrt(diag(x*inv(res.xtx)*x')).*res.rmse;
  ystd = sqrt(diag(x*(res.xtx\x'))).*res.rmse; %Muutos 14.3.21/VMT
end

if nargout>2
  % prediction error for a new observation
  yostd = sqrt(ystd.^2 + res.rmse.^2);
end
