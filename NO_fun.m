function [J] = NO_fun(u_pred)
% global N Nu k u y d y_zad lambda;

N = evalin("base", "N");
Nu = evalin("base", "Nu");
k = evalin("base", "k");
u = evalin("base", "u");
y = evalin("base", "y");
d = evalin("base", "d");
y_zad = evalin("base", "y_zad");
lambda = evalin("base", "lambda");

y_swob = zeros(N,1);
du_pred = zeros(Nu,1);
J = 0;

for i=1:N
    if i == 1
        q = [u(k-2);u(k-3);y(k);y(k-1)];   
    elseif i == 2
        q = [u(k-1);u(k-2);y_swob(i-1);y(k)];
    elseif i == 3
        q = [u_pred(i-2);u(k-1);y_swob(i-1);y(k)];                          % u(k|k) = u_pred(1) => u(k+a|k) = u_pred(i-(a-2))
    else
        q = [u_pred(min(i-2,Nu));u_pred(min(i-3,Nu));y_swob(i-1);y_swob(i-2)];
    end
    y_swob(i) = model(q) + d;
    J = J + (y_zad(k) - y_swob(i))^2;
end

for i=1:Nu
    if i == 1
        du_pred(i) = u_pred(i) - u(k-1);
    else 
        du_pred(i) = u_pred(i) - u_pred(i-1);
    end
    J = J + lambda*(du_pred(i)^2);
end



