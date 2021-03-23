  function [x,y,ierr] = simflex(f,x0,tol,bounds,ibound,a,iprint)
% Nelder-Mead simplex optimization with simple bounds
% call: [x,y,ierr] = simflex(f,x0,tol,bounds,ibound,a,iprint)
% The function computes the minimum of the (nonlinear) function f
% INPUT:  f             Function handle for the objective function
%                       f is the objective function of the form f(x).
%                       Extra parameters must be given using 
%                       anonymous functions.
%         x0            initial guess for the arguments of f
%         tol(1)        a variance tolerance for the values of f
%         tol(2)        a relative var. tolerance for the values of f
%         tol(3)        maximum number of iterations
%         bounds        bounds(1,:) <--> lower bounds for x
%                       bounds(2,:) <--> upper bounds for x
%         ibound        types of the bounds (-1 lower, +1 upper,
%                       2 both, 0 none)
%         a             the relative size of the simplex
%         iprint        printing option. monitore progress at each iprint'th
%                       iteration (iprint = 0:  no print, )
% OUTPUT: x             the solution of min w.r.t. x f(x)
%         y             the final value of f
%         ierr          termination codes
%         bounds        Bounds for 'constrai', in the form [lower;upper].
x0 = x0(:);
m  = length(x0);
if nargin == 6, iprint=1; end
if nargin == 5, iprint=1; a=0.1; end
if nargin == 4, iprint=1; a=0.1; ibound=2*ones(m,1); end
if nargin == 3, iprint=1; a=0.1; ibound=zeros(m,1);
 bounds=zeros(2,m); end
if nargin == 2, iprint=1; a=0.1; ibound=zeros(m,1);
 bounds=zeros(2,m); tol=[.0001 .0001 100]; end

if isempty(tol), tol = [.0001 .0001 100]; end
if isempty(bounds), bounds = zeros(2,m) ; end
if isempty(ibound), ibound=zeros(m,1); end
if isempty(a), a = 0.1; end
if isempty(iprint), iprint = 1; end

evalstr = '@f(x0)';
itmax   = tol(3);
tol     = tol(1:2);

%     the initial values are transformed to unbounded ones
%      keyboard
x0 = x0(:);
x0 = constrai(x0,ibound,bounds,-1);
%disp('line 61')
%keyboard
reflection=1.0; expansion=2.0; contraction=0.5;               

%     maaritetaan aloitussimplex                                                

s = zeros(m+1,m+1);

%     a = ?
s(1:m,1) = x0;

p  = zeros(m,1);
p1 = zeros(m,1);
%      keyboard

if length(a) == 1

  k     = find(abs(x0)>0);
  if length(k) > 0
      p1(k) = x0(k)*a*(sqrt(m+1)+m-1)/(m*sqrt(2));
      p(k)  = x0(k)*a*(sqrt(m+1)-1)/(m*sqrt(2));
  end
  k     = find(abs(x0)==0);
  if length(k) > 0
      p1(k) = ones(length(k),1)*a*(sqrt(m+1)+m-1)/(m*sqrt(2));
      p(k)  = ones(length(k),1)*a*(sqrt(m+1)-1)/(m*sqrt(2));
  end

%          keyboard
  s(1:m,2:m+1) = diag(p1)+p*ones(1,m)-diag(p) + x0*ones(1,m);

else

  p1=a*(sqrt(m+1)+m-1)/(m*sqrt(2));
  p =a*(sqrt(m+1)-1)/(m*sqrt(2));

  s(1:m,2:m+1) = diag(p1)+p*ones(1,m)-diag(p) + x0*ones(1,m);

end

if itmax == 0
  x0 = constrai(x0,ibound,bounds,1);
  y  = f(x0);
  x  = x0; ierr = 'itmax = 0';
  return
end

%     sijoitetaan funktion f arvot simpleksin s sarmissa
%     s:n riville m+1                                                           

for i=1:m+1
  x0       = constrai(s(1:m,i),ibound,bounds,1);
  s(m+1,i) = f(x0);
end

%  järjestetaan s:n sarakkeet rivin m+1 mukaan kasvavaan järjestykseen

iterations=0;

