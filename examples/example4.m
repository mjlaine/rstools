%% Box Draper example Table 7.1 page 205
% 3x3x3 textile data
% 
%  X1 = the length of test specimen (mm)
%  X2 = the amplitude of load cycle (mm)
%  X3 = the load (g)
%  y  = number of cycles to failure

load table71.dat  -ascii

X = table71(:,1:3);
y = table71(:,4);

options = [];
options.xnames = {'x1','x2','x3'};
options.minmax = [200 7 35;400 11 45];
options.code = 'no';
options.intera = 2;

%%
out=rsreg(X,log10(y),options)
%%
quadplot(out)
%%
cana(out)
