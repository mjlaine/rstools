function out=cana(rsres)
%CANA canonical analysis on RSREG output
% Performs canonical analysis on REREG results
% C = CANA(regout) returns
% C.Xs sationary point in coded units
% C.xs stationary point in original units
% C.y  estimated response at the stationary point
% C.b0 C.b C.B canonical form of model parameters
% C.lam eigenvalues on B
% C.T the transformation Xcanonical = Xoriginal*T
% When called without output argument pretty prints the results
res=rsres.res;

bful = quadcomp(res.b,res.terms,res.nx);
[b0,b,B] = quadmat(bful);
lam = flipud(eig(B)); % from largest to smallest
if any(lam==0)
  type = 'flat';
elseif all(lam<0)
  type = 'maximum';
elseif all(lam>0)
  type='minimum';
else
  type = 'saddle point';
end

if strcmp(type,'flat')
  Xs = NaN*ones(1,res.nx);
  T  = eye(res.nx);
  ys  = NaN;
else
  [b02,b2,B2,T,Xs,ys] = quadcana(bful);
end
T = fliplr(T); % differs from 

o.class = 'cana';
o.type = type;
o.lam  = lam';
if res.code
  o.Xs = Xs;
  o.xs = code(Xs,res.minmax,-1);
else
  o.xs = Xs;
  o.Xs = code(Xs,res.minmax,+1);
end
o.ys = ys;
o.b0 = b0;
o.b = b;
o.B = B;
o.T = T;

if nargout==0
  show(o);
else
  out=o;
end
