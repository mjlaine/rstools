function hdl=resplot(rsres)
%RESPLOT plot the residuals of rsreg object

res=rsres.res;

if isfield(res,'class');
  class = res.class;
else
 error('input argument is incorrect for resplot');
end

if ~strcmp(class,'reg')
  error('this funtion works only for rsreg output');
end

h=plot(res.yfit,res.res,'o');
title('residual plot');
xlabel('fitted values');
ylabel('residuals');

if nargout>0
  hdl=h;
end

