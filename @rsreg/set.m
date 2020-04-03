function y = set(a, propName, val)
%SET Set reg properties for the specified object
% and return a modified reg object
% use with care!!!

y = a;
res = a.res;

if nargin>1
  if isfield(res,propName);
    res = setfield(res,propName,val);
  else
    error(sprintf('No such property %s',propName));
  end
end

y.res = res;
