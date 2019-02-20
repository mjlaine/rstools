%% Osimu exercise
%
% Matlab function OSIMU simulates a laboratory experiment and
% returns a response y at experimental points x_1,x_2 with added
% experimental error. Starting from region 200 < x1 <250, 100 < x2 < 120,
% try to find as large response as possible (over 90) by using as few
% experiments as possible. Start with a simple design and a simple linear
% model. Use the model to predict the next experimental point, update the
% model, and iterate.


%%
% As new observations are genereted each time this code is run, there is no
% quarantee that it will find the correct (or a good) answer every time.
% Let's have a fixed random number generator seed, so that the results will
% be the same every time this code is run.
rng(2017);

% Count the number of simulations needed.
nsimu=0;

% The first experiment, 2^2 + 5 center point replications.
X1 = twon(2,5);

% Select the experimental region,
minmax = [200 100;250 120]; 

% then code the experiment to the original units.
x1 = code(X1,minmax,-1)
%%
% Perform the experiment.
y1 = osimu(x1)
nsimu=nsimu+length(y1);
%%
% Analyze the experiment, first order interactions, the model is
%
%  y = b0 + b1*x1 + b2*x2 + b12*x1*x1 + eps
%
reg1=rsreg(x1,y1,'intera',1)
% Plot the surface as a countour plot.
figure(1); clf
quadplot(reg1,'x',x1,'type','contour', 'zoom',120)
title('first osimu experiments')

%%
% We must advance to gradient direction until the results do
% not change any more. Calculate the gradient path.
g1 = gradpath(reg1,[200 100]);
%%
% One experiment first.
y2g=osimu(g1.x(1,:))
nsimu=nsimu+1;
%%
% Then proceed along the gradient path.
s = pestd(reg1); % std from replicates
ng = length(g1.x);
for i=2:ng 
    y2g = [y2g;osimu(g1.x(i,:))];
    nsimu=nsimu+1;
    % until change < 2*error std
    if diff(y2g(end-1:end))<-2*s
        break % stop here
    end
end
[g1.x(1:i,:),y2g]
figure(1)
hold on
plot(g1.x(1:i,1),g1.x(1:i,2),'.:')
hold off
%%
% It seems that the corner point, where we got the largest y so far,
% was already at the edge and the responses start to decrease.
% Lets move the experimental region here and start again.
% Use the largest found value as the center.
[m,j]=max(y2g);
x0 = g1.x(j,:);
minmax2 = [x0-[20,10];x0+[20,10]];
x2=code(twon(2,4),minmax2,-1)
%%
y2=osimu(x2)
nsimu=nsimu+length(y2);
%%
figure(1)
hold on
plot(x2(:,1),x2(:,2),'*')
hold off
%%
% Analyze the new experiment.
reg2=rsreg(x2,y2,'intera',1)
figure(2); clf
quadplot(reg2,'type','contour','x',x2,'zoom',120)
%quadplot(reg2,'x',x2,'y',y2,'zoom',104)
title('Second region')
%%
% We will need a CC experiment here, so add the axial points.
X2cc = composit(2); X2cc=X2cc(5:8,:);
x2cc = code(X2cc,minmax2,-1);
%%
y2cc = osimu(x2cc)
nsimu=nsimu+length(y2cc);
%%
figure(2)
hold on
plot(x2cc(:,1),x2cc(:,2),'s')
hold off
x3 = [x2;x2cc]; y3=[y2;y2cc];
reg3=rsreg(x3,y3);
figure(3)
quadplot(reg3,'type','contour','x',x3,...
    'limits',[10 80; 250 200])
title('More experiments')
%%
% Now we seem to be on a ridge. We will move along it by gradient path.
[m,ii]=max(y3);x3max = x3(ii,:);
g3= gradpath(reg3,x3max,0.1,100);
g3.x = g3.x(1:5:end,:); % use only every 5. value
%%
y3g=osimu(g3.x(1,:))
nsimu=nsimu+1;
%%
% Again, we perform experiments until the values do not change
% significantly.
s = pestd(reg3); % replicate std
ng = length(g3.x);
for i=2:ng 
    y3g = [y3g;osimu(g3.x(i,:))];
    nsimu=nsimu+1;
    if diff(y3g(end-1:end))<-2*s
        break
    end
end
[g3.x(1:i,:),y3g]
figure(3)
hold on
plot(g3.x(1:i,1),g3.x(1:i,2),'.:')
hold off
%%
% Select the maximum value obtained and make another
% experimental region around it.
[m,j]=max(y3g);
x0 = g3.x(j,:);
minmax4 = [x0-[15,10];x0+[15,10]];
x4=code(composit(2,4),minmax4,-1)
%%
y4=osimu(x4)
nsimu=nsimu+length(y4);
%%
% Analyze.
reg4=rsreg(x4,y4);
figure(4); clf
quadplot(reg4,'type','contour','x',x4,'zoom',120)
%%
% It seems that we might be close to a maximum.
% Find the stationary point and make an experiment there.
% If the result is > 90, we are happy.
c4 = cana(reg4)
%%
y5 = osimu(c4.xs)
nsimu=nsimu+1;
%%
figure(4)
hold on
plot(c4.xs(:,1),c4.xs(:,2),'*')
text(c4.xs(:,1),c4.xs(:,2),num2str(y5))
hold off
title({'Fourth region, the optimum has been found?',...
    sprintf('nsimu=%d',nsimu)});

