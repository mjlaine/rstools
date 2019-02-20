%% Responce surface example
% This example is from the book "Statistics for environmental engineers", 
% CRC Press 2002, Chapter 43.

%% First iteration
data1=[
    0.5 0.14 0.018
    0.5 0.16 0.025
    1.0 0.14 0.030
    1.0 0.16 0.040
    ];

xnames = {'Phenol Concentration (mg/L)','Dilution Rate (1/h)'};
out=rsreg(data1(:,1:2),data1(:,3),'intera',1,'code','no')
%%
figure(1); clf
quadplot(out,'type','contour','x',data1(:,1:2),'limits',[0.45 0.1; 2 0.22])

%% Second iteration
data2 = [
    1.0 0.16 0.041
    1.0 0.18 0.042
    1.5 0.16 0.034
    1.5 0.18 0.035
];

out=rsreg(data2(:,1:2),data2(:,3),'intera',1,'code','no')
%%
figure(2); clf
quadplot(out,'type','contour','x',data2(:,1:2),'limits',[0.45 0.1; 2 0.22])

%% Third iteration
data3 = [
    0.9  0.17  0.038
    1.25 0.156 0.043
    1.25 0.17  0.047
    1.25 0.184 0.041
    1.6  0.17  0.026
    ]

data = [data2;data3];

out=rsreg(data(:,1:2),data(:,3),'intera',2,'code','no')
%%
figure(3); clf
quadplot(out,'zoom',100,'type','contour','x',data,'y',data(:,3),'limits',[0.45 0.1; 2 0.22])
c = cana(out);
hold on
plot(c.xs(1),c.xs(2),'*')
hold off
xlabel(xnames(1));
ylabel(xnames(2));