while iterations < itmax

  iterations=iterations+1;    % iterate                      

  [~,ind] = sort(s(m+1,:));
  s       = s(:,ind);
  ymean   = mean(s(m+1,:));
  ystd    = std(s(m+1,:));
  xmean   = mean(s(1:m,:)');
  xstd    = std(s(1:m,:)');
  test1   = mean(abs(xstd./xmean));
  test2   = abs(ystd/ymean);

  %     konvergenssitestit
 if iprint~=0
  if rem(iterations,iprint) == 0
      disp(iterations)
      disp([s(m+1,m+1), s(m+1,1), test1, test2])
      x0 = constrai(s(1:m,[1 m+1]),ibound,bounds,1);
      if iprint < 0, disp(x0'); end
  end
 end

 if test1 < tol(1) | test2 < tol(2)
      ierr = 0;
      if test2 > tol(2)
           ierr = 1;
      elseif test1 > tol(1)
           ierr = 2;
      end
      x0 = constrai(s(1:m,1),ibound,bounds,1);
      y  = f(x0);
      x  = x0;
      return

  end

%     lasketaan keskipiste ilman huonointa (so. m+1:nnetta)

  xcentre = mean(s(1:m,1:m)')';

%     peilaus; huom! huonoin <-> s(.,m+1) ja paras <-> s(.,1)                   

  xreflection = (1+reflection)*xcentre-reflection*s(1:m,m+1);
  x0          = constrai(xreflection,ibound,bounds,1);
  yreflection = f(x0); 

  if yreflection <= s(m+1,1)          % peilaus paras

%     jatko (=expansion)                                                        

      xexpansion = (1+expansion)*xcentre - expansion*s(1:m,m+1);
      x0         = constrai(xexpansion,ibound,bounds,1);
      yexpansion = f(x0); 
      if yexpansion <= yreflection    % jatko paras
          s(1:m,m+1) = xexpansion;
          s(m+1,m+1) = yexpansion;
      else   % peilaus parempi kuin jatko 
          s(1:m,m+1) = xreflection;
          s(m+1,m+1) = yreflection;
      end
  elseif yreflection >= s(m+1,m)        % peilaus vah. 2. huonoin

%     valitaan parempi kahdesta huonoimmasta                                    

      if yreflection < s(m+1,m+1)       % peilaus 2. huonoin
          s(1:m,m+1) = xreflection;
          s(m+1,m+1) = yreflection;
      end

%         kutistus (=contraction)                                               

      xcontraction = contraction*s(1:m,m+1) + (1-contraction)*xcentre;
      x0           = constrai(xcontraction,ibound,bounds,1);
      ycontraction = f(x0);

      if ycontraction > s(m+1,m+1)       % kutistus huonoin 

%         tayskutistus (= total contraction)

          disp('total contraction')
          s(1:m,2:m+1) = .5d0*(s(1:m,ones(1,m))-s(1:m,2:m+1)) + ...
                         xcentre(:,ones(1,m));
          x0           = constrai(s(1:m,:),ibound,bounds,1);

          % kutistetun simpleksin y:t:

          for i=1:m+1
              x0       = constrai(s(1:m,i),ibound,bounds,1);
              s(m+1,i) = f(x0);
          end
      else          %  kutistus parempi kuin huonoin 
          s(1:m,m+1) = xcontraction;
          s(m+1,m+1) = ycontraction;
      end
  else      %  peilaus parhaan ja 2. huonoimman valissa
      s(1:m,m+1) = xreflection;
      s(m+1,m+1) = yreflection;
  end
end         %     goto iterate

if iterations < itmax
  return
else
  ierr = 3;
  x0   = constrai(s(1:m,1),ibound,bounds,1);
  y    = f(x0);
  x    = x0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xtransf = constrai(x,ibound,bounds,inv)
% keywords: simplex, constrained optimization, Nelder-Mead algorithm
% call: xtransf = constrai(x,ibound,bounds,inv)
% If inv equals to 1 this routine transforms the free variables
% to bounded ones according to ibound & bounds.  If inv equals to -1
% an inverse transformation is done. This is needed for calculation
% of the initial values of the free variables - the user gives
% initial values in units that have physical meaning i.e. initial
% values for the bounded variables.
%
% INPUT:
%      n                              n of parameters and
%      x(1:n)                         parameters to be optimized
%      ibound(1:n)
%      bounds(1:2,1:n)                parameters to be optimized
%      inv                            see text above
ibound   = ibound(:);
[~,colx] = size(x);

if inv == 1

  ilb     = find(ibound == -1);
  iub     = find(ibound ==  1);

  bb      = zeros(length(ibound),1);
  bb(ilb) = bounds(1,ilb)';
  bb(iub) = bounds(2,iub)';

  k = find(abs(ibound) == 1);

  if ~isempty(k)
      j = ones(1,colx);
      xtransf(k,:) = bb(k,j) - ibound(k,j).*x(k,:).^2;
  end

  k = find(abs(ibound) == 2);

  if ~isempty(k)
      a       = bounds(1,k)';
      b       = bounds(2,k)';
      aplusb  = (a+b)/2;
      bminusa = b-a;
      j       = ones(1,colx);
      xtransf(k,:) = aplusb(:,j) + bminusa(:,j).*sin(x(k,:))/2;
      %disp('in constrai / 47')
      %keyboard
  end

  k = find(abs(ibound) == 0);

  if ~isempty(k)
      xtransf(k,:) = x(k,:);
  end

elseif inv == -1

  ilb     = find(ibound == -1);
  iub     = find(ibound ==  1);
  bb      = zeros(length(ibound),1);
  bb(ilb) = bounds(1,ilb)';
  bb(iub) = bounds(1,iub)';
%KORJAA testit
  k = find(abs(ibound) == 1);
  if ~isempty(k)
     if ~isempty(find(x(ilb) < bounds(1,ilb)', 1)) ...
           || ~isempty(find(x(iub) > bounds(2,iub)', 1))
        error('some variables not within bounds!')
     end
  end

  if ~isempty(k)
      j = ones(1,colx);
      xtransf(k,:) = sqrt(ibound(k,j).*(bb(k,j) - x(k,:)));
      disp('problems in constrai')
      keyboard
  end

  k = find(abs(ibound) == 2);

  if ~isempty(k)
     %keyboard
     if ~isempty(find(x(k) < bounds(1,k)' ...
           | x(k) > bounds(2,k)', 1))
        keyboard
        error('some variables not within bounds!')
     end
  end
  if ~isempty(k)
      a       = bounds(1,k)';
      b       = bounds(2,k)';
      aplusb  = (a+b)/2;
      bminusa = b-a;
      j       = ones(1,colx);
      a       = (2*(x(k,:)-aplusb))./bminusa;
      a       = a.*(abs(a)<=1) + (abs(a)>1);
      xtransf(k,:) = asin(a);
  end

  k = find(abs(ibound) == 0);

  if ~isempty(k)
      xtransf(k,:) = x(k,:);
  end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
