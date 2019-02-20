function [opt,status]=optionpairs(varargin)
% parse 'name', value pairs
opt=[];
status = 0;
if mod(nargin,2)
  status=-1;
  return;
end

for i=1:2:(nargin-1)
  if ~ischar(varargin{i})
    status = -2;
    return;
  end
  opt.(varargin{i})=varargin{i+1};
end
