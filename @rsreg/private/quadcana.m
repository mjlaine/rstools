  function [b0,b,B,T,Xs,ys] = quadcana(bcoef)
% keywords: canonical analysis, response surface analysis, optimization
% call: [b0,b,B,T,Xs,ys] = quadcana(bcoef)
%
% function calculates the A canonical form of a quadratic function
%
% INPUT:         bcoef  coefficients of the quadratic function (see QUADMAT)
%
% OUTPUT         b0     the intercept
%                b      1. order coefficients of canonical variables
%                B      2. order coefficients of canonical variables
%                T      the tranformation Xcanonical = Xoriginal*T
%                       or Xoriginal = Xcanonical*T'
%                Xs     the stationary point in original variables
%                ys     estimated response at the stationary point

[b0,b,B] = quadmat(bcoef);

[T,D]    = eig(B);

b   = T'*b;
B   = diag(D);

Xs  = -b./(2*B); Xs = Xs';
Xs  = Xs*T';
ys  = b0 + sum(-(b.^2)./(4*B));
