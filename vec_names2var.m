function [] = vec_names2var(x,varnames)
% vec_names2var(x,varnames) creates individual variables from a vector
% into the current workspace.
% The variables will be named with the names given
% in the cell array varnames.
% Example:
% x = 3:-1:1;
% xnames ={'a','b','c'};
% vec_names2var(x,varnames)
% disp([a b c])
n     = length(x);
for i = 1:n
    assignin('caller',varnames{i},x(i));
end
end
