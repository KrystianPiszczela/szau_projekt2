clear
dane()

%% Parametry zadania
Upp = 0;
Ypp = 0;
Tp = 1;

%% Parametry regulatora PID
%Ziegler-Nichols - wzmocnienie krytyczne
% Kp = 4.2;
% Ti = inf;
% Td = 0;

%Ziegler-Nichols
Tu = 17; Ku = 4.2;
Kp = 0.6*Ku;
Ti = Tu/2;
Td = Tu/8;

%% Wyznaczone wartości r1,r2,r0
r1 = Kp*((Tp/(2*Ti))-2*(Td/Tp)-1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti))+(Td/Tp));

%% Inicjalizacja wektorów
kp = 4;
kk = 1000;
u(1:kk) = Upp;
y(1:kk) = Ypp;
e(1:kk) = 0;
g1(1:kk) = 0;
x1(1:kk) = 0;
x2(1:kk) = 0;

%% Przykładowe wartości zadanej yzad
yzad(1:0.2*kk) = 0;
yzad(0.2*kk:0.4*kk) = -1.5;
yzad(0.4*kk:0.6*kk) = 0.5;
yzad(0.6*kk:0.8*kk) = -0.5;
yzad(0.8*kk:kk) = 0.2;

%% Pętla regulatora
for k=kp:kk
    g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
    x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
    x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
    y(k) = 1-exp(-1.5*x1(k));
    e(k) = yzad(k)-y(k);
    u(k) = r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
    
    % Sprawdzenie czy U znajduje się w przedziale, ew. ścięcie
    u(k) = max(min(u(k),u_max),u_min);
end

%% Przygotowanie wykresów i wizualizacja
t = linspace(1,kk,kk);
figure
stairs(t,u,'LineWidth',1.5, Color='r');
title('u - sterowanie');
xlabel('k - number próbki');
ylabel("Wartość sterowania")
% matlab2tikz ('zad4PID_u.tex' , 'showInfo' , false)

figure
stairs(t,y,'LineWidth',1.5);
hold on;
stairs(t,yzad,'LineWidth',1, 'LineStyle','--');
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend("y", "y_{zad}",Location="southeast")
print('wyniki/zad5/pid2.pdf','-dpng','-r400')
% matlab2tikz ('zad4PID_y.tex' , 'showInfo' , false)