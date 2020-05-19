function [pc, Tvap]=chamber_pressure(Vdot, At, Ra, Mw, y, T1, Lh, p1, rho)
%Gelmi: calculates the chamber pressure pc [Pa] in vacuum at which massflow is Vdot [ml/h]
mdot = Vdot./(3.6e9).*rho; %converts mdot from ml/h to l/s ( equal to kg/s ) in case of water
syms x
f = 0 == mdot - ((x.*At.*sqrt(y.*((1+y)/2).^((y+1)/(1-y))))./sqrt(Ra./Mw.*(T1.*Lh.*Mw)./(Lh.*Mw+T1.*Ra.*log(p1/x))));
pc = vpasolve(f); %[Pa] finds the pressure pc for the given mdot
pc = double(pc); % changes data type for pc
Tvap = (T1.*Lh.*Mw)./(Lh.*Mw+T1.*Ra.*log(p1./pc)); %calculates Tvap in [K]
end