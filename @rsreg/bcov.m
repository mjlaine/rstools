function c=bcov(rsres)
%BCOV returns the parameter estimate covariance matrix of RSRES object
xtx=rsres.res.xtx;
df = rsres.res.dfres;
if df > 0
  s2 = rsres.res.ssres/df;
else
  s2=NaN;
end
c = inv(xtx)*s2;
