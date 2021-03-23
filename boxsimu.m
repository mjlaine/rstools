function z=boxsimu(x)
%Simulated yields of B in a batch reaction A->B->C
%Call:
%boxsimu([time temp]) % time in min, temp in degrees C
%example:
%boxsimu([200 60])
aika  = x(:,1);
lampo = x(:,2);

A = 100;
B = 0.005;
C = 0.001;
D = 8.314;
E = 273.15 + 50;
G = 5 * 10^4;
H = 1 * 10^4;

F = 273.15 + lampo;
I = B * exp(-(G/D*(1./F-1/E)));
J = C * exp(-(H/D*(1./F-1/E)));
K = (F-273.15-200)/10;
L = ((A.*I)./(J-I)).*(exp(-I.*aika)-exp(-J.*aika)).*((exp(-K))./(1+exp(-K)));

z = L+randn(size(aika));
