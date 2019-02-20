function c=bcor(rsres)
%BCOR returns the parameter estimate correlation matrix of RSRES object
bc = bcov(rsres);
d = sqrt(diag(bc));
c = bc./(d*d');
