  function plotcont(F,limits,zlevels,ltype,varargin)
  %tämä ei toimi!!!
% keywords: contour plot
% call: plotcont(F,limits,zlevels,ltype,varargin)
% The function plots a contourplot of F(x,y) on a given square.
%
% INPUT:
%
%      F        a function handle to the function to be plotted
%      limits   a vector of length 4 with [xmin, xmax, ymin, ymax]
%      zlevels  number of contour lines or a vector of contour levels
%      ltype    line type  and color
%               OPTIONAL, DEFAULT = 'g-'

if nargin < 4, ltype = 'k-'; end
if isempty(ltype); ltype = 'k-'; end 

xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);

xstep = (xmax-xmin)/50;
ystep = (ymax-ymin)/50;

xaxis = xmin:xstep:xmax;
yaxis = ymin:ystep:ymax;

[x,y] = meshgrid(xaxis,yaxis);

 z = F(x,y,varargin{:}); 
 %keyboard

cs = contour(xaxis,yaxis,z,zlevels); 
clabel(cs)

