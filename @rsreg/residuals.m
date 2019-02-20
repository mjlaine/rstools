function [r,si,se]=residuals(rsres)
%RESIDUALS returns the residuals of rsreg object
r  = rsres.res.res;
si = rsres.res.studres(:,1);
se = rsres.res.studres(:,2);


