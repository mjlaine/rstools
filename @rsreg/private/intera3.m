function [xx,inames]=intera3(x)
% all crossed interactions
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
