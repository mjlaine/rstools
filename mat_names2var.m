function [] = mat_names2var(x,colnames,opt)
% mat2var(x) creates individual variables from the
% rows or columns of a matrix into the current workspace.
% The variables will take names from the cell array given
% (the second argument).
% opt = 1 -> use rows
% opt = 2 -> use columns
% Default: opt = 2
% Examples:
% x = reshape(1:12,4,3);
% colnames ={'a','b','c'};
% mat_names2var(x,colnames)
% whos
% rownames ={'r1','r2','r3','r4'};
% mat_names2var(x,rownames,1)
% whos
if nargin==2
    opt = 2;
end
[n,m] = size(x);
xname = inputname(1);
if opt == 1
    for i = 1:n
        assignin('caller',colnames{i},x(i,:));
    end
end
if opt == 2
    for i = 1:m
        assignin('caller',colnames{i},x(:,i));
    end
end
end
