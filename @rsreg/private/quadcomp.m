  function bfull = quadcomp(b,inter,nx)
% keywords: canonical analysis, response surface analysis, optimization
% call: bfull = quadcomp(b,inter,nx)
%
% This function completes a regression model with interactions and/or
% quadratic terms to full quadratic model of 'nx' variables. The
% coefficients of the missing terms are set to zero. The order of
% 'bfull' is the same as given by INTERA.
%
% INPUT:      b      the regression coefficients, a vector for *one* model
%             inter  the 'names' for the coefficients as given in INTERA
%                    (NOTE: all terms, including linear, must be named)
%             nx     number of variables in the model
%
% OUTPUT:     bfull  coefficients for a full quadratic model
%
% SEE ALSO: all 'QUAD'-functions

ni = length(inter(1,:));

[xx,intfull] = intera(1:nx);

nb = length(intfull(1,:));

bfull = [b(1);zeros(nb,1)];

for i = 1:ni
     j = find(intfull(1,:) == inter(1,i) & intfull(2,:) == inter(2,i));
     bfull(j+1) = b(i+1);
end

