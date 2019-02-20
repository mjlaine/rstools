%%
% D. Montgomery: Design and Analysis of Experiment, 3rd ed, problem 9-16
%
% Students on a statistics class made experiments to study how the
% pan material, stirring method and brand of brownie mix affect the
% the scrumptiousness of brownies. The factor were
%
%  Factor                      Low (-1)     High (+1)
%  A = pan material              Glass      Aluminium
%  B = stirring method           Spoon        Mixer
%  C = brand of mix            Expensive      Cheap
%
% The response variable was scrumptiousness, a subjective measure
% derived from a questionnaire given to the subjcts who sampled
% each bach of brownies. An eight-person test panel sampled each
% batch and filled out the questionnaire.
%
% (a) Analyze data as if there were eight replicates of a 2^3 design.
% (b) Analyse average and standard deviations of the results.
% (c) Which is more appropriate analysis?
%

%%
% design matrix 
x = [
% A  B  C    
 -1 -1 -1
 +1 -1 -1
 -1 +1 -1
 +1 +1 -1
 -1 -1 +1
 +1 -1 +1
 -1 +1 +1 
 +1 +1 +1
];

% Test panel results
y = [
    11  9 10 10 11 10  8  9
    15 10 16 14 12  9  6 15
     9 12 11 11 11 11 11 12
    16 17 15 12 13 13 11 11 
    10 11 15  8  6  8  9 14
    12 13 14 13  9 13 14  9
    10 12 13 10  7  7 17 13
    15 12 15 13 12 12  9 14    
    ];

%%
ny = size(y,2);

X = repmat(x,ny,1);
Y = y(:);

%%
result1=rsreg(X,Y,'intera',3,'xnames',{'A','B','C'})
%%
result2=rsreg(x,mean(y')','intera',0,'xnames',{'A','B','C'})
%%
result3=rsreg(x,std(y')','intera',0,'xnames',{'A','B','C'})


