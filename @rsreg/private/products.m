  function [y,names] = products(x,indmat,app)
% keywords: interactions
% call: [y,names] = products(x,indmat,app)
%
% The function forms a matrix 'y' by multiplying/dividing the columns of
% the original 'x' with each other as given by the 'indmat'.
% INPUT:      x         the original 'x'
%             indmat    the index matrix. The indexes 'ind' in each column
%                       of 'indmat' specify a product column in 'y':
%
%                           positive 'ind' => multiply by x(:,ind)
%                           negative 'ind' => divide   by x(:,ind)
%
%                       Rem: fill in dummy variables with zeros.
%                            no indmat,app:   same as intera(x,[],[],-2)
%                            indmat = []:     nothing done
%                       Example:   indmat= [1 1  1
%                                           1 2 -3
%                                           2 0  0]
%                       gives
%                       [x(:,1).*x(:,1).*x(:,2) x(:,1).*x(:,2) x(:,1)./x(:;3)]
%             app       the appending option
%                       app = 1: append matrix y to x
%                       any other value: no appending OPTIONAL.
%                       default: app = 1
% OUTPUT      y         the product matrix
%             names     a matrix whose columns give the interaction
%                       groups (indmat possibly appended to original x-variables)
%                       to be used with app=1, see INPUT

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2004/10/07 14:59:53 $

if nargin ==1
   [y,names] = intera(x,[],[],-2);
   return
end

if nargin == 2,
    app = 1;
end

if length(indmat)==0; y=x; return; end

[ni,mi] = size(indmat);

if ni==1; indmat = [indmat;zeros(1,mi)]; end
if indmat(2:ni,:) == zeros(ni-1,mi), app = 0; end

[nx,mx]= size(x);

i      = find(x == 0); x(i) = oneg(i)*eps;
n      = ones(length(x(:,1)),1);
xn     = [n x];

for i = 1:length(indmat(1,:))

   k      = indmat(:,i)';
   s      = sign(k);
   k      = abs(k); k = k+1;
   j      = find(s == 0); s(j) = oneg(j);
   s      = s(n,:);
   y(:,i) = real(exp(sum((s.*log(xn(:,k)))')))';

end


if app == 1
   y     = [x y];
   names = [1:mx; zeros(length(indmat(:,1))-1,mx)];
   names = [names indmat];
else
   names = indmat;
end

