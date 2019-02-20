  function x = remove(x,row,col)
% keywords: remove rows, remove columns
% call: y = remove(x,row,col)
% the function removes rows/columns from the matrix 'x'.
%
% INPUT:    x     the original matrix
%           row   a vector giving the indexes of the rows to be removed.
%           col   a vector giving the indexes of the columns to be removed.
%                 OPTIONAL. In case only columns are removed, set 'row = []'.
%
% OUTPUT:   y     the transformed matrix.

 [m,n] = size(x);

 mm     = 1:m;
 if length(row) > 0
    xrow(row) = row; xrow = [xrow,zeros(1,m-length(xrow))];
    indr      = find(mm~=xrow);
    x         = x(indr,:);
 end

 if nargin == 3 
 if length(col) > 0
    nn = 1:n;
    xcol(col) = col; xcol = [xcol,zeros(1,n-length(xcol))];
    indc = find(nn~=xcol);
    x    = x(:,indc);
 end;
 end;


