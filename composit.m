  function x = composit(n,nrepl,gen,alpha)
% keywords: central composite design, experimental design
% call: x = composit(n,nrepl,gen,alpha)
% the function computes a central composite design matrix 'x'
%
% INPUT:     n       the number of factors in the design
%            nrepl   n of central replications
%                    OPTIONAL, default nrepl = 1.
%            gen     the generator for a fractional design
%                    full design:     omit 'gen'
%                    fractional design:
%
%                                        gen = [var val],
%
%                    where  the rows of 'var' give factors in the block
%                    generators, 'val' the values of their products
%                    (in case of several generators extend the possible
%                    shorter generators with 0's to get each row of 'var'
%                    to be of the same length).
%                    OPTIONAL,  default full design with 'gen' omitted
%            alpha   axial point distance from the origin
%                    OPTIONAL, default 2^(n/4)
% OUTPUT:    x       the design matrix.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

if nargin==1
    gen=[];nrepl=1; alpha=2^(n/4);
elseif nargin==2
    gen=[]; alpha=2^(n/4);
elseif nargin==3
    alpha=2^(n/4);
elseif length(nrepl)==0,
    nrepl=1;
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

x=[x;kron(eye(n,n),alpha*[-1;1]);ones(nrepl,1)*zeros(1,n)];

