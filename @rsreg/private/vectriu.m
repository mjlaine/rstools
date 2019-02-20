  function matb = vectriu(b,n);
% keywords: regression, quadratic polynomials
% call: matb = vectriu(b,n);
% The function writes the components of the vector 'b' of
% length n(n+1)/2 as rows in an upper triangular matrix 'matb'.
% Useful when computing values of quadratic polynomials with
% coefficients 'b'

  len = n;
  i0  = 1;
  b   = b(:)';

  for i=1:n

     matb(i,:) = [zeros(1,i-1), b(i0:i0 - 1 + len)];
     i0     = i0+len;
     len    = len-1;

  end
