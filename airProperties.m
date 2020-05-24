function [Polrho, Polbeta, Polc, Polk, Polmu] = airProperties()
% Find relations for air properties:
clear
T = [0:20:100, 125:25:200]+273;
rho = [1.292, 1.204, 1.127, 1.060, 1.000,0.9467, 0.8868, 0.8338, 0.7868, 0.7451];
beta = [3.69, 3.43, 3.21, 3.02, 2.85, 2.70,2.51, 2.33, 2.22, 2.10].*1e-3;
Polrho = polyfit(T,rho,2);
Polbeta = polyfit(T,beta,2);

T2 = [0:20:200]+273;
c = [1006,1007,1007,1007,1008,1009,1011,1013,1016,1019,1023];
k = [0.02364,0.02514,0.02662,0.02808,0.02953,0.03095,0.03235,0.03374,...
    0.03511,0.03646,0.03779];
mu = [1.729,1.825,1.918,2.008,2.096,2.181,2.264,2.345,2.420,2.504,2.577].*1e-5;
Polc = polyfit(T2,c,2); % Not great
Polk = polyfit(T2,k,2);
Polmu = polyfit(T2,mu,2);

% figure()
% subplot(1,2,1)
% hold on
% plot(T-273, rho, 'x')
% plot(T-273, polyval(Polrho,T))
% xlabel('Temp [C]'); ylabel('\rho [kg/m^3]'); grid on; title('Density')
% subplot(1,2,2)
% hold on
% plot(T-273, beta, 'x')
% plot(T-273, polyval(Polbeta,T))
% xlabel('Temp [C]'); ylabel('\beta [-]'); grid on; title('Thermal expansion coeff.')
% 
% figure()
% subplot(1,3,1)
% hold on
% plot(T2-273, c, 'x')
% plot(T2-273, polyval(Polc,T2))
% xlabel('Temp [C]'); ylabel('c [J/kg.K]'); grid on; title('Specific heat')
% subplot(1,3,2)
% hold on
% plot(T2-273, k, 'x')
% plot(T2-273, polyval(Polk,T2))
% xlabel('Temp [C]'); ylabel('k [W/m.K]'); grid on; title('Thermal conductivity')
% subplot(1,3,3)
% hold on
% plot(T2-273, mu, 'x')
% plot(T2-273, polyval(Polmu,T2))
% xlabel('Temp [C]'); ylabel('\mu [kg/m.s]'); grid on; title('Dynamic viscosity')