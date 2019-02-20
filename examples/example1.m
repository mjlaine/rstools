%% Example 1, regression model with 2 variables

load example1_data.dat % load data

x = example1_data(:,1:2);
y = example1_data(:,3);

%%
figure(1); clf
subplot(2,1,1)
plot(x(:,1),y,'o'); xlabel('x_1'); ylabel('y')
subplot(2,1,2)
plot(x(:,2),y,'o'); xlabel('x_2'); ylabel('y')
%%

reg(x,y)

%%
figure(2); clf
plot(x(:,1),x(:,2),'o')
xlabel('x_1')
ylabel('x_2')
