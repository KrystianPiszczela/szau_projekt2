clear
dane()
N=50;
Nu=40;
lambda=200;
delta = 1e-5;

% NPL: 
tryb = 1;

% GPC:
% tryb = 2;

kp=5;
kk=2000;
y_zad(1:0.2*kk) = 0;
y_zad(0.2*kk:0.4*kk) = -1.5;
y_zad(0.4*kk:0.6*kk) = 0.5;
y_zad(0.6*kk:0.8*kk) = -0.5;
y_zad(0.8*kk:kk) = 0.2;

u = zeros(kk,1); x1 = zeros(kk,1); x2 = zeros(kk,1); g1 = zeros(kk,1); y = zeros(kk,1);

y_mod = zeros(kk, 1); y_swob = zeros(N,1);
s = zeros(N,1); M = zeros(N, Nu); K = zeros(Nu,N); Y_zad = zeros(N,1); dU = zeros(Nu,1);
a = zeros(N,1); b = zeros(N,1);
E = 0;

if tryb == 2 % czyli GPC:
    disp('Jeszcze nie zrobione, sorka')
end


for k=kp:6
    k
    if tryb == 1 % czyli NPL:
        % 1. pomiar wyjścia obiektu
        g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
        x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
        x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
        y(k) = 1-exp(-1.5*x1(k));
    
        % 2. obliczenie błędku modelu d(k)
        q = [u(k-3);u(k-4);y_mod(k-1);y_mod(k-2)];
        y_mod(k) = model(q);
        d = y(k) - y_mod(k);
    
        % 3. obliczenie trajektorii swobodnej y_swob(k)
        for i = 1:N
            if i == 1
                q = [u(k-max(3-i,1));u(k-max(4-i,1));y(k);y(k-1)];
            elseif i == 2
                q = [u(k-max(3-i,1));u(k-max(4-i,1));y_swob(i-1);y(k)];
            else 
                q = [u(k-max(3-i,1));u(k-max(4-i,1));y_swob(i-1);y_swob(i-2)];
            end
            y_swob(i) = model(q);% + d;
            y_swob(i) = y_swob(i) + d;
        end
        y_swob
    
        % 4. linearyzacja modelu sieci neuronowych b_3(k), b_4(k), a_1(k), a_2(k)
        q = [u(k-3);u(k-4);y(k-1);y(k-2)]; 
        f = model(q);
        q = [u(k-3)+delta;u(k-4);y(k-1);y(k-2)];
        b_3 = (model(q)-f)/delta;
        q = [u(k-3);u(k-4)+delta;y(k-1);y(k-2)];
        b_4 = (model(q)-f)/delta;
        q = [u(k-3);u(k-4);y(k-1)+delta;y(k-2)];
        a_1 = -(model(q)-f)/delta;
        q = [u(k-3);u(k-4);y(k-1);y(k-2)+delta];
        a_2 = -(model(q)-f)/delta;
    
        % 5. obliczenie odpowiedzi skokowej
        for p = 1:N
            % liczenie sumy b
            if p == 3
                b(p) = b_3;
            elseif p >= 4
                b(p) = b_3 + b_4;
            else
                b(p) = 0;
            end
               
            % liczenie sumy a
            if p-1 == 1
                a(p) = a_1*s(p-1);
            elseif min(p-1,2) == 2
                a(p) = a_1*s(p-1) + a_2*s(p-2);
            else
                a(p) = 0;
            end
    
            s(p) = b(p) - a(p);
        end
        figure(1)
        plot(s)
        hold on
        plot(y_swob)
        hold off
        % 6. obliczenie macierzy M(k)
        for i=1:N
            for j=1:Nu
                if i-j+1 > 0
                    M(i,j) = s(i-j+1);
                else 
                    M(i,j) = 0;
                end
            end
        end
    
        % 7. Obliczenie macierzy K(k)
        K = (M' * M + lambda * eye(Nu,Nu))^(-1)*M';
    
        % 8. obliczenie wektora zmiennych decyzyjnych dU(k)
        Y_zad = y_zad(k)*ones(N,1);
        dU = K*(Y_zad-y_swob);
        dd(k)=dU(1);
        dU(1)
    
        % 9. ograniczenie sygnału u = przycięcie u
    
        % 10. u(k) = du(k|k) + u(k-1), gdzie du(k|k) to pierwszy element macierzy dU(k)
         u_chwilowe = dU(1) + u(k-1);
         if u_chwilowe > 1
             u(k) = 1;
         elseif u_chwilowe < -1
             u(k) = -1;
         else
             u(k) = u_chwilowe;
         end
         u(k)
   end % czyli część wspólna poniżej:
end

figure(2)
plot(y)
hold on
plot(y_zad)
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend('y','y_{zad}',Location='southeast');
title('Przebieg sygnału wyjściowego')
% print('wyniki/zad4/zad4_NPL_y.pdf','-dpng','-r400')

figure(3)
plot(u)
xlabel('Numer próbki k');
ylabel('Sygnał wejściowy u');
title('Przebieg sygnału sterującego')
% print('wyniki/zad4/zad4_NPL_u.pdf','-dpng','-r400')