% This script generates a figure showing the heat losses for each thruster.
clear
load thrusters.mat
%BS2:
BVdot = BS2.Vdot;       % Flow rate [ml/h]
BPavg = BS2.P;          % Measured power [W]
BTs = [48, 49, 58]+273; % Assumed surface temp [K]
%Ld1:
LVdot = Ld1.Vdot;       % Flow rate [ml/h]
LPavg = Ld1.P;          % Measured power [W]
LTs = [49, 50, 55]+273; % Assumed surface temp [K]
%Ws1:
WVdot = Ws1.Vdot;       % Flow rate [ml/h]
WPavg = Ws1.P;          % Measured power [W]
WTs = [47, 45, 46]+273; % Assumed surface temp [K]

% Calculate heat losses:
[Bpc, BQdot, BQcond, BQconv, BQrad] = heatLossUniform(BVdot, BPavg, BTs);
[Lpc, LQdot, LQcond, LQconv, LQrad] = heatLossUniform(LVdot, LPavg, LTs);
[Wpc, WQdot, WQcond, WQconv, WQrad] = heatLossUniform(WVdot, WPavg, WTs);

% Plot:

% Change settings for text interpreter:
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter','latex')

figure('DefaultAxesFontSize',14)
subplot(1,3,1)
hold on
plot(Bpc, BPavg, 'x-', 'LineWidth', 1)
plot(Bpc, BQcond, 'o--', 'LineWidth', 1)
plot(Bpc, BQdot, 'x--', 'LineWidth', 1)
plot(Bpc, BQconv, '^--', 'LineWidth', 1)
plot(Bpc, BQrad, '*--', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('Power [W]'); grid on; title('BS2')
legend('$Q_{elec}$', '$Q_{cond}$', '$Q_{id}$', '$Q_{conv}$', '$Q_{rad}$',...
    'location', 'northwest')
subplot(1,3,2)
hold on
plot(Lpc, LPavg, 'x-', 'LineWidth', 1)
plot(Lpc, LQcond, 'o--', 'LineWidth', 1)
plot(Lpc, LQdot, 'x--', 'LineWidth', 1)
plot(Lpc, LQconv, '^--', 'LineWidth', 1)
plot(Lpc, LQrad, '*--', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('Power [W]'); grid on; title('Ld1')
legend('$Q_{elec}$', '$Q_{cond}$', '$Q_{id}$', '$Q_{conv}$', '$Q_{rad}$',...
    'location', 'northwest')
subplot(1,3,3)
hold on
plot(Wpc, WPavg, 'x-', 'LineWidth', 1)
plot(Wpc, WQcond, 'o--', 'LineWidth', 1)
plot(Wpc, WQdot, 'x--', 'LineWidth', 1)
plot(Wpc, WQconv, '^--', 'LineWidth', 1)
plot(Wpc, WQrad, '*--', 'LineWidth', 1)
xlabel('$p_c$ [bar]'); ylabel('Power [W]'); grid on; title('Ws2')
legend('$Q_{elec}$', '$Q_{cond}$', '$Q_{id}$', '$Q_{conv}$', '$Q_{rad}$',...
    'location', 'northwest')

reset(groot) % Reset text interpreter