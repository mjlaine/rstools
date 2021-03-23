function [y,perm] = sortkey(x,key,opt)
%function [y,perm] = sortkey(x,key,opt)
%
%This function sorts 'x' hierarcically according to columns of 'x' 
%given in 'key'.
%
%INPUT:       x          the matrix to be sorted
%             key        a vector containing column numbers of key columns
%                        OPTIONAL (DEFAULT: key = 1:length(x(1,:)))
%             opt        opt = 0 => ascending order (DEFAULT)
%                        opt = 1 => descending order 
    if nargin == 2
        opt = 0;
    elseif nargin == 1
        opt = 0; key = 1:length(x(1,:));
    elseif nargin < 1
        disp('too few inputs')
        return
    end
    if length(key) == 0, key = 1:length(x(1,:)); end
    [n m] = size(x);
    x      = [x (1:n)']; 
    if opt == 1, x = -x; end
    nkey = length(key);
    [a j] = sort(x(:,key(1)));
    x     = x(j,:);
    ig0 = zeros(n+1,1);
    i = 1;
    while i < nkey
        x1    = [0;x(:,key(i))];
        x2    = [x(:,key(i));x(n,key(i))];
        fg    = abs(x1-x2);   % fg <--> first of group
        if i > 1, ig0(ig) = ig; end
        ig      = find(fg>0);
        ig      = [ig;n+1];
        ig0(ig) = ig;
        jg      = find(ig0>0);
        ig      = ig0(jg);
        ng      = length(ig)-1;
        if ng < n
            for k=1:ng
                kg = ig(k):ig(k+1)-1; 
                if length(kg)>1
                   [a,j]   = sort(x(kg,key(i+1)));
                   x(kg,:) = x(kg(j),:);
               end
            end
            i = i+1;
         else
            i = nkey+1;
         end
    end
    if opt == 1, x = -x; end
    y    = x(:,1:m);
    perm = x(:,m+1);
 end