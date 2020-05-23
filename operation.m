function [pc, Tvap, Vdot, mdot, Q, F, Vg, Vp, tvec, I] = operation(thruster, Vrat)
% This function returns the following parameters propagated in time:
% pc: Chamber pressure [Pa]
% Tvap: Vaporization temperature [K]
% Vdot: Volume flow rate [m^3/s]
% mdot: Mass flow rate [kg/s]
% Q: Power required [W]
% F: Thrust [N]
% Vg: Volume of pressurant gas [m^3]
% Vp: Volume of propellant [m^3]
% tvec: Time vector [s]
% I: Total impulse delivered [N.s]

% Values from Table 1:
cpL = 4187; % Specific heat of liquid water [J/(kg.K)]
cpG = 1996; % Specific heat of water vapor [J/(kg.K)]
Lh = 2256e3; % Heat of vaporization of water [J/kg]
Ra = 8.314; % Universal gas constant [J/(mol.K)]
Mw = 0.01801528; % Molar mass of water [kg/mol]
y = 1.32; % Specific heat ratio of water vapor
p1 = 101325; % Reference pressure to calculate Tvap [Pa]
T1 = 373.15; % Boiling temp of water at p1 (used to calculate Tvap) [K]
At = 4.5e-9; % Throat area [m^2] (Design size is 45x100 microns)
% Real throat width is 20.1 +/- 3.2 microns. (Silva Table 6)
%At = (0.5*(20.1+26.0).*1e-6).*(100e-6) % Effective throat area
T0 = 50; % Initial temperature [C]
rho = 997; % Density of water [kg/m^3]

%Inputs:
Pol = thruster.Pol; % Polynomial of linear approximation
Qmax = 4; % Maximum allowed power [W]
pc0 = (Qmax- Pol(2))./Pol(1).*1e5; % Initial (highest) pressure [Pa]

%% Propagation:
Arat = thruster.wd./thruster.wt;    % Area ratio [-]
prat = pressureRatio(Arat, y);      % Pressure ratio [-]
G = sqrt(y.*((1+y)./2).^((1+y)./(1-y))); % Vandenkerckhove function
Vtube = 5.81e-7;    % Total volume of propellant storage tube [m^3]
dt = 0.01;          % Time interval [s]
tvec = 0:dt:3000;   % Time vector [s]
%Initial conditions:
Vg(1) = Vrat.*Vtube;    % Volume of pressurant gas [m^3]
pc(1) = pc0;            % Chamber pressure [Pa]
Tvap(1) = waterTvap(pc(1)); % Initial chamber temperature [K]
mdot(1) = pc(1).*At.*G./sqrt(Ra./Mw.*Tvap(1)); % Mass flow [kg/s]
Vdot(1) = mdot(1)./rho; % Flow rate [m^3/s]
Vp(1) = Vtube-Vg(1);    % Propellant volume [m^3]
Q(1) = Pol(1).*pc(1)./1e5 + Pol(2); % Required power [W]
ve(1) = sqrt(2.*y./(y-1).*Ra./Mw.*Tvap(1).*(1-prat.^((y-1)./y))); % Exit velocity [m/s]
F(1) = mdot(1).*ve(1) + (prat.*pc(1)).*(thruster.wd).*(100e-6); % Ideal thrust [N]
Fmin = 0.12e-3; % Minimum thrust [N]
%pcForMaxF = 0.003./(At.*G.*sqrt(2.*y./(y-1).*(1-prat.^((y-1)./y)))+prat.*Arat.*At)./1e5
i = 2;
while Vp(i-1) > 0 %&& F(i-1) > Fmin %pc(i-1) > 0.1789e5
    Vg(i) = Vg(i-1) + Vdot(i-1).*dt; % [m^3]
    pc(i) = pc(i-1).*Vg(i-1)./Vg(i); % [Pa]
    
    Tvap(i) = waterTvap(pc(i)); % [K]
    mdot(i) = pc(i).*At.*G./sqrt(Ra./Mw.*Tvap(i)); % [kg/s]
    Vdot(i) = mdot(i)./rho; % [m^3/s]
    Vp(i) = Vtube-Vg(i); % [m^3]
    Q(i) = Pol(1).*pc(i)./1e5 + Pol(2); % [W]
    ve(i) = sqrt(2.*y./(y-1).*Ra./Mw.*Tvap(i).*(1-prat.^((y-1)./y))); % [m/s]
    F(i) = mdot(i).*ve(i) + (prat.*pc(i)).*(thruster.wd).*(100e-6); % [N]
    i = i+1;
end
tvec = tvec(1:i-1);
I = cumtrapz(tvec,F); % Total impulse [N.s]
end