function designplot(X,y,axlabels,linespec,dec)
% desigplot(X,y,minmax,axlabels)
% visualizes variable designs and shows responses y
% If ponts are replicated,calculate first mean values, 
% e.g. by rowmeans; then also the responses must be averaged. 
% You may add more points using hold on.
% Defaults: axlabels = {'X_1','X_2','X_3'};
%           linespec = 'k-';
%           dec      = 1; % # of decimals in rounding
    [n]    = size(X,1);
    minmax = [min(X);max(X)];
    if nargin==4
       dec      = 1;
    elseif nargin==3
       linespec = 'k-';
       dec      = 1;
    elseif nargin==2
       axlabels = {'X_1','X_2','X_3'};
       linespec = 'k-';
       dec      = 1;
    elseif nargin==1
       axlabels = {'X_1','X_2','X_3'};
       linespec = 'k-';
       dec      = 1;
       y        = (1:n)';
    else
       error('X and y must be supplied')
    end
    n       = size(X,1);
    if isempty(y)
        y = (1:n)';
    end
    [~,ij]    = intera(1:n,[],[],-2);
    ij(:,1:n) = []; % take only pairs
    ind       = []; % indices of the line end points
    for i = 1:size(ij,2)
        dX = diff(X(ij(:,i),:));
        if length(dX(dX~=0)) == 1
            plot3(X(ij(:,i),1),X(ij(:,i),2),X(ij(:,i),3),linespec) 
            hold on
            ind = [ind;ij(:,i)];
        end
    end
    xlabel(axlabels{1})
    ylabel(axlabels{2})
    zlabel(axlabels{3})
    off = diff(minmax)/30;
    ind = unique(ind);
    for i = ind
        text(X(i,1)+off(1),...
             X(i,2)+off(2),...
             X(i,3)+off(3),num2str(round(y(i),dec)));
    end
    ic = find(all(code(X,[min(X);max(X)],1)==0,2)); % center point
    text(X(ic,1)+off(1),...
         X(ic,2)+off(2),...
         X(ic,3)+off(3),num2str(round(y(ic),dec)));
    plot3(X(ic,1),...
         X(ic,2),...
         X(ic,3),'*');
    xticks = linspace(minmax(1,1),minmax(2,1),3);
    yticks = linspace(minmax(1,2),minmax(2,2),3);
    zticks = linspace(minmax(1,3),minmax(2,3),3);
    set(gca,'XTick',xticks,...
            'YTick',yticks,...
            'ZTick',zticks)
    a   = (minmax(1,:)<0).*1.1+(minmax(1,:)>0).*0.9;
    b   = (minmax(2,:)<0).*0.9+(minmax(2,:)>0).*1.1;
    lim = [a;b].*minmax;
    axis(lim(:)')
    grid on
    hold off
%keyboard
end

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