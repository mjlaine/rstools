  function x=twon(n,nrepl,gen)
% keywords: experimental design, factorial design
% call: x=twon(n,nrepl,gen)
% The function computes a full or fractional 2^n factorial design
%
% INPUT:     n       the number of factors in the design
%            nrepl   the number of central replications.
%                    OPTIONAL, default nrepl = 0
%            gen     the generator for a fractional design.
%                    Full design: omit 'gen'
%                    Fractional designs with the generator 'gen',
%
%                              gen = [var val],
%
%                    where  the rows  of the matrix 'var' give the factors
%                    in the block generators, the last column  'val' the
%                    values of their products. In case of several
%                    generators extend the possible shorter generators with
%                    0's to get each row of 'var' to be of the same length.
%                    OPTIONAL, default full design when 'gen' omitted.
%
% OUTPUT:    x       the design matrix.
%

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

if nargin==1
    gen=[];nrepl=0;
elseif nargin==2
    gen=[];
elseif length(nrepl)==0,
    nrepl=0;
elseif nargin<1
    error('too few inputs');
end

[m2 m1]=size(gen);m1=m1-1;

i=0:2^n-1;i=i';

for j=1:n
%    x(:,n-j+1)=rem(floor(i./2^(j-1)),2);
    x(:,j)=rem(floor(i./2^(j-1)),2);
end

x=2*x-1;

if m1>0

    x0=ones(2^n,m2);

    for k=1:m2
        for j=1:m1
            if gen(k,j)>0
                x0(:,k)=x0(:,k).*x(:,gen(k,j));
            end
        end
    end

    compare=ones(2^n,1)*gen(:,m1+1)';

    igen=find(sum(abs([x0-compare zeros(2^n,1)]'))'==0);

    x=x(igen,:);

end

 x = [x; ones(nrepl,1)*zeros(1,n)];

