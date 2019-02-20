function [a,anames,xnew,newnames]=findalias(x)
% [a,anames,xnew,newnames]=findalias(x)
% expand x and find all aliased columns
% output:
% a         aliased columns
% anames    column names in expaneded x
% xnew      expanded x with aliases removed
% newnames  column names of xnew

[xx,names] = intera3(x);

a=[];
[m,n]=size(xx);

xx=[ones(m,1),xx];
n = n+1;
names=[zeros(size(names,1),1),names];

for i=1:n
  for j=(i+1):n
    if all(xx(:,i)==xx(:,j))
      a=[a;[i,j]];
    end
  end
end
anames=names;

if nargout>2
  xnew = xx(:,setdiff(1:n,a(:,2)'));
  xnew = xx(:,2:end);
end
if nargout>3
  newnames = names(:,setdiff(1:n,a(:,2)'));
  newnames=newnames(:,2:end);
end
