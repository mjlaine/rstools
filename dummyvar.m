 function y = dummyvar(x,coding)
%function y = dummyvar(x,coding)
%
%INPUT		x 	    levels of a qulaititative (categorical) variable
%                   x may be a matrix of several factors
%OUTPUT		y	    corresponding dummy variables
%           coding  type of coding (default: 3)
%                   1 <-> sum coding
%                   2 <-> reference coding (code==nlev is the reference)
%                   3 <-> no intercept coding
% 
%The levels of the variables must be coded as 1:n_of_levels

if nargin==1
   coding = 3;
end
[~,m] = size(x);
for j = 1:m
    if coding == 3
        nlev = length(unique(x(:,j)));
        for k=1:nlev
            y{j}(:,k) = 1.*(x(:,j)==k);
        end
    elseif coding == 2
        nlev = length(unique(x(:,j)));
        for k=1:nlev-1
            y{j}(:,k) = 1.*(x(:,j)==k);
        end
    elseif coding == 1
        nlev = length(unique(x(:,j)));
        for k=1:nlev-1
            y{j}(:,k) =  1.*(x(:,j)==k);
        end
        ii = find(sum(y{j}.^2,2)==0);
        y{j}(ii,:) = -1*ones(length(ii),nlev-1);
    else
        error('coding must be 1, 2 or 3!')
    end
end
y = cell2mat(y);
