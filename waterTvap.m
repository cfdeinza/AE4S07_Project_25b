function [Tvap] = waterTvap(pc)
Lh = 2256e3; % Heat of vaporization of water [J/kg]
Ra = 8.314; % Universal gas constant [J/(mol.K)]
Mw = 0.01801528; % Molar mass of water [kg/mol]
p1 = 101325; % Reference pressure to calculate Tvap [Pa]
T1 = 373.15; % Boiling temp of water at p1 (used to calculate Tvap) [K]
Tvap = (T1.*Lh.*Mw)./(Lh.*Mw+T1.*Ra.*log(p1./pc));
end