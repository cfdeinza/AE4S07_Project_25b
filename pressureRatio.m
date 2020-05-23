function [prat] = pressureRatio(Arat, y)
G = sqrt(y.*((1+y)./2).^((1+y)./(1-y))); % Vandenkerckhove function
syms prat
eqn = Arat == G./sqrt(2.*y./(y-1).*prat.^(2./y).*(1-prat.^((y-1)./y)));
S = vpasolve([eqn], [prat], [0.001, 0.5]);
prat = double(S);

% figure()
% p_range = [0.001:0.0001:0.5];
% plot(p_range, G./sqrt(2.*y./(y-1).*p_range.^(2./y).*(1-p_range.^((y-1)./y))));
% hold on
% plot([p_range(1), p_range(end)], [Arat, Arat])
% xlabel('$p_e/p_c$'); ylabel('$A_e/A_t$'); grid on; title('Checking $p_e/p_c$')
end