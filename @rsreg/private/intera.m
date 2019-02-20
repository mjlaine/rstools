  function [xnew,names] = intera(x,colind1,colind2,nquad);
% keywords: interactions, regression
% function [xnew,names] = intera(x,colind1,colind2,nquad);
% The function forms an expanded interaction matrix 'xnew' by multiplying
% columns of the original 'x' with each other.
% INPUT:
%            x         the original 'x'
%            colind1   vectors giving the indexes of the columns to be
%            colind2   multiplied
%                      BOTH OPTIONAL. Default: all interactions
%            nquad     the quadratic term option
%                      nquad = -2: quadratic terms excluded
%                      any other value : quadratic terms included
%                      OPTIONAL. (default: nquad ~= -2)
%                      Examples:
%                       ...(x):                all variables multiplied
%                       ...(x,[1:3]):          first three variables
%                                              multiplied with all others
%                       ...(x,[1:3],[7:9],-2): only these variables 
%                                              multiplied; quadratic
%                                              terms excluded
% OUTPUT
%            xnew      the expanded matrix
%            names     a matrix whose 1. and 2. row give the pairs of
%                      interaction    

[m,n] = size(x);

if nargin == 1
   colind1 = 1:n;
   colind2 = 1:n;
   nquad   = 1;
elseif nargin == 2
   colind2 = 1:n;
   nquad   = 1;
elseif nargin == 3
   nquad   = 1;
end

if length(colind1) == 0, colind1 = 1:n; end;
if length(colind2) == 0, colind2 = 1:n; end;
if length(nquad) == 0, nquad = 1; end;

if nargin == 1
   A  = (1:n)'*ones(1,n);
   B  = A';
else
   l1=length(colind1); l2=length(colind2);
   ll=min(l1,l2); l=max(l1,l2);
   if ll==l1
      sm = colind1; la = colind2;
   else
      sm =colind2; la = colind1;
   end
   A = la'*ones(1,ll);
   B = (sm'*ones(1,l))';
end


%keyboard
ij = [B(:) A(:)];

if nargin == 1
   ij(find(ij(:,1)>ij(:,2)),:) = [];
else
   nn = l1*l2;
   remrow = [];
   for i =1:nn-1,
       tname = ij(i+1:nn,:);
       row1 = find(tname(:,2)   == ij(i,1));
       row2 = find(tname(row1,1) == ij(i,2));
%       keyboard
       nn1 = length(row1); nn2 = length(row2);
       if (nn1*nn2>0)
          row  = row1(row2)+i*ones(nn1,1);
       elseif (nn1==0)
          row = row1(row2); 
       elseif (nn2==0)
          row = i*ones(nn1,1);
       else
          row = [];
       end
       remrow = [remrow; row];
   end;
   ij = remove(ij,remrow);
   if nquad==-2
      ij(find(ij(:,1)==ij(:,2)),:)=[];
   end
end

xnew = [x x(:,ij(:,1)).*x(:,ij(:,2))];

names = [[1:n;zeros(1,n)] ij'];
