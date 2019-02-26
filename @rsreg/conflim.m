function out=conflim(rsres,conf)
%CONFLIM returns the parameter confidence limits of RSRES object
% OUT = CONFLIM(REG,CONF)
% REG is a RSREG object and CONF is the confidence level, 
%  e.g. 0.95 (the default).
% Returns npar x 2 matrix of the confidence limits.

if nargin < 2
  conf=0.95;
end

b = parameters(rsres);
npar = length(b);
df = get(rsres,'dfres');
s = sqrt(diag(bcov(rsres)));
k = idistt(0.5+conf/2.0,df);

out = [b-k.*s,b+k.*s];
