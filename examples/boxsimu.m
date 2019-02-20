function z=boxsimu(x)
%BOXSIMU simulate yield for a process given time and temperature

time  = x(:,1);
temp = x(:,2);

A = 100;
B = 0.005;
C = 0.001;
D = 8.314;
E = 273.15 + 50;
G = 5 * 10^4;
H = 1 * 10^4;

F = 273.15 + temp;
I = B * exp(-(G/D*(1./F-1/E)));
J = C * exp(-(H/D*(1./F-1/E)));
K = (F-273.15-200)/10;
L = ((A.*I)./(J-I)).*(exp(-I.*time)-exp(-J.*time)).*((exp(-K))./(1+exp(-K)));

z = L+randn(size(time));
