function h=normalplot(rsres)
%NORMALPLOT normal probability plot for residuals

res=rsres.res;
%x = res.res;
x = res.studres(:,1);
m  = length(x);
nq = zeros(m,1);
%nq = norqf(((1:m)'-.5)/m);
nq = idistn(((1:m)'-.5)/m);
eq = sort(x);

%yp = plims(x, [0.25, 0.75]);
%xp = norqf([0.25, 0.75]);
%k  = diff(yp)/diff(xp);
%int = yp(1)-k*xp(1);
  
%xx = nq([1,m]); yy=int+k*xx;
%hdl=plot(nq,eq,'o',[xx(1) xx(2)],[yy(1) yy(2)],'-r');
hdl=plot(nq,eq,'o');
xlabel('Theoretical Quantiles');
%ylabel('Empirical Quantiles');
ylabel('Standardized residuals');
title('Normal probability plot for residuals');

if nargout>0
  h=hdl;
end
