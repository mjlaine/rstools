function [s,df]=pestd(rsres)
%PESTD pure error standard deviation of RSREG result
df=rsres.res.dfpe;
if df>0
  s =sqrt(rsres.res.sspe/df);
else
  s = NaN;
end
