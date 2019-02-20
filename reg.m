function out=reg(x,y,varargin)
%REG  linear regression analysis
% REG(X,Y) fits the columns of X against Y using linear regression model
% REG(X,Y,OPTIONS) as in RSREG

if nargin<2
  error('reg needs two input arguments')
end

if nargin<3
  options = struct([]);
end

if nargin==3
  options=varargin{1};
end
if nargin>3
  [options,status]=optionpairs(varargin{:});
end

if ~isfield(options,'intera')
  options(1).intera=0;
end
if ~isfield(options,'code')
  options(1).code=0;
end

if ~isfield(options,'output')
  options(1).output=0;
end

out=rsreg(x,y,options);
