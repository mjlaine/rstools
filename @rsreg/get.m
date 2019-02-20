function val = get(a, propName)
%GET Get reg properties from the specified object
% and return the value

val = a.res;

if nargin>1
  if isfield(val,propName);
    val = getfield(val,propName);
  else
    error(sprintf('No such property %s',propName));
  end
end
