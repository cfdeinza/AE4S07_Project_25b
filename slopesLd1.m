% Ld1:
clear
Vdot = [0.5, 1, 2]; % [ml/h]
Phigh = [2.65, 3.30, 4.42]; % [W]
Plow = [2.55, 3.08, 4.23]; % [W]
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
% Real throat width is 25.1 +/- 3.5 microns. (Silva Table 6)
%At = (20.1e-6).*(100e-6) % Real throat area
T0 = 50; % [C]
rho = 997;

i = 1;
for flow = Vdot
    [pc(i), Tvap(i)]=chamber_pressure(flow, At, Ra, Mw, y, T1, Lh, p1, rho);
    [Qdot(i)] = ideal_power(flow ,T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho);
    i = i + 1;
end
pc = pc./100000; % Converting pressure to bar
VdotMax = 2.8; % [ml/h] from Gelmi Table 4
[pcMax, TvapMax]=chamber_pressure(VdotMax, At, Ra, Mw, y, T1, Lh, p1, rho);
pcMax = pcMax./100000;
[QdotMax] = ideal_power(VdotMax, T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho);
PolMin = polyfit([pc(1), pc(end)], [Phigh(1), Plow(end)], 1); % Min slope polynomial
PolAvg = polyfit(pc, Pavg, 1); % Average slope polynomial
PolMax = polyfit([pc(1), pc(end)], [Plow(1), Phigh(end)], 1); % Max slope polynomial
PolT = polyfit([pc, pcMax], [Qdot, QdotMax], 1); % Theoretical power polynomial
% Power consumption efficiency:
n_data = Qdot./Pavg;
pc_vec = pc(1):0.01:pc(end);
n_vec = (PolT(1).*pc_vec + PolT(2))./(PolAvg(1).*pc_vec + PolAvg(2));
%n_err = n_data.*err./Pavg;
n_err = n_data.*sqrt((err./Pavg).^2 + ((Qdot-polyval(PolT,pc))./Qdot).^2);
slopes = {'ExpMin', 'ExpAvg', 'ExpMax', 'Theory';...
    PolMin(1), PolAvg(1), PolMax(1), PolT(1)}; % W/bar
% Result: Both the min and max slope are larger than the theoretical slope.

%% Plots:

% Change settings for text interpreter:
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter','latex')
% Colors:
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
yellow = [0.9290, 0.6940, 0.1250];

figure('DefaultAxesFontSize',18) % Slopes (vacuum pressure)
hold on
zdata = plot(pc,Pavg, 'kx');
zmin = plot([pc, pcMax], polyval(PolMin, [pc, pcMax]), 'Color', blue);
%zavg = plot([pc, pcMax], polyval(PolAvg, [pc, pcMax]), '--');
zmax = plot([pc, pcMax], polyval(PolMax, [pc, pcMax]), 'Color', red);
zerror = errorbar(pc,Pavg,err, 'k', 'LineStyle', 'none', 'LineWidth', 1);
plot(pc, Qdot, 'x', 'LineWidth', 1, 'Color', yellow);
zt = plot([pc, pcMax],[Qdot,QdotMax], 'LineWidth', 1, 'Color', yellow);
xlabel('$p_c\;[bar]$'); ylabel('$\dot{Q}\;[W]$'); grid on; title('Ld1')
legend([zdata,zerror,zmin,zmax,zt], 'Experimental data', 'Error',...
    'Minimum slope', 'Maximum slope', 'Ideal', 'location', 'northwest')

reset(groot)