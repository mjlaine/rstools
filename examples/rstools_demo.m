%% Demo for the rstools package
% The |rstools| collection of matlab files has some tools for design of
% experiments, regression analysis and response surface analysis.

%% Factorial designs
% There are functions for factorial designs, like |twon|, |composite|, and
% |facecent|. The following generates $2^N$, with $N=3$ factorial design with 4
% center point replicates. The design is given in coded [-1,1] units.

X = twon(3,4)

%%
% To get similar central composite design use
X = composit(3,4)

%%
% Using the function |code|, the desing can be transformed to and back from
% the coded unit and original experimental units. 
minmax = [1 10 2; 2 20 3];
x = code(X,minmax,-1)

%%
% For illustration, generate synthetic observations.
y = 2 + 2*X(:,1) + 2.5*X(:,2) + 0.2*X(:,3) + 1*X(:,2).*X(:,3) + 2*X(:,1).^2 + randn(size(X,1),1)*0.3;

%%
% The analysis is usually done in coded units. The function |reg| returns
% a 'regression' object. Displaying the object on screen shows the usual
% regression diagnostics.
out = reg(X,y,'intera',2)

%%
% There are several functions (i.e. methods) for the regression results. To
% get all the possible methods, use the function |methods|. Generic
% function |get| shows all the elements of the regression object.
% The special |quadplot| plots the regression surface
% with respect to the two first variables. Option |xfree| can be used to
% select the free variables and options |x| and |y| to show the observation
% locations and values. To plot contours only use |...,'type','contour')|.
methods(out)
figure(1); clf
subplot(1,2,1)
quadplot(out,'x',X,'y',y)
subplot(1,2,2)
quadplot(out,'xfree',2:3,'x',X,'y',y)
%%
% If there are many variables, you can use |efectplot| to select those who
% have the largest efect, |resplot| to plot the residuals, etc.
figure(11);
efectplot(out);
%% Response surface analysis
% There are some functions for response surface analysis, like |rsreg|,
% |cana| and |quadpath|. The following is SAS RSREG example 63.1, a
% saddle-surface response using ridge analysis.
%
% X variables:
% 
%  Time = Reaction Time (Hours)
%  Temp = Temperature (Degrees Centigrade)
% 
% Y variable:
% 
%  Y = Percent Yield Mercaptobenzothiazole

data=[
    4.0   250   83.8
   20.0   250   81.7
   12.0   250   82.4
   12.0   250   82.9
   12.0   220   84.7
   12.0   280   57.9
   12.0   250   81.2
    6.3   229   81.3
    6.3   271   83.1
   17.7   229   85.3
   17.7   271   72.7
    4.0   250   82.0
    ];
x = data(:,1:2);
y = data(:,3);
%%
% The function |rsreg| is similar to |reg|, but it defaults to fitting a full
% quadratic model. In some cases, |rsreg| can automatically detect the coding and use [-1,1]
% coded units in the analysis.
options = struct;
options.xnames = {'Time','Temp'};
out=rsreg(x,y,options)
%%
% Function |cana| calculates the canonical analysis of the fitted quadratic
% surface. We have a saddle.
cana(out);
%%
% The plot reveals the situation.
figure(2); clf
quadplot(out,'type','contour','limits',[0 200 ; 25 285],'x',x)

