function h=efectplot(rsres)
%EFECTPLOT plot the efects of the model on normal probability scale
b=rsres.res.b(2:end);

x = b;
m  = length(x);
nq = zeros(m,1);
%nq = norqf(((1:m)'-.5)/m);
nq = idistn(((1:m)'-.5)/m);
[eq,si] = sort(x);


%yp = plims(x, [0.25, 0.75]);
%xp = norqf([0.25, 0.75]);
%k  = diff(yp)/diff(xp);
%int = yp(1)-k*xp(1);
%xx = nq([1,m]); yy=int+k*xx;
%hdl=plot(nq,eq,'o',[xx(1) xx(2)],[yy(1) yy(2)],'-r');

yp = interp1(sort(x),(length(x)-1)*[0.25,0.75]+1);
xp = idistn([0.25, 0.75]);
k  = diff(yp)/diff(xp);
int = yp(1)-k*xp(1);
xx = nq([1,m]); yy=int+k*xx;

hdl=plot(nq,eq,'o',[xx(1) xx(2)],[yy(1) yy(2)],'-r');
%hdl=plot(nq,eq,'o');
ylabel('Parameter estimates');
%ylabel('Empirical Quantiles');
%ylabel('Standardized residuals');
title('Normal probability plot for model efects');

if nargout>0
  h=hdl;
end

names = rsres.res.names(2:end);
%names = num2str(rsres.res.terms');
text(nq+0.05,eq,names(si),...
       'HorizontalAlignment','left');
