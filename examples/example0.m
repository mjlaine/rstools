%% Example 0, a simple regression model

xy = [
20  8.4 
22  9.5 
24 11.8
26 10.4
28 13.3
30 14.8
32 13.2
34 14.7
36 16.4
38 16.5
40 18.9
42 18.5
];

x = xy(:,1);
y = xy(:,2);

%%
figure(1); clf 
plot(x,y,'o')
xlabel('x');
ylabel('y');

%%
tulos=reg(x,y)

%%
yfit = predicted(tulos);

hold on
plot(x, yfit,'-');
hold off

residuals(tulos)
%%
figure(2)
normalplot(tulos)
