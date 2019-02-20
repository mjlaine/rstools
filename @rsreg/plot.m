function hdl=plot(rsres)
% PLOT regression results

% for one independent variable plots the data and model
% KESKEN
res=rsres.res;

nx = res.nx;
intcept = res.intcept;

if nx == 1
  h=resplot(rsres);
else
  h=resplot(rsres);
end

if nargout>0
  hdl=h;
end
