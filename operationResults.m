% This script shows the results of the simulation.
clear
load thrusters.mat
Vrat = 0.25; % Ratio of tank occupied by pressurant (assumed)
[pcB,TvapB,VdotB,mdotB,QB,FB,VgB,VpB,tvecB,IB] = operation(BS2, Vrat);%0.23
[pcL,TvapL,VdotL,mdotL,QL,FL,VgL,VpL,tvecL,IL] = operation(Ld1, Vrat);%0.25
[pcW,TvapW,VdotW,mdotW,QW,FW,VgW,VpW,tvecW,IW] = operation(Ws1, Vrat);%0.2

Fmax = 3e-3;    % Maximum allowed thrust [N]
Fmin = 0.12e-3; % Minimum thrust [N]

% Corrected thrust:
g0 = 9.81; % [m/s]
% IspB = 3.79947.*sqrt(TvapB) + 8.116;
% IspL = 3.79947.*sqrt(TvapL) + 8.116;
% IspW = 3.79947.*sqrt(TvapW) + 8.116;
IspB = 94.9./sqrt(550).*sqrt(TvapB);
IspL = 94.9./sqrt(550).*sqrt(TvapL);
IspW = 94.9./sqrt(550).*sqrt(TvapW);
FcorB = mdotB.*g0.*IspB;
FcorL = mdotL.*g0.*IspL;
FcorW = mdotW.*g0.*IspW;

%% Plots:
set(0, 'DefaultLineLineWidth', 1)
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter','latex')

figure('DefaultAxesFontSize',14)
subplot(2,3,1)
hold on
plot(tvecB, pcB./1e5)
plot(tvecL, pcL./1e5)
plot(tvecW, pcW./1e5)
xlabel('time [s]'); ylabel('$p_c$ [bar]'); grid on;
title('\textbf{\textit{Chamber pressure:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1')
subplot(2,3,2)
hold on
plot(tvecB, QB)
plot(tvecL, QL)
plot(tvecW, QW)
xlabel('time [s]'); ylabel('$\dot{Q}$ [W]'); grid on;
title('\textbf{\textit{Required power:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1')
subplot(2,3,3)
hold on
plot(tvecB, FB.*1e3)
plot(tvecL, FL.*1e3)
plot(tvecW, FW.*1e3)
plot([0, max([tvecB,tvecL,tvecW])], [Fmin, Fmin].*1e3, 'k--')
xlabel('time [s]'); ylabel('$F_{id}$ [mN]'); grid on;
title('\textbf{\textit{Ideal thrust:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1', 'min')
subplot(2,3,4)
hold on
plot(tvecB, VpB.*1e6)
plot(tvecL, VpL.*1e6)
plot(tvecW, VpW.*1e6)
plot([0,max([tvecB,tvecL,tvecW])], [VpL(1)+VgL(1), VpL(end)+VgL(end)].*1e6, 'k--')
xlabel('time [s]'); ylabel('$V$ [mL]'); grid on;
title('\textbf{\textit{Propellant volume:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1', 'Tank')
subplot(2,3,5)
hold on
plot(tvecB, VdotB.*3.6e9)
plot(tvecL, VdotL.*3.6e9)
plot(tvecW, VdotW.*3.6e9)
xlabel('time [s]'); ylabel('$\dot{m}$ [ml/h]'); grid on;
title('\textbf{\textit{Flow rate:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1')
subplot(2,3,6)
hold on
plot(tvecB, IB)
plot(tvecL, IL)
plot(tvecW, IW)
xlabel('time [s]'); ylabel('I [N.s]'); grid on;
title('\textbf{\textit{Total impulse:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1', 'location', 'southeast')

figure('DefaultAxesFontSize',14) % Corrected thrust
subplot(1,3,1)
hold on
plot(tvecB, TvapB)
plot(tvecL, TvapL)
plot(tvecW, TvapW)
xlabel('Time [s]'); ylabel('$T_c$ [K]'); grid on;
title('\textbf{\textit{Chamber temperature:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1')
subplot(1,3,2)
hold on
plot(tvecB, IspB)
plot(tvecL, IspL)
plot(tvecW, IspW)
xlabel('Time [s]'); ylabel('$I_{sp}$ [s]'); grid on;
title('\textbf{\textit{Specific Impulse:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1')
subplot(1,3,3)
hold on
plot(tvecB, FcorB.*1e3)
plot(tvecL, FcorL.*1e3)
plot(tvecW, FcorW.*1e3)
plot([0, max([tvecB,tvecL,tvecW])], [Fmin, Fmin].*1e3, 'k--')
xlabel('Time [s]'); ylabel('$F$ [mN]'); grid on;
title('\textbf{\textit{Thrust:}}', 'FontSize', 16)
legend('BS2', 'Ld1', 'Ws1', 'min')
%{
figure() % Tank
hold on
plot(tvec, Vp.*1e6)
plot(tvec, Vg.*1e6)
plot([tvec(1), tvec(end)], [Vtube, Vtube].*1e6, '--')
xlabel('Time [s]'); ylabel('$V$ [mL]'); grid on; title('Tank volume')
legend('Propellant', 'Pressurant', 'Total'); ylim([0, ceil(Vtube)])
%}