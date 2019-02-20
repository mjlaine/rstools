  function [b,stp,yest,e,ind] = regback(x,y,level,tp,ido,experr,intcep)
% keywords: regression analysis
% call: [b,stp,yest,e,ind] = regback(x,y,level,tp,ido,experr,intcep)
% the function drops variables one-by-one from the model using t or p
% values with a given level.
% Remark: for variables not in INPUT/OUTPUT see regres (help regres)
%
% INPUT:  level  the smallest acceptable t-value (tp ~= 1)
%                or  largest  acceptable p-value (tp  = 1)
%                in the model
%         tp     the decision on omitting variables from the
%                model on basis of t-values or p-values
%                tp option, tp ~= 1 t-value
%                           tp  = 1 p-value
%                OPTIONAL, default: t-value ( tp ~=1 )
%                NOTE the use of t-values is slightly faster
%         ido    p-value option, ido=0: no computation
%                                ido=1: computes the p-values
%                OPTIONAL, default: no computation
%                NOTE the function computes the p-values if tp = 1
%
% OUTPUT: ind    the indices of the variables remaining in the model
%

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

if nargin < 7 intcep = 1; end
if nargin == 5
    intcep = 1; experr = 0;
elseif nargin == 4;
    experr = 0; intcep = 1; ido = 0;
elseif nargin == 3;
    tp = 2; ido = 0; experr = 0; intcep = 1;
elseif nargin < 3
    error('too few inputs!');
end

if intcep ~= 1
    intcep = 0;
end

if tp == 1
   ido = 1;
end

[n,m]  = size(x);
[n,my] = size(y);

if my > 1
   disp('REGBACK cannot be used for multiresponse models!')
   error('Use REGBACK separately for each y.')
end

ind = 1:m;

for i = 1:m

    [n,mm] = size(x);
    [b,yest,stp,e] = regres(x,y,experr,[],[],[],intcep,ido);
    if tp ~=1
       t = stp(:,2);
       [tcomp,ii] = min(abs(t(1+intcep:mm+intcep)));
       if tcomp > level
           ind = ind';
           break
       end
    else
        p = stp(:,3);
       [pcomp,ii] = max(p(1+intcep:mm+intcep));
       if pcomp < level
           ind = ind';
           break
       end
    end

    x=remove(x,[],ii);
    ind=remove(ind,[],ii);

end

