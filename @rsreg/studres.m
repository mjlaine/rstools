function [si,se]=studres(rsres)
%STUDRES returns the standardized residuals of rsreg object

si = rsres.res.studres(:,1);
se = rsres.res.studres(:,2);
