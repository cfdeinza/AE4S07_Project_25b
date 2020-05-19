% This script plots the experimental results and calculates the linear
% approximations and power efficiencies.

clear
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
T0 = 50; % [C]
rho = 997;

load thrusters.mat
%BS2:
BVdot = BS2.Vdot;       % Flow rate [ml/h]
BPavg = BS2.P;          % Measured power [W]
% Calculate chamber pressure and temperature:
for i = 1:length(BVdot)
    [Bpc(i), Tvap(i)]=chamber_pressure(BVdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
end
Bpc = Bpc./100000; % Convert pressure to bar
VdotMax = 2.8; % [ml/h] from Gelmi Table 4
[pcMax, TvapMax]=chamber_pressure(VdotMax, At, Ra, Mw, y, T1, Lh, p1, rho);
pcMax = pcMax./100000;
[QdotMax] = ideal_power(VdotMax, T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho);
%Ld1:
LVdot = Ld1.Vdot;       % Flow rate [ml/h]
LPavg = Ld1.P;          % Measured power [W]
% Calculate chamber pressure and temperature:
for i = 1:length(LVdot)
    [Lpc(i), Tvap(i)]=chamber_pressure(LVdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
end
Lpc = Lpc./100000; % Convert pressure to bar
%Ws1:
WVdot = Ws1.Vdot;       % Flow rate [ml/h]
WPavg = Ws1.P;          % Measured power [W]
% Calculate chamber pressure and temperature:
for i = 1:length(WVdot)
    [Wpc(i), Tvap(i)]=chamber_pressure(WVdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
end
Wpc = Wpc./100000; % Converting pressure to bar
% Ideal:
IVdot = [0.5, 1, 1.5, 2]; % [ml/h]
% Calculate ideal power required:
for i = 1:length(IVdot)
    [Ipc(i), Tvap(i)]=chamber_pressure(IVdot(i), At, Ra, Mw, y, T1, Lh, p1, rho);
    [Qdot(i)] = ideal_power(IVdot(i), T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho); % Ideal power for vacuum pressure
end
mdot = IVdot./(3.6e9).*rho; % Calculate mass flow [kg/s]
Ateff = (0.5*(20.1+26.0).*1e-6).*(100e-6); % Effective throat area
mdotNew = ((Ipc.*Ateff.*sqrt(y.*((1+y)/2).^((y+1)/(1-y))))./...
    sqrt(Ra./Mw.*(T1.*Lh.*Mw)./(Lh.*Mw+T1.*Ra.*log(p1./Ipc))));
VdotNew = mdotNew.*(3.6e9)./rho;
QdotNew = mdotNew.*(cpL.*(Tvap-(T0+273.15))+Lh);
Ipc = Ipc./100000;
% Polynomials describing linear approximations:
BPol = polyfit(Bpc,BPavg,1);
LPol = polyfit(Lpc,LPavg,1);
WPol = polyfit(Wpc,WPavg,1);
IPol = polyfit(Ipc,Qdot,1);
% R^2 values:
BR2 = determination(BPavg, polyval(BPol,Bpc));
LR2 = determination(LPavg, polyval(LPol,Lpc));
WR2 = determination(WPavg, polyval(WPol,Wpc));
IR2 = determination(Qdot, polyval(IPol,Ipc));
% Power consumption efficiency:
Bn_data = Qdot([1,2,4])./BPavg;
Bpc_vec = Bpc(1):0.001:pcMax;
Bn_vec = (IPol(1).*Bpc_vec + IPol(2))./(BPol(1).*Bpc_vec + BPol(2));
Ln_data = Qdot([1,2,4])./LPavg;
Lpc_vec = Lpc(1):0.001:pcMax;
Ln_vec = (IPol(1).*Lpc_vec + IPol(2))./(LPol(1).*Lpc_vec + LPol(2));
Wn_data = Qdot([1,2,3])./WPavg;
Wpc_vec = Wpc(1):0.001:pcMax;
Wn_vec = (IPol(1).*Wpc_vec + IPol(2))./(WPol(1).*Wpc_vec + WPol(2));

%% Plots:
%{
%reset(groot)
% Change settings for text interpreter:
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter','latex')
%}
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];
green = [0.4660, 0.6740, 0.1880];

figure('DefaultAxesFontSize',14) % Just data points
hold on
B=plot(Bpc, BPavg, 'x', 'Color', blue, 'MarkerSize', 10, 'LineWidth', 1.5);
%errorbar(Bpc,BPavg,Berr, 'Color', blue, 'LineStyle', 'none')
L=plot(Lpc, LPavg, 'o', 'Color', red, 'MarkerSize', 10, 'LineWidth', 1.5);
%errorbar(Lpc,LPavg,Lerr, 'Color', red, 'LineStyle', 'none')
W=plot(Wpc, WPavg, '*', 'Color', green, 'MarkerSize', 10, 'LineWidth', 1.5);
%errorbar(Wpc,WPavg,Werr, 'Color', green, 'LineStyle', 'none')
I=plot(Ipc, Qdot, '+', 'Color', yellow, 'MarkerSize', 10, 'LineWidth', 1.5);
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on;
legend([B,L,W,I], 'BS2', 'Ld1', 'Ws1', 'Ideal', 'location', 'northwest')


figure('DefaultAxesFontSize',14) % Linear approx (all together)
hold on
B=plot(Bpc, BPavg, 'x', 'Color', blue, 'MarkerSize', 10, 'LineWidth', 1.5);
Blin=plot(Bpc, polyval(BPol, Bpc), 'Color', blue, 'LineWidth', 1);
%errorbar(Bpc,BPavg,Berr, 'Color', blue, 'LineStyle', 'none')
L=plot(Lpc, LPavg, 'o', 'Color', red, 'MarkerSize', 10, 'LineWidth', 1.5);
Llin=plot(Lpc, polyval(LPol, Lpc), 'Color', red, 'LineWidth', 1);
%errorbar(Lpc,LPavg,Lerr, 'Color', red, 'LineStyle', 'none')
W=plot(Wpc, WPavg, '*', 'Color', green, 'MarkerSize', 10, 'LineWidth', 1.5);
Wlin=plot(Wpc, polyval(WPol, Wpc), 'Color', green, 'LineWidth', 1);
%errorbar(Wpc,WPavg,Werr, 'Color', green, 'LineStyle', 'none')
I=plot(Ipc, Qdot, '+', 'Color', yellow, 'MarkerSize', 10, 'LineWidth', 1.5);
Ilin=plot(Ipc, polyval(IPol, Ipc), 'Color', yellow, 'LineWidth', 1);
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on;
legend([Blin,Llin,Wlin,Ilin], 'BS2 linear approx.', 'Ld1 linear approx.',...
    'Ws1 linear approx.', 'Ideal linear approx.', 'location', 'northwest')


figure('DefaultAxesFontSize',14) % Efficiency
subplot(1,3,1)
hold on
B=plot(Bpc_vec, Bn_vec, 'Color', blue);
plot(Bpc, Bn_data, 'x', 'Color', blue, 'MarkerSize', 10, 'LineWidth', 1.5)
xlabel('$p_c$ [bar]'); ylabel('$\eta$ [-]'); grid on; title('BS2')
subplot(1,3,2)
hold on
L=plot(Lpc_vec, Ln_vec, 'Color', red);
plot(Lpc, Ln_data, 'o', 'Color', red, 'MarkerSize', 10, 'LineWidth', 1.5)
xlabel('$p_c$ [bar]'); ylabel('$\eta$ [-]'); grid on; title('Ld1')
subplot(1,3,3)
hold on
W=plot(Wpc_vec, Wn_vec, 'Color', green);
plot(Wpc, Wn_data, '*', 'Color', green, 'MarkerSize', 10, 'LineWidth', 1.5)
xlabel('$p_c$ [bar]'); ylabel('$\eta$ [-]'); grid on; title('Ws1')

%{
% Old figures:
figure('DefaultAxesFontSize',14) % Changes due to effective A*
subplot(1,2,1)
hold on
plot(Ipc, IVdot, 'x--', 'Color', red, 'MarkerSize', 8, 'LineWidth', 1)
plot(Ipc, VdotNew, 'o--', 'Color', blue, 'MarkerSize', 8, 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('$\dot{m}$ [ml/h]'); grid on;
legend('$A^*_{design}$', '$A^*_{eff}$', 'location', 'northwest')
subplot(1,2,2)
hold on
plot(Ipc, Qdot, 'x--', 'Color', red, 'MarkerSize', 8, 'LineWidth', 1)
plot(Ipc, QdotNew, 'o--', 'Color', blue, 'MarkerSize', 8, 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('$\dot{Q}_{id}$ [W]'); grid on;
legend('$A^*_{design}$', '$A^*_{eff}$', 'location', 'northwest')

figure() % Linear approx subplots
subplot(1,3,1)
hold on
plot(Bpc, BPavg, 'x', 'Color', blue, 'MarkerSize', 10, 'LineWidth', 1.5);
Blin=plot(Bpc, polyval(BPol, Bpc), 'Color', blue);
plot(Ipc, Qdot, '+', 'Color', yellow, 'MarkerSize', 10, 'LineWidth', 1.5);
Ilin=plot(Ipc, polyval(IPol, Ipc), 'Color', yellow);
errorbar(Bpc,BPavg,Berr, 'k', 'LineStyle', 'none')
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on; title('BS2')
legend([Blin, Ilin], '$\dot{Q}_m$ linear fit', '$\dot{Q}_{id}$ linear fit',...
    'location', 'northwest')
subplot(1,3,2)
hold on
plot(Lpc, LPavg, 'o', 'Color', red, 'MarkerSize', 10, 'LineWidth', 1.5);
Llin=plot(Lpc, polyval(LPol, Lpc), 'Color', red);
plot(Ipc, Qdot, '+', 'Color', yellow, 'MarkerSize', 10, 'LineWidth', 1.5);
Ilin=plot(Ipc, polyval(IPol, Ipc), 'Color', yellow);
errorbar(Lpc,LPavg,Lerr, 'k', 'LineStyle', 'none')
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on; title('Ld1')
legend([Llin, Ilin], '$\dot{Q}_m$ linear fit', '$\dot{Q}_{id}$ linear fit',...
    'location', 'northwest')
subplot(1,3,3)
hold on
plot(Wpc, WPavg, '*', 'Color', green, 'MarkerSize', 10, 'LineWidth', 1.5);
Wlin=plot(Wpc, polyval(WPol, Wpc), 'Color', green);
plot(Ipc, Qdot, '+', 'Color', yellow, 'MarkerSize', 10, 'LineWidth', 1.5);
Ilin=plot(Ipc, polyval(IPol, Ipc), 'Color', yellow);
errorbar(Wpc,WPavg,Werr, 'k', 'LineStyle', 'none')
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on; title('Ws1'); ylim([0,4.5])
legend([Wlin, Ilin], '$\dot{Q}_m$ linear fit', '$\dot{Q}_{id}$ linear fit',...
    'location', 'northwest')
%}
function [R2] = determination(yi, fi)
ei = yi - fi;
ybar = sum(yi)./length(yi);
SStot = sum((yi-ybar).^2);
SSres = sum(ei.^2);
R2 = 1 - SSres./SStot;
end