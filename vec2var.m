function [] = vec2var(x)
% vec2var(x) creates individual variables from a vector
% into the current workspace.
% The variables will be named x1, x2, ... etc.2var
% Example:
% x_= 3:-1:1;
% vec2var(x_)
% whos x_*
n     = length(x);
xname = inputname(1);
for i = 1:n
    vari = [xname int2str(i)];
    assignin('caller',vari,x(i));
end
end
