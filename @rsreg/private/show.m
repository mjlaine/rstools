function out=show(res,output)
%SHOW rsreg object
% used by rsreg/display

if nargin<2
  output=1;
end

if isfield(res,'class');
  class = res.class;
else
 error('input argument is incorrect for show');
end

switch class
 case 'reg'
  regshow(res,output);
 case 'cana'
  canashow(res);
 case 'empty'
 otherwise
  error('unknown class');
end

%%%%%%%%%%%%%%
function regshow(res,output)

fprintf('Regression analysis\n');

n = length(res.b);
fprintf('\n');
fprintf('Parameter Estimates');
if res.code
  fprintf('  (using coded units)');
end
fprintf('\n\n');
fprintf('                  Parameter        Standard      T for H0:\n');
fprintf('                   Estimate           Error    Parameter=0   Prob > |T|\n');
fprintf('-----------------------------------------------------------------------\n');
for i=1:n
  if res.stp(i,3)<=0.001
    s=' ***';
  elseif res.stp(i,3)<=0.01
    s=' **';
  elseif res.stp(i,3)<=0.05    
    s=' *';
  else
    s='';
  end
  fprintf('%15s\t%11.5g\t%11.5g\t%10.4g\t%7.4f%s\n',res.names{i},res.b(i),res.stp(i,1),res.stp(i,2),res.stp(i,3),s)
end

if res.dfres>0

fprintf('\nAnalysis of Variance\n\n');

fprintf('source              SS    df          MS           F           P\n');
fprintf('----------------------------------------------------------------\n');
fprintf('regression %11.5g %5g %11.5g %11.5g %11.4f\n',...
        res.ssreg,res.dfreg,res.ssreg/res.dfreg,res.f,res.pf);
if res.dfres==0
  f= NaN;
else
  f=res.ssres/res.dfres;
end
fprintf('residual   %11.5g %5g %11.5g\n',...
         res.ssres,res.dfres,f);
fprintf('total      %11.5g %5g\n',...
        res.sstot,res.dftot);

end

%% anova for regression terms
if isfield(res,'sslin') & res.sscro > 0 & res.dfres>0& output
  fprintf('\n');
  fprintf('                     SS    df           F           P\n');
  if res.dflin == 0
    f = 0;
    pf = 0;
  else
    f = res.sslin/res.dflin/res.ssres*res.dfres;
    if res.dfres <=0
      pf = NaN;
    else
      pf = 1-distf(f,res.dflin,res.dfres);
    end
  end
%  if pf < 1e-4; pf = 0; end
  fprintf('linear      %11.5g %5g %11.5g %11.4f\n',...
          res.sslin,res.dflin,f,pf);
  
  if res.dfcro == 0
    f = 0;
    pf = 0;
  elseif res.dfres ==0
    f = NaN;
    pf = NaN;
  else
    f = res.sscro/res.dfcro/res.ssres*res.dfres;
    pf = 1-distf(f,res.dfcro,res.dfres);
  end
  if pf < 1e-4; pf = 0; end
  fprintf('crossprod   %11.5g %5g %11.5g %11.4f\n',...
          res.sscro,res.dfcro,f,pf);
  if res.dfqua == 0
    f = 0;
    pf = 0;
  else
    f = res.ssqua/res.dfqua/res.ssres*res.dfres;
    pf = 1-distf(f,res.dfqua,res.dfres);
  end
  if pf < 1e-4; pf = 0; end
  fprintf('quadratic   %11.5g %5g %11.5g %11.4f\n',...
          res.ssqua,res.dfqua,f,pf);
  if res.dfres ==0
    f=NaN;
    pf=NaN;
  else
    f = res.ssreg/res.dfreg/res.ssres*res.dfres;
    pf = 1-distf(f,res.dfreg,res.dfres);
  end
%  if pf < 1e-4; pf = 0; end
  fprintf('model total %11.5g %5g %11.5g %11.4f\n',...
          res.ssreg,res.dfreg,f,pf);
  
end

if ~isnan(res.sslof) & output&res.dfres>0&res.dflof>0
  fprintf('\nLack of fit\n');

  fprintf('                     SS    df          MS           F           P\n');
  fprintf('lack of fit %11.5g %5g %11.5g %11.5g %11.4f\n',...
          res.sslof,res.dflof,res.sslof/res.dflof,res.flof,res.plof);
  fprintf('pure error  %11.5g %5g %11.5g\n',...
          res.sspe,res.dfpe,res.sspe/res.dfpe);
  fprintf('total error %11.5g %5g\n',...
          res.ssres,res.dfres);
end

%fprintf('\nF value     = %g', res.f);
%fprintf('\nProb > F    = %g', res.pf) ;
fprintf('\nObservations  = %g', res.n);
if res.sspe>0&output
  fprintf('\nPure error    = %g', sqrt(res.sspe/res.dfpe));
end
fprintf('\nResidual std  = %g', res.rmse);
fprintf('\nR-square      = %g', res.r2);
if ~isnan(res.r2adj)
  fprintf('\nR-square adj. = %g', res.r2adj);
end
fprintf('\n');

%%%%%%%%
function canashow(res)
% show canonical analysis results

%disp(res) % kesken
fprintf('\nCanonical analysis\n\n');

fprintf('type of stationary point: %s\n',res.type);
fprintf('\n');

fprintf('stationary point, original\n');
disp(res.xs);
fprintf('stationary point, coded\n');
disp(res.Xs);
fprintf('estimated response at the stationary point\n');
disp(res.ys);

%fprintf('\n');

n = size(res.T,1);
fprintf('eigenvalues\n');
disp(res.lam');
fprintf('eigenvectors\n');
disp(res.T'); % obs T'

