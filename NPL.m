clear
dane()
N = 5;
Nu = 4;
lambda = 600;
delta = 0.00000005;

kp=5;
kk=2000;
y_zad(1:0.2*kk) = 0;
y_zad(0.2*kk:0.4*kk) = -1.5;
y_zad(0.4*kk:0.6*kk) = 0.5;
y_zad(0.6*kk:0.8*kk) = -0.5;
y_zad(0.8*kk:kk) = 0.2;

u = zeros(kk,1); x1 = zeros(kk,1); x2 = zeros(kk,1); g1 = zeros(kk,1); y = zeros(kk,1);


d = zeros(kk,1); y_mod = zeros(kk, 1); y_swob = zeros(N, kk); y_swob(1:kp-1) = y(1:kp-1);
f = zeros(kk,1); a_1 = zeros(kk,1); a_2 = zeros(kk,1); b_3 = zeros(kk,1); b_4 = zeros(kk,1);
s = zeros(N,kk); M = zeros(N, Nu, kk); K = zeros(Nu,N,kk); Y_zad = zeros(N,kk); dU = zeros(Nu,kk);
a = zeros(N,kk); b = zeros(N,kk);
E = 0;


for k=kp:kk
    % 1. pomiar wyjścia obiektu
    g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
    x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
    x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
    y(k) = 1-exp(-1.5*x1(k));

    % 2. obliczenie błędku modelu d(k)
    q = [u(k-3);u(k-4);y_mod(k-1);y_mod(k-2)];
    y_mod(k) = model(q);
    d(k) = y(k) - y_mod(k);

    % 3. obliczenie trajektorii swobodnej y_swob(k)
    for i = 1:N
        if i == 1
            q = [u(k-max(3-i,1));u(k-max(4-i,1));y(k);y(k-1)];
        elseif i == 2
            q = [u(k-max(3-i,1));u(k-max(4-i,1));y_swob(i-1,k);y(k)];
        else 
            q = [u(k-max(3-i,1));u(k-max(4-i,1));y_swob(i-1,k);y_swob(i-2,k)];
        end
        y_swob(i, k) = model(q) + d(k);
    end

    % 4. linearyzacja modelu sieci neuronowych b_3(k), b_4(k), a_1(k), a_2(k)
    q = [u(k-3);u(k-4);y(k-1);y(k-2)]; 
    f(k) = model(q);
    q = [u(k-3)+delta;u(k-4);y(k-1);y(k-2)];
    b_3(k) = (model(q)-f(k))/delta;
    q = [u(k-3);u(k-4)+delta;y(k-1);y(k-2)];
    b_4(k) = (model(q)-f(k))/delta;
    q = [u(k-3);u(k-4);y(k-1)+delta;y(k-2)];
    a_1(k) = -(model(q)-f(k))/delta;
    q = [u(k-3);u(k-4);y(k-1);y(k-2)+delta];
    a_2(k) = -(model(q)-f(k))/delta;

    % 5. obliczenie odpowiedzi skokowej
    for p = 1:N
        % liczenie sumy b
        for i = 1:min(p,4)
            if i == 3
                b(p,k) = b_3(k);
            elseif i == 4
                b(p,k) = b_3(k) + b_4(k);
            else
                b(p,k) = 0;
            end
        end

        % liczenie sumy a
        if p-1 == 1
            a(p,k) = a_1(k)*s(p-1,k);
        elseif min(p-1,2) == 2
            a(p,k) = a_1(k)*s(p-1,k) + a_2(k)*s(p-2,k);
        else
            a(p,k) = 0;
        end

        s(p,k) = b(p,k) - a(p,k);
    end
    
    % 6. obliczenie macierzy M(k)
    for i=1:N
        for j=1:Nu
            if i-j+1 > 0
                M(i,j,k) = s(i-j+1, k);
            else 
                M(i,j,k) = 0;
            end
        end
    end

    % 7. Obliczenie macierzy K(k)
    K(:,:,k) = ((M(:,:,k)' * M(:,:,k) + lambda * eye(Nu,Nu))^(-1))*M(:,:,k)';

    % 8. obliczenie wektora zmiennych decyzyjnych dU(k)
    Y_zad(:,k) = y_zad(k)*ones(N,1);
    dU(:,k) = K(:,:,k)*(Y_zad(:,k)-y_swob(:,k));

    % 9. ograniczenie sygnału u = przycięcie u

    % 10. u(k) = du(k|k) + u(k-1), gdzie du(k|k) to pierwszy element macierzy dU(k)
     u_chwilowe = dU(1,k) + u(k-1);
     if u_chwilowe > 1
         u(k) = 1;
     elseif u_chwilowe < -1
         u(k) = -1;
     else
         u(k) = u_chwilowe;
     end
end

figure
plot(y)
hold on
plot(y_zad)
