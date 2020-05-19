function [Qdot] = ideal_power(Vdot ,T0, At, Ra, Mw, y, cpL, Lh, T1, p1, rho)
%Gelmi: calculates the ideal power input Qdot [W] and the vaporization
%temperature Tvap [K] as a function of the mass flow Vdot [ml/h] and the
%chamber temperature Tc
mdot = Vdot./(3.6e9).*rho; %converts mdot from ml/h to l /s ( equal to kg/s ) in case of water
[pc, Tvap] = chamber_pressure(Vdot, At, Ra, Mw, y, T1, Lh, p1, rho); %calculates the chamber pressure in vacuum and Tvap
Qdot = mdot.*(cpL.*(Tvap-(T0+273.15))+Lh); %calculates Qdot [W]
G = sqrt(y.*((1+y)./2).^((1+y)./(1-y)));
%Qdotme = pc.*At.*G./sqrt(Ra./Mw.*Tvap).*(cpL.*(Tvap-(T0+273.15)) + Lh); %My method (same result)
end