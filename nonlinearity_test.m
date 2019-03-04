function [p,t,d] = nonlinearity_test(X,y)
% [p,t,d] = nonlinearity_test(X,y)
% X must be a 2^N or a fractional 2^N design in coded units
% y contain the responses of the design
icenter = all(X==0,2);
icorner = ~icenter;
ncenter = length(y(icenter));
if ncenter==0
    error('no center points in the design')
end
ncorner = length(y(icorner));
d       = mean(y(icorner))-mean(y(icenter));
S       = std(y(icenter));
t       = d/(S*sqrt(1/ncenter+1/ncorner));
p       = 2*(1-distt(abs(t),ncenter-1));
