function y=code(x,minmax,opt)
% keywords: data scaling
% call: y=code(x,minmax,opt)
% The function gives the transformation between the original
% and coded variables x.
%
% INPUT:       x        A (n by p) matrix whose rows give the coordinates to
%                       be transformed.
%              minmax   A (2 by p) matrix giving the lower (1.row) and
%                       upper (2.row) values of the coordinates. By
%                       default 'minmax' correspond to the +-1 levels in
%                       the coded units, but see 'imax' below.
%              opt      Options for coding.
%                       opt = dire  OR   opt = [dire  imax].
%                  dire     The direction of the transformation.
%                           dire = 1:     original --> coded (+1,-1)
%                           dire =-1:     coded    --> original
%                  imax     imax = 1:    the values in 'minmax' refer to the
%                          absolute min/max in a composite design, (i.e.,
%                          +- sqrt(n) instead of the usual +- 1)
%                          OPTIONAL, default: imax = 0
%
% OUTPUT       y        The transformed coordinates

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.4 $  $Date: 2004/10/04 10:57:09 $

 [n m] = size(x);


 if nargin < 3, error('Not enough input for CODE'); end

 opt = opt(:);
 if length(opt)==1,
   inv = opt(1); imax = 0;
 elseif length(opt)==2
   inv = opt(1); imax = abs(opt(2));
 else
   error('False opt for CODE'); 
 end

 if imax == 1;
   scale = sqrt(m);
 else
   scale = 1;
 end

 range=ones(n,1)*abs(minmax(2,:)-minmax(1,:))*.5/scale;
 means=ones(n,1)*mean(minmax);

 if any(range<=0)
   error('max-min should be > 0')
 end
 if inv==1
   y=(x-means)./range;
 elseif inv==-1
   y=range.*x+means;
 else
   error('opt(1) must be 1 or -1 in CODE');
 end
