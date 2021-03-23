function cubeplot(X,y,axlabels,axticks,linespec,dec)
% cubeplot(X,y,minmax,axlabels)
% creates a cube plot for a 2^3 design and responses y
% Only corner points are allowed. If they are replicated,
% calculate first mean values, e.g. by rowmeans; then
% also the responses must be averaged. Summarizing,
% X must be 8 by 3 and y 8 by 1.
% You may add more points using hold on.
% Defaults: axlabels = {'X_1','X_2','X_3'};
%           linespec = 'k-';
%           dec      = 1; % # of decimals in rounding

% Make CCD3plot later (use this for the factorial part)
    minmax = [min(X);max(X)];
    if nargin==5
        dec = 1;
    elseif nargin==4
        dec = 1;
        linespec ='k-';
    elseif nargin==3
       linespec ='k-';
       dec = 1;
       axticks = [];
    elseif nargin==2
       linespec ='k-';
       dec = 1;
       axticks = [];
       axlabels = {'X_1','X_2','X_3'};
    else
       error('X and y must be supplied')
    end
    [X,i] = sortkey(X,1:3);
    y     = y(i);
    plot3(X([1 5],1),X([1 5],2),X([1 5],3),linespec,...
         X([5 7],1),X([5 7],2),X([5 7],3),linespec,...
         X([7 3],1),X([7 3],2),X([7 3],3),linespec,...
         X([3 1],1),X([3 1],2),X([3 1],3),linespec,...
         X([1 5]+1,1),X([1 5]+1,2),X([1 5]+1,3),linespec,...
         X([5 7]+1,1),X([5 7]+1,2),X([5 7]+1,3),linespec,...
         X([7 3]+1,1),X([7 3]+1,2),X([7 3]+1,3),linespec,...
         X([3 1]+1,1),X([3 1]+1,2),X([3 1]+1,3),linespec,...     
         X([1 2],1),X([1 2],2),X([1 2],3),linespec,...
         X([3 4],1),X([3 4],2),X([3 4],3),linespec,...
         X([5 6],1),X([5 6],2),X([5 6],3),linespec,...
         X([7 8],1),X([7 8],2),X([7 8],3),linespec,'LineWidth',2)
    xlabel(axlabels{1})
    ylabel(axlabels{2})
    zlabel(axlabels{3})
    off = diff(minmax)/20;
    for i = 1:8
        text(X(i,1)+off(1),...
             X(i,2)+off(2),...
             X(i,3)+off(3),num2str(round(y(i),dec)));
    end
    xticks = linspace(minmax(1,1),minmax(2,1),3);
    yticks = linspace(minmax(1,2),minmax(2,2),3);
    zticks = linspace(minmax(1,3),minmax(2,3),3);
    set(gca,'XTick',xticks,...
            'YTick',yticks,...
            'ZTick',zticks)
    if ~isempty(axticks)
        axticks = [axticks(1,:);{' ',' ',' '};axticks(2,:)];
            set(gca,'XTickLabel',axticks(:,1),...
                    'YTickLabel',axticks(:,2),...
                    'ZTickLabel',axticks(:,3))
    end
    a   = (minmax(1,:)<0).*1.1+(minmax(1,:)>0).*0.9;
    b   = (minmax(2,:)<0).*0.9+(minmax(2,:)>0).*1.1;
    lim = [a;b].*minmax;
    axis(lim(:)')
    grid on
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