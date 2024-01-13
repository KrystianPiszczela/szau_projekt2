clear
dane()
Upp = 0;
Ypp = 0;
Tp = 1;


%% Wybór regulatora
%%  NPL: 1, GPC: 2, PID: 3, NO: 4
% tryb = 1;
% tryb = 2;
tryb = 3;
% tryb = 4;

%% Parametry regulatorów
% NPL i GPC:
N=18; Nu=6; lambda=0.75; delta = 1e-5;

% PID - metoda Zieglera Nicholsa:
Tu = 17; Ku = 4.2; Kp = 0.6*Ku; Ti = Tu/2; Td = Tu/8;
% Wyznaczenie wartości r1,r2,r0
r1 = Kp*((Tp/(2*Ti))-2*(Td/Tp)-1);
r2 = Kp*Td/Tp;
r0 = Kp*(1+(Tp/(2*Ti))+(Td/Tp));


kp=5;
kk=1000;
y_zad(1:0.2*kk) = 0;
y_zad(0.2*kk:0.4*kk) = -1.5;
y_zad(0.4*kk:0.6*kk) = 0.5;
y_zad(0.6*kk:0.8*kk) = -0.5;
y_zad(0.8*kk:kk) = 0.2;

u = zeros(kk,1); x1 = zeros(kk,1); x2 = zeros(kk,1); g1 = zeros(kk,1); y = zeros(kk,1); e(1:kk) = 0;

y_mod = zeros(kk, 1); y_swob = zeros(N,1);
s = zeros(N,1); M = zeros(N, Nu); K = zeros(Nu,N); Y_zad = zeros(N,1); dU = zeros(Nu,1);
a = zeros(N,1); b = zeros(N,1);
E = 0;

tic
if tryb == 2 % czyli GPC:
    % 1. obliczenie odpowiedzi skokowej s1, ..., sN
    w = load('wyniki/zad2/2_8_wsp_kwadraty.txt');
    b_3 = w(1); b_4 = w(2); a_1 = w(3); a_2 = w(4); 

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
            a(p) = a_1*s(p-1) + a_2*s(p-1);
        else
            a(p) = 0;
        end

        s(p) = b(p) - a(p);
    end

    % 2. obliczenie macierzy M
    for i=1:N
        for j=1:Nu
            if i-j+1 > 0
                M(i,j) = s(i-j+1);
            else 
                M(i,j) = 0;
            end
        end
    end

    % 3. obliczenie macierzy K
    K = (M' * M + lambda * eye(Nu,Nu))^(-1)*M';
end

if tryb == 1 || tryb == 2 || tryb == 4 % 1=NPL, 2=GPC, 4=NO
    for k=kp:kk
        % 1. pomiar wyjścia obiektu -- GPC, NPL i NO
        g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
        x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
        x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
        y(k) = 1-exp(-1.5*x1(k));
    
        % 2. obliczenie błędku modelu d(k) -- GPC, NPL i NO
        q = [u(k-3);u(k-4);y(k-1);y(k-2)];
        y_mod(k) = model(q);
        d = y(k) - y_mod(k);
    
        if tryb == 1 || tryb == 2
            % 3. obliczenie trajektorii swobodnej y_swob(k) -- GPC i NPL
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
            % y_swob
        end
    
        if tryb == 1 % czyli NPL:
            % 4. linearyzacja modelu sieci neuronowych b_3(k), b_4(k), a_1(k), a_2(k) -- tylko NPL
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
    
            % 5. obliczenie odpowiedzi skokowej -- tylko NPL
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
            % figure(1)
            % plot(s)
            % hold on
            % plot(y_swob)
            % hold off
    
            % 6. obliczenie macierzy M(k) -- tylko NPL
            for i=1:N
                for j=1:Nu
                    if i-j+1 > 0
                        M(i,j) = s(i-j+1);
                    else 
                        M(i,j) = 0;
                    end
                end
            end
        
            % 7. Obliczenie macierzy K(k) -- tylko NPL
            K = (M' * M + lambda * eye(Nu,Nu))^(-1)*M';
       end %% czyli część wspólna poniżej:

       if tryb == 1 || tryb == 2 % NPL, GPC
           
           % 8. obliczenie wektora zmiennych decyzyjnych dU(k) -- wspólne GPC i NPL
           Y_zad = y_zad(k)*ones(N,1);
           dU = K*(Y_zad-y_swob);
           % dd(k)=dU(1);
           % dU(1)
           % 9. ograniczenie sygnału u = przycięcie u -- wspólne GPC i NPL
           % 10. u(k) = du(k|k) + u(k-1), gdzie du(k|k) to pierwszy element macierzy dU(k) -- wspólne GPC i NPL
           u_chwilowe = dU(1) + u(k-1);
       elseif tryb == 4 % czyli NO
           x0 = Upp*ones(1,Nu);
           lb = u_min*ones(1,Nu);
           ub = u_max*ones(1,Nu);
           U = fmincon(@NO_fun,x0,[],[],[],[],lb,ub);
           u_chwilowe = U(1);
       end

       if u_chwilowe > u_max
            u(k) = u_max;
       elseif u_chwilowe < u_min
            u(k) = u_min;
       else
            u(k) = u_chwilowe;
       end
       % u(k)
       E = E + (y_zad(k)-y(k))^2;
    end
end

%% PID
if tryb == 3
    for k=kp:kk
        g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
        x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
        x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
        y(k) = 1-exp(-1.5*x1(k));    
        e(k) = y_zad(k)-y(k);
        
        u_chwilowe = r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
        if u_chwilowe > u_max
            u(k) = u_max;
        elseif u_chwilowe < u_min
            u(k) = u_min;
        else
            u(k) = u_chwilowe;
        end
        E = E + (e(k))^2;
    end
end
E
toc

if tryb == 1
    nazwa1 = ['wyniki/zad4/N',num2str(N),'Nu',num2str(Nu),'lambda',num2str(lambda)];
    nazwau = [nazwa1,'/zad4_NPL_u.pdf'];
    nazway = [nazwa1,'/zad4_NPL_y.pdf'];
    mkdir(nazwa1)
elseif tryb == 2
    nazwa1 = ['wyniki/zad4/N',num2str(N),'Nu',num2str(Nu),'lambda',num2str(lambda)];
    nazwau = [nazwa1,'/zad4_GPC_u.pdf'];
    nazway = [nazwa1,'/zad4_GPC_y.pdf'];
    mkdir(nazwa1)
elseif tryb == 3
    nazwa1 = ['wyniki/zad5/Kp',num2str(Kp),'Ti',num2str(Ti),'Td',num2str(Td)];
    nazwau = [nazwa1,'/zad5_PID_u.pdf'];
    nazway = [nazwa1,'/zad5_PID_y.pdf'];
    mkdir(nazwa1)
elseif tryb == 4
    nazwa1 = ['wyniki/zad5/N',num2str(N),'Nu',num2str(Nu),'lambda',num2str(lambda)];
    nazwau = [nazwa1,'/zad5_NO_u.pdf'];
    nazway = [nazwa1,'/zad5_NO_y.pdf'];
    mkdir(nazwa1)
end

figure
plot(y)
hold on
plot(y_zad)
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend('y','y_{zad}',Location='southeast');
title('Przebieg sygnału wyjściowego')
print(nazway,'-dpng','-r400')

figure
plot(u)
xlabel('Numer próbki k');
ylabel('Sygnał wejściowy u');
title('Przebieg sygnału sterującego')
print(nazwau,'-dpng','-r400')