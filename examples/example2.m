%% SAS RSREG Getting Started example 
% 'Response Surface with a Simple Optimum';
% A three factor experiment aimed at reducing the unplesant odor
% of a chemical. 
%
% y variable odor;
% x variables:
%    T = "Temperature"
%    R = "Gas-Liquid Ratio"
%    H = "Packing Height";
% 
data = [
    66  40 .3 4
    58  40 .5 2
    65  80 .3 2
   -31  80 .5 4
    39 120 .3 4
    17 120 .5 2
     7  80 .7 2
   -35  80 .5 4
    43  40 .7 4
    -5  40 .5 6
    43  80 .3 6
   -26  80 .5 4
    49 120 .7 4
   -40 120 .5 6
   -22  80 .7 6
       ];
      
x = data(:,2:4);
y = data(:,1);
%%     
clear options;
options.xnames = {'T','R','H'};
options.yname  = 'odor';

out=rsreg(x,y,options)
%%
figure(1); clf
quadplot(out,'xfree',[1,2],'xfixed','opt')
%%
cana(out)
