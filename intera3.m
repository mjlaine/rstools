function [xx,inames]=intera3(x)
%INTERA3  all crossed interactions
% [XX,INAMES]=INTERA3(X)
% Input: 
%    X The original 'x' matrix,
% Output: 
%    XX The expanded 'x' matrix with extra columns for every
%       2  way, 3 way, etc. interactions of the columns of X.
%    INAMES Matrix of interaction 'names'. Each column shows what
%       columns of X have been used to produce the corresponding
%       column in XX. Can be used as option 'terms' in RSREG or REG.

[n,p]=size(x);
pp = p;
for i=2:p
  pp = pp + nchoosek(p,i);
end
xx=zeros(n,pp);
inames=zeros(p,p);
inames(1,1:p)=1:p;
xx(:,1:p) = x;
jj = p+1;
for k=2:p
  inds = nchoosek(1:p,k);
  for i=1:size(inds,1);
    inames(1:k,jj) =inds(i,:)';
    xx(:,jj) = prod(x(:,inds(i,:))')';
    jj =jj+1;
  end
end
