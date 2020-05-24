% BS2:
clear
Vdot = [0.5, 1, 2]; % [ml/h]
Phigh = [2.32, 3.06, 4.22]; % [W]
%Pavg = [2.21, 2.84, 4.16]; % [W]
Plow = [2.09, 2.62, 4.09]; % [W]
Pavg = (Phigh+Plow)./2;
err = (Phigh-Plow)./2;
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
%At = (20.1e-6).*(100e-6) % Real throat area
T0 = 50; % [C]
rho = 997;

i = 1;
for flow = Vdot
    [pc(i), Tvap(i)]=chamber_pressure(flow, At, Ra, Mw, y, T1, Lh, p1, rho);
    [Qdot(i)] = ideal_power(flow ,T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho); % Ideal power for vacuum pressure
    i = i + 1;
end
pc = pc./100000; % Converting pressure to bar

%% Sensor pressure
pc_r = [1.9e5, 2.6e5, 4.2e5];
mdot = Vdot./(3.6e9).*rho;
Tvap_r = T1.*Lh.*Mw./(T1.*Ra.*log(p1./pc_r)+Lh.*Mw);
Qdot_r = mdot.*(cpL.*(Tvap_r-(T0+273.15))+Lh);
pc_r = pc_r./1e5;
%% Plots:
% Change settings for text interpreter:
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter','latex')
%Colors:
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];

figure('DefaultAxesFontSize',18) % Tvap
subplot(1,2,1)
hold on
plot(Vdot, Tvap_r, 'o--', 'MarkerSize', 8, 'LineWidth', 1)
plot(Vdot, Tvap, 'x--', 'MarkerSize', 8, 'LineWidth', 1)
xlabel('$\dot{m}$ [ml/h]'); ylabel('$T_{vap}$ [K]'); grid on; title('BS2')
legend('ambient', 'vacuum', 'location', 'northwest')
subplot(1,2,2)
hold on
plot(Vdot, Qdot_r, 'o--', 'MarkerSize', 8, 'LineWidth', 1)
plot(Vdot, Qdot, 'x--', 'MarkerSize', 8, 'LineWidth', 1)
xlabel('$\dot{m}$ [ml/h]'); ylabel('$\dot{Q}$ [W]'); grid on; title('BS2')
legend('ambient', 'vacuum', 'location', 'northwest')

reset(groot)