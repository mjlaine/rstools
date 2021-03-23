function [] = struct2var(x)
% struct2var(x) creates individual variables from a structtor
% into the current workspace.
% The variables will be named x1, x2, ... etc.2var
% Example:
% par.T = 273;
% par.p = 3;
% struct2var(par)
% whos T p
% disp([T p])
xnames = fieldnames(x);
n      = length(xnames);
for i = 1:n
    xval  = getfield(x,xnames{i});
    assignin('caller',xnames{i},xval);
end
end
