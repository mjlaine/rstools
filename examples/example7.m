%% box model simulation

rng(1234); % fix random seed

minmax = [20 100;
          40 120];

x1 = code(twon(2,4),minmax,-1);
y1 = boxsimu(x1)

%%
opt=[];
opt.xnames = {'time','temperature'};
opt.intera = 1;
opt.savedata = 'yes';

result1=rsreg(x1,y1,opt)

%%
figure(1);clf

quadplot(result1,'x',x1,'y',y1)

%%
p=gradpath(result1,[20,120],0.5,10);

%%
x2 = p.x;
y2 = boxsimu(x2); % simulate new values
[p.X,x2,y2]

%%
minmax = [10 130;
          20 150];

x3 = code(twon(2,4),minmax,-1);
y3 = boxsimu(x3)
result2=rsreg(x3,y3,opt);

%%
x4 = code(composit(2),minmax,-1);
x4 = x4(5:8,:);
y4 = boxsimu(x4)
opt.intera=2;
result3=rsreg([x3;x4],[y3;y4],opt)

%%
quadplot(result3,'x',[x3;x4],'y',[y3;y4],'type','contour','zoom',110)

%%
cana(result3)

%%
figure(2); clf
normalplot(result3)
