  function [R2,Ra2,lof,f0,plof,p0] = lackofit(y,yest,nterm,pvar,ndf,ido)
% keywords: lack-of-fit, regression
% call: [R2,Ra2,lof,f0,plof,p0] = lackofit(y,yest,nterm,pvar,ndfp,ido)
% The function computes tests for lack of fit of a model.
% INPUT     y      the data (in columns of 'y').
%           yest   the responses given by the model (in the columns of 'yest')
%           nterm  n. of terms in the model  (including intercept).     OPTIONAL
%           pvar   the estimated var of the pure error in observations. OPTIONAL
%           ndfp   n. of degrees of freedom in estimation of 'pvar'.    OPTIONAL
%                  (nobs-ngroups,see pool.m). Only for F-test, with ido = 1
%           ido    options for computing 'lof', see below. Default ido =0
% OUTPUT    r2     r2  = 1 - SSE/SST, the coefficient of determination
%           ra2    ra2 = 1 - (SSE/nobs-nterm)/(SST/nobs-1). The adjusted r2.
%                  Preferable when nobs - nterm  is small.              OPTIONAL
%           lof    the lack of fit, options:                            OPTIONAL
%                  ido = 0:   chi-ratio for testing normality of the residual
%                             compare with distribution chi_{nobs-nterm}
%                  ido = 1:   F-ratio for testing 'pvar' and the residual,
%                             compare with distribution F_{nobs-nterm-ndf, ndf}
%           f0      F-ratio for the hypotesis H_o: 'all coefficients (excluding
%                   b0) are zero'. Compare with  F_{nterm-1,nobs-nterm} OPTIONAL
%           plof    p-value for 'lof'. (Prob.for x > lof in chi/F-dist.)OPTIONAL
%           p0      p-value for 'f0'.  (Prob.for x > f0   in F-dist.)   OPTIONAL
% In a multiresponse case 'pvar' and outputs are vectors. For R2 only 'y' and
% 'yest' are needed, if 'pvar' not given only R2, Ra2 computed.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2003/12/02 08:37:12 $

R2 =[]; Ra2=[]; lof=[]; f0=[]; plof=[]; p0=[];
 [nobs,nn] = size(y);
 if (nargin < 6 | nargin < 5) ido = 0; end
% pvar  = pvar(:)';
 res   = y - yest;
 ymean = mean(y);
 ycol  = ones(nobs,1)*ymean;

 for i = 1:nn
     SSE(i) = norm(res(:,i))^2;
     SST(i) = norm(y(:,i)-ycol(:,i))^2;
 end

 SSR   = SST - SSE;

 R2    = 1 - SSE./SST;

 if nargin > 2

   Ra2 = 1 - (SSE ./(nobs-nterm)) ./ (SST/(nobs-1));

   if nargin > 3
      pvar = pvar(:)';
      f0   = (SSR ./(nterm-1)) ./ (SSE ./(nobs -nterm));
      if ido == 0
         lof =  SSE ./ pvar;
      else
         SSlof = SSE - ndf*pvar;
         MSlof = SSlof./(nobs-nterm-ndf);
         lof   = MSlof./pvar;
      end

      if nargout > 4
         for i = 1:nn
            if ido == 0
               plof(i) = 1 - distchi(lof(i),nobs - nterm(i));
            else
               plof(i) = 1 - distf(lof(i),nobs-nterm(i)-ndf,ndf);
            end
            p0(i) = 1 - distf(f0(i),nterm(i)-1,nobs-nterm(i));
         end
      end
     end
 end
