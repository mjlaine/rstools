%% SAS RSREG example 63.1
% A saddle-surface response using ridge analysis

% X variables
%  Time = Reaction Time (Hours)
%  Temp = Temperature (Degrees Centigrade)
% Y variable
%  Y = Percent Yield Mercaptobenzothiazole


clear options
options.xnames = {'Time','Temp'};
%options.code = 'no';


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
out=rsreg(x,y,options)
%%

cana(out)
c = cana(out);

quadplot(out,'type','contour','limits',[0 200 ; 20 280])
hold on 
plot(x(:,1),x(:,2),'*')
hold off

%%
g = gradpath(out,[12 250]);
hold on 
plot(g.x(:,1),g.x(:,2),'o-')
hold off
