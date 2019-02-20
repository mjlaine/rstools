%% Classical Ina brick factory example
% Taguchi Introduction to quality engineering, 1986 p. 80.
%
% y is the fraction of bricks that do not meet quality requirements

y=[ 26 42 68 12 6 17 6 16 ]';

% X variables
%
%                                        -1          +1 
%  A lime additive content                5 %         1 % 
%  B additive particle size             coarse       fine 
%  C agalmatolite content                43 %        53 % 
%  D type of agalmatolite              current   less expensive 
%  E charge quantity                   1300 kg     1200 kg 
%  F waste return content                 0 %         4 % 
%  G feldspar content                     0 %         5 %

%%
% Plackett-Burman for 7 variables
X=[
     1     1     1    -1     1    -1    -1
     1     1    -1     1    -1    -1     1
     1    -1     1    -1    -1     1     1
    -1     1    -1    -1     1     1     1
     1    -1    -1     1     1     1    -1
    -1    -1     1     1     1    -1     1
    -1     1     1     1    -1     1    -1
    -1    -1    -1    -1    -1    -1    -1
];

%%
% regression analysis
out=reg(X,y)

%%
% predic for all combinations
Xful = twon(7);
yful = predict(out,Xful);
% find the smallest predicted value
[m,i]=min(yful);
% Its X values and the predicted value
Xful(i,:),m

