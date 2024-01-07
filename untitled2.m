clear
kk=200;
u(1:50) = 0;
u(50:kk) = 1;
dane()

x1 = zeros(kk,1);
x2 = zeros(kk,1);
f = zeros(kk,1);
g1 = zeros(kk,1);
y = zeros(kk,1);

for k=5:200
    g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
    x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
    x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
    y(k) = 1-exp(-1.5*x1(k));

    q = [u(k-3);u(k-4);y(k-1);y(k-2)]; 
    f(k) = model(q);
end
close all
plot(f)
hold on
plot(y)
legend('model','symulacja procesu')