function [hside] = convectionCoefficient(Tw, Tinf, L)
[Polrho, Polbeta, Polc, Polk, Polmu] = airProperties();
%L = 0.0125; % [m]
for i = 1:length(Tw)
% rho = Polrho(1).*Tw(i).^2 + Polrho(2).*Tw(i) + Polrho(3);
% beta = Polbeta(1).*Tw(i).^2 + Polbeta(2).*Tw(i) + Polbeta(3);
% k = Polk(1).*Tw(i).^2 + Polk(2).*Tw(i) + Polk(3);
% mu = Polmu(1).*Tw(i).^2 + Polmu(2).*Tw(i) + Polmu(3);
rho = Polrho(1).*Tinf.^2 + Polrho(2).*Tinf + Polrho(3);
beta = Polbeta(1).*Tinf.^2 + Polbeta(2).*Tinf + Polbeta(3);
k = Polk(1).*Tinf.^2 + Polk(2).*Tinf + Polk(3);
mu = Polmu(1).*Tinf.^2 + Polmu(2).*Tinf + Polmu(3);

c = 1007; % Specific heat [J/kg.K]
Pr = mu.*c./k; % Prandtl number [-]
g = 9.81; % Gravitational acceleration [m/s^2]
dT = Tw(i) - Tinf;
Gr = (L.^3).*(rho.^2).*g.*dT.*beta./(mu.^2); % Grashof number [-]
Ral = Gr.*Pr; % Rayleigh number [-]
hside(i) = (k./L).*(0.68 + 0.67.*(Ral.^0.25)./(1+(0.492./Pr).^(9/16)).^(4/9));
end
end