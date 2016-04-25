% single peak Lorentz profile

function y = Single_Lorentz_fun(p,x)

y = zeros(length(x),2); % allocate yout
% p(1): a1, p(2): w, p(3): theta, p(4): x0, p(5): a2
y(:,1) = p(1)*(p(2)*cos(p(3))+(x-p(4))*sin(p(3)))./(p(2)^2+(x-p(4)).^2)+p(6)+p(7)*x+p(8)*x.^2;

y(:,2) = p(5)*(p(2)*cos(p(3)+pi/2)+(x-p(4))*sin(p(3)+pi/2))./(p(2)^2+(x-p(4)).^2)+p(9)+p(10)*x+p(11)*x.^2;

end