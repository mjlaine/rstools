function mm=minmax(rsres)
%MINMAX returns the coding (min/max-values) used in RSREG
mm=rsres.res.minmax;

%m = mean(mm);
%s = diff(mm)./2;
