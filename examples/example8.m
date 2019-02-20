%% Example 8

y = [ 74 69 78 81 76 87 84 91 ]';

X = [ % twon(3)
    -1    -1    -1
     1    -1    -1
    -1     1    -1
     1     1    -1
    -1    -1     1
     1    -1     1
    -1     1     1
     1     1     1
];

mm = [0.01 40 0.5;
      0.05 60 1.0]; % scaling
x = code(X,mm,-1);

xnames = {'cat/sub','temp','time'};
yname  = {'yield%'};

a1=X(:,3)==-1;
a2=X(:,3)==+1;
T1=X(:,2)==-1;
T2=X(:,2)==+1;

%%
figure(1);clf
subplot(2,1,1)
plot(x(a1&T1,1),y(a1&T1),'o:')
title('t=0.5'); 
hold on
plot(x(a1&T2,1),y(a1&T2),'o-')
hold off
legend({'T=40','T=60'})

subplot(2,1,2)
plot(x(a2&T1,1),y(a2&T1),'o:')
title('t=1.0'); xlabel('kat/sub');
hold on
plot(x(a2&T2,1),y(a2&T2),'o-')
hold off
legend({'T=40','T=60'})

%%
% Main effects
rsreg(X,y,'code',0,'intera',0,'xnames',xnames,'yname',yname)

%%
% all interactions
rsreg(X,y,'code',0,'intera',3,'xnames',xnames,'yname',yname)

%%
% choose terms
rsreg(X,y,'code',0,'terms',[1 2 3 1;0 0 0 3],'xnames',xnames,'yname',yname)


