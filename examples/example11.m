%% 2^2 example

x = [
    -1    -1
     1    -1
    -1     1
     1     1
];

y = [69 91 86 93]';

result = rsreg(x,y,'intera',1)
%%
figure(1); clf
quadplot(result,'x',x,'y',y,'type','mesh','zoom',120)

% or shortly as one-liner
result = rsreg(twon(2),[69 91 86 93]','intera',1);
