  function [xx,yy] = meshgen(x,y);
% keywords: version compability
% call: [xx,yy] = meshgen(x,y);
% The function generates mesh grids, choosing between MESHDOM and
% MESHGRID.
% NOTE. Only for compatibility between Matlab3.5, Matlab4, Matlab5

 xx=[];  yy=[];
 vers=abs(version); vers=vers(1);

 if vers==51
    [xx,yy] = eval('meshdom(x,y)');
 end

 if vers>=52
    [xx,yy] = eval('meshgrid(x,y)');
 end

