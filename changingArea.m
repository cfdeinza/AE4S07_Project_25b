% Effect of changing throat area:
% The theoretical power has been calculated using Equation 5, plugging in
% the theoretical value of p_c calculted for each mass flow rate.
% T_0 was arbitrarily chosen at 50 deg C.
clear
At_d = 4.5e-9; % Design throat area
At_m = (20.1e-6).*(100e-6); % Real throat area
%fBS2(At_d)
[pc_d,Tvap_d,Pavg_d,Qdot_d,pcMax_d,QdotMax_d,PolAvg_d,PolT_d,n_data_d,pc_vec_d,n_vec_d] = fBS2(At_d);
[pc_m,Tvap_m,Pavg_m,Qdot_m,pcMax_m,QdotMax_m,PolAvg_m,PolT_m,n_data_m,pc_vec_m,n_vec_m] = fBS2(At_m);
%% Plots:
figure()
hold on
h1 = plot(pc_d, Pavg_d, 'bx');
plot([pc_d, pcMax_d], polyval(PolAvg_d, [pc_d, pcMax_d]), 'b--')
h2 = plot([pc_d, pcMax_d],[Qdot_d,QdotMax_d], 'b');
h3 = plot(pc_m, Pavg_m, 'rx');
plot([pc_m, pcMax_m], polyval(PolAvg_m, [pc_m, pcMax_m]), 'r--')
h4 = plot([pc_m, pcMax_m],[Qdot_m,QdotMax_m], 'r');
xlabel('$p_c$ [bar]'); ylabel('$\dot{Q}$ [W]'); grid on; title('BS2')
legend([h1,h2,h3,h4], 'Data $(A_{d})$', 'Ideal $(A_{d})$', 'Data $(A_{m})$',...
    'Ideal $(A_{m})$', 'location', 'southeast')

figure() % Efficiency
hold on
plot(pc_d, n_data_d, 'bx')
plot(pc_m, n_data_m, 'rx')
plot(pc_vec_d, n_vec_d, 'b')
plot(pc_vec_m, n_vec_m, 'r')
xlabel('$p_c$ [bar]'); ylabel('$\eta$ [-]'); grid on; title('BS2 Efficiency')
legend('$A_{design}$', '$A_{measured}$', 'location', 'southeast')

figure('DefaultAxesFontSize',18) % pc as a function of mass flow
hold on
plot([0.5, 1, 2], pc_m, 'bo--', 'MarkerSize', 8, 'LineWidth', 1)
plot([0.5, 1, 2], pc_d, 'rx--', 'MarkerSize', 8, 'LineWidth', 1)
xlabel('$\dot{m}$ [ml/h]'); ylabel('$p_c$ [bar]'); grid on; title('BS2')
legend('Using $A^*_{eff}$', 'Using $A^*_{design}$', 'location', 'northwest')

figure() % Ideal power as a function of mass flow
hold on
plot([0.5, 1, 2], Qdot_d, 'b')
plot([0.5, 1, 2], Qdot_m, 'r')
xlabel('$\dot{m}$ [ml/h]'); ylabel('$\dot{Q}$ [W]'); grid on; title('BS2')