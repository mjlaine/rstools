 function y = rowmean(x,int,fun)
%function y = rowmean(x,int,fun);
%
%INPUT:    x       the data matrix
%          int     the smoothing integer, i.e. # of consequtive rows
%          fun     handle to the smoothing function (DEFAULT: @mean)
%OUTPUT:   y       a matrix containing smoothed and truncated versions of
%                  the columns of 'x', obtained by replacing the rows
%                  x(i,:) ... x(i+int,:) by their mean.
%For columns use y = rowmean(x',int,fun)'

if nargin < 3, fun = @mean; end
[m,n]  = size(x);
nstep = floor(m/int);
if nstep*int < n
    y = zeros(nstep+1,n);
else
    y = zeros(nstep,n);
end
for i = 1:nstep
    y(i,:)= fun(x((i-1)*int+1:i*int,:));
end
if i*int < n
        y(i+1,:)= fun(x(i*int+1:end,:));
end

    

   
