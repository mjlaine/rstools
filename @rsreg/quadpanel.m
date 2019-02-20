function quadpanel(out,varargin)
%QUADPANEL panel of all pairwise QUADPLOTs

res=out.res;

if nargin<2
  options=[];
end

if nargin==2
  options=varargin{1};
end
if nargin>2
  [options,status]=optionpairs(varargin{:});
  if status
    error('Error with input arguments, see help')
  end
end


p=res.nx;

for j=2:p
  for i=1:j-1
    if p==2
      h=gca;
    else
      h=subplot(p-1,p-1,(j-2)*(p-1)+i);
    end
    options.xfree=[i,j];
    quadplot(out,options);
  end   
end
