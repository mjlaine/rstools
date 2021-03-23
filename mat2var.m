function [] = mat2var(x,opt)
% mat2var(x) creates individual variables from the
% rows or columns of a matrix into the current workspace.
% The variables will be named x1, x2, ... etc.
% opt = 1 -> use rows
% opt = 2 -> use columns
% Default: opt = 2
% Example:
% x_= reshape(1:12,4,3);
% mat2var(x_)
% whos x_*
if nargin==1
    opt=2;
end
[n,m] = size(x);
xname = inputname(1);
if opt==2
    for i = 1:m
        vari = [xname int2str(i)];
        assignin('caller',vari,x(:,i));
    end
end
if opt==1
    for i = 1:n
        vari = [xname int2str(i)];
        assignin('caller',vari,x(i,:));
    end
end
end
