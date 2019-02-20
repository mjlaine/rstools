function out=gradpath(rsres,x0,step,n)
%GRADPATH gradient path calculation
% GRADPATH(RSRES,X0,STEP,N)
% input:
%   RSRES  regression results
%   X0     starting points in original units, (default is the center)
%   STEP   the relative step size, delta(x) =  step*grad/norm(grad), (0.1)
%   N      number of steps to take, (20)
% output:
%   OUT.X  path in coded units
%   OUT.x  path in original units
%   OUT.y  estimated response along the path

res=rsres.res;

bful = quadcomp(res.b,res.terms,res.nx);

%[path,ypath,sy] = gradpath(res.bful,x0,step,n,fixed,x,s,iprint)

if nargin<2|isempty(x0)
  x0 = mean(res.minmax);
end
if nargin<3|isempty(step)
  step = 0.1;
end
if nargin<4|isempty(n)
  n = 20;
end

%step = diff(steps);
%n = length(steps);

x0 = code(x0,res.minmax,1);

[path,ypath] = gradpath(bful,x0,step,n);

out.X = path;
out.x = code(path,res.minmax,-1);
out.y = ypath;
