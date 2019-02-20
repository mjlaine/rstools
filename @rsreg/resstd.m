function [s,df]=resstd(rsres)
%RESSTD residual standard deviation of RSREG result
s=rsres.res.rmse;
df=rsres.res.dfres;
