function [pc, Qdot, Qcond, Qconv, Qrad] = heatLossUniform(Vdot, Pavg, Ts)
% This function returns the chamber pressure, ideal power, and heat lost
% via conduction, convection and radiation.

% Values from Gelmi Table 1:
cpL = 4187; % Specific heat of liquid water [J/(kg.K)]
cpG = 1996; % Specific heat of water vapor [J/(kg.K)]
Lh = 2256e3; % Heat of vaporization of water [J/kg]
Ra = 8.314; % Universal gas constant [J/(mol.K)]
Mw = 0.01801528; % Molar mass of water [kg/mol]
y = 1.32; % Specific heat ratio of water vapor
p1 = 101325; % Reference pressure to calculate Tvap [Pa]
T1 = 373.15; % Boiling temp of water at p1 (used to calculate Tvap) [K]
At = 4.5e-9; % Throat area [m^2] (Design size is 45x100 microns)
T0 = 50; % Initial temp [C]
rho = 997; % Density of water [kg/m^3]

% Compute chamber pressure and temperature:
for i = 1:length(Vdot)
    [pc(i), Tvap(i)]=chamber_pressure(Vdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
end
pc = pc./100000; % Convert pressure to bar

% Compute ideal power:
for i = 1:length(Vdot)
    [Ipc(i), Tvap(i)]=chamber_pressure(Vdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
    [Qdot(i)] = ideal_power(Vdot(i), T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho); % Ideal power for vacuum pressure
end

% Silicon properties:
Ls = 0.01665;   % Overall length [m]
Ws = 0.007;     % Overall width [m]
ts = 0.0003;    % Overall thickness  [m]
es = 0.1;       % Emissivity [-]
% Glass properties:
Lg = 0.025;
Wg = 0.015;
tg = 0.0035;
eg = 0.9;
% Teflon properties:
Lt = 0.025;
Wt = 0.025;
tt = 0.009;
et = 0.92;
% Aluminum:
Atop = 7.27e-4;     % Approximated from solidworks model [m^2]
Abot = 1.05e-3;     % Approximated from solidworks model [m^2]
Aalumtot = Atop+Abot; % Total radiating area [m^2]
ea = 0.1;
sigma = 5.67e-8; % Stefan-Boltzmann constant

Tamb = 20+273; % Ambient temperature [K]
for i = 1:length(Vdot)
% Radiation:
Qrad(i) = sigma.*eg.*2.*(Lg+Wg).*tg.*(Ts(i)-Tamb).^4 +...
    sigma.*et.*2.*(Lt+Wt).*tt.*(Ts(i)-Tamb).^4 +...
    sigma.*ea.*Aalumtot.*(Ts(i)-Tamb).^4 +...
    sigma.*es.*(Ws.*ts).*(90-20).^4;
% Free convection:
hside = convectionCoefficient(Ts(i), Tamb, 0.0185);
Aside = 1.588e-3; % Area of vertical sides with free convection (not including glass)
Qconv(i) = hside.*Aside.*(Ts(i)-Tamb);
% Conduction:
syms Qcond
eqn1 = Pavg(i) == Qdot(i) + Qcond + Qrad(i) + Qconv(i);
S = vpasolve([eqn1], [Qcond], [0, Inf]);
Qsave(i) = double(S);
end
Qcond = Qsave;
%% Plot: (No longer used)
%{
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
green = [0.4660, 0.6740, 0.1880];
purple = [0.4940, 0.1840, 0.5560];

figure('DefaultAxesFontSize',18)
subplot(1,2,1)
hold on
plot(pc, Pavg, 'x-', 'LineWidth', 1)
plot(pc, Qcond, 'o--', 'LineWidth', 1)
plot(pc, Qdot, 'x--', 'LineWidth', 1)
plot(pc, Qconv, '^--', 'LineWidth', 1)
plot(pc, Qrad, '*--', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('Power [W]'); grid on
legend('$Q_{elec}$', '$Q_{cond}$', '$Q_{id}$', '$Q_{conv}$', '$Q_{rad}$',...
    'location', 'northwest')
subplot(1,2,2)
hold on
plot(pc, Ts-273, '*--', 'LineWidth', 1)
plot(pc, Tvap-273, 'x-', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('T [$^o$C]'); grid on; ylim([0,ceil(max([Tvap, Ts]-253))])
legend('$T_s$', '$T_{c}$', 'location', 'northwest')

figure('DefaultAxesFontSize',18)
pielabel = {'$Q_{id}$', '$Q_{cond}$', '$Q_{conv}$'}; %, '$Q_{rad}$'
for i = 1:length(Qdot)
subplot(1,3,i)
pie([Qdot(i), Qcond(i), Qconv(i)], pielabel) %, Qrad(i)
colormap([yellow; red; purple])
title(['$p_c$ = ', num2str(pc(i)), ' bar'])
end

figure()
subplot(1,3,1)
hold on
plot(pc, Pavg, 'x-', 'LineWidth', 1)
plot(pc, Qcond, 'o--', 'LineWidth', 1)
plot(pc, Qdot, 'x--', 'LineWidth', 1)
plot(pc, Qconv, '^--', 'LineWidth', 1)
plot(pc, Qrad, '*--', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('Power [W]'); grid on; title('BS2')
legend('$Q_{elec}$', '$Q_{cond}$', '$Q_{id}$', '$Q_{conv}$', '$Q_{rad}$',...
    'location', 'northwest')
%}
end