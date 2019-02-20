  function c = minusset(a,b)
% keywords: set operation
% call: c = minusset(a,b)
% The function removes the values given in the set 'b'
% from those given in the set 'a'.
%
% INPUT:        a      the original set
%               b      the values to be removed
%
% OUTPUT        c      the set of the remaining values

a = a(:);
b = b(:);
for k = 1:length(b);

    if length(a)==0,break;end
    kk = find(a == b(k));
    a(kk) = [];

end

c = a;
