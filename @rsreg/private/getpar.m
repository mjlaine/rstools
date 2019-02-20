function y=getpar(options,par,default)
% get parameter from options struct
if isempty(options)
  y = default;
elseif isfield(options,par)
  y = getfield(options,par);
else
  y = default;
end
% convert yes/no to a number
if ischar(y)
  if strcmp(lower(y),'yes'), y=1; end
  if strcmp(lower(y),'no' ), y=0; end  
end
