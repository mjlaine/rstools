  function x = taguchi(n)
% keywords: experimental design, screening
% call: x = taguchi(n)
% The function generates the Taguchi's orthogonal arrays
% L8, L12, L16 ,L9, L18 and L27
%
% INPUT          n       order of array (8,12,16,9,18 or 27)
%
% OUTPUT         x       the selected orthogonal array


% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/09 15:16:12 $

if nargin == 1
   m=2;
end

if n == 8

    x = [1     1     1     1     1     1     1
         1     1     1     2     2     2     2
         1     2     2     1     1     2     2
         1     2     2     2     2     1     1
         2     1     2     1     2     1     2
         2     1     2     2     1     2     1
         2     2     1     1     2     2     1
         2     2     1     2     1     1     2];
 
elseif n == 12

        i = [6     7     8     9    10    11
             3     4     5     9    10    11
             2     4     5     7     8    11
             2     3     5     6     8    10
             2     3     4     6     7     9
             1     3     4     7     8    10
             1     3     5     6     7    11
             1     4     5     6     8     9
             1     2     3     8     9    11
             1     2     4     6    10    11
             1     2     5     7     9    10];

        x=ones(12,11);
        for j=2:12
            x(j,i(j-1,:))=2*x(j,i(j-1,:));
        end

elseif n == 16

     x = [1     1     1     1     1     1     1     1     1     1     1     1
          1     1     1     1     1     1     1     2     2     2     2     2
          1     1     1     2     2     2     2     1     1     1     1     2
          1     1     1     2     2     2     2     2     2     2     2     1
          1     2     2     1     1     2     2     1     1     2     2     1
          1     2     2     1     1     2     2     2     2     1     1     2
          1     2     2     2     2     1     1     1     1     2     2     2
          1     2     2     2     2     1     1     2     2     1     1     1
          2     1     2     1     2     1     2     1     2     1     2     1
          2     1     2     1     2     1     2     2     1     2     1     2
          2     1     2     2     1     2     1     1     2     1     2     2
          2     1     2     2     1     2     1     2     1     2     1     1
          2     2     1     1     2     2     1     1     2     2     1     1
          2     2     1     1     2     2     1     2     1     1     2     2
          2     2     1     2     1     1     2     1     2     2     1     2
          2     2     1     2     1     1     2     2     1     1     2     1];
   
      z = [1     1     1
           2     2     2
           2     2     2
           1     1     1
           1     2     2
           2     1     1
           2     1     1
           1     2     2
           2     1     2
           1     2     1
           1     2     1
           2     1     2
           2     2     1
           1     1     2
           1     1     2
           2     2     1];
     
         x = [x z];

elseif n == 9

    x = [1     1     1     1
         1     2     2     2
         1     3     3     3
         2     1     2     3
         2     2     3     1
         2     3     1     2
         3     1     3     2
         3     2     1     3
         3     3     2     1];

elseif n == 27

    a = [1 1 1]; b = [2 2 2]; c = [3 3 3]; 
    d = [1 2 3]; e = [1 3 2]; f = [2 1 3];
    g = [2 3 1]; h = [3 1 2]; i = [3 2 1];
    x=  [a a a a];       % 1
    x=[x;a b b b];       % 2
    x=[x;a c c c];       % 3

    x=[x;b a b c];       % 4
    x=[x;b b c a];       % 5
    x=[x;b c a b];       % 6

    x=[x;c a c b];       % 7
    x=[x;c b a c];       % 8
    x=[x;c c b a];       % 9

    x=[x;d d d d];       % 10
    x=[x;d g g g];       % 11
    x=[x;d h h h];       % 12

    x=[x;g d g h];       % 13
    x=[x;g g h d];       % 14
    x=[x;g h d g];       % 15

    x=[x;h d h g];       % 16
    x=[x;h g d h];       % 17
    x=[x;h h g d];       % 18

    x=[x;e e e e];       % 19
    x=[x;e f f f];       % 20
    x=[x;e i i i];       % 21

    x=[x;f e f i];       % 22
    x=[x;f f i e];       % 23
    x=[x;f i e f];       % 24

    x=[x;i e i f];       % 25
    x=[x;i f e i];       % 26
    x=[x;i i f e];       % 27

    x=[kron(d',ones(9,1)) x];

elseif n ==18 

    a = [1 1 1]'; b = [2 2 2]'; c = [3 3 3]'; 
    d = [1 2 3]'; e = [1 3 2]'; f = [2 1 3]';
    g = [2 3 1]'; h = [3 1 2]'; i = [3 2 1]';

    x =    [a;a;a;b;b;b];   % 1
    x = [x [a;b;c;a;b;c]];  % 2
    x = [x [d;d;d;d;d;d]];  % 3
    x = [x [d;d;g;h;g;h]];  % 4
    x = [x [d;g;d;h;h;g]];  % 5
    x = [x [d;g;h;g;d;h]];  % 6
    x = [x [d;h;g;g;h;d]];  % 7
    x = [x [d;h;h;d;g;g]];  % 8

else

   error('n must be 8,12,16,9,18 or 27')
   
end
