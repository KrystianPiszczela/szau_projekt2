clear
dane()
kp=4;
kk=2000;

u_ucz = zeros(kk,1);
x1_ucz = zeros(kk,1);
x2_ucz = zeros(kk,1);
g1_ucz = zeros(kk,1);
y_ucz = zeros(kk,1);

u_wer = zeros(kk,1);
x1_wer = zeros(kk,1);
x2_wer = zeros(kk,1);
g1_wer = zeros(kk,1);
y_wer = zeros(kk,1);

for i=1:50:kk
    u_ucz(i:i+49) = -1 + 2*rand;
    u_wer(i:i+49) = -1 + 2*rand;
end

for k=kp:kk
    g1_ucz(k-3) = (exp(4.75*u_ucz(k-3))-1)/(exp(4.75*u_ucz(k-3))+1);
    x1_ucz(k) = -alfa1*x1_ucz(k-1) + x2_ucz(k-1) + beta1*g1_ucz(k-3);
    x2_ucz(k) = -alfa2*x1_ucz(k-1) + beta2*g1_ucz(k-3);
    y_ucz(k) = 1-exp(-1.5*x1_ucz(k));

    g1_wer(k-3) = (exp(4.75*u_wer(k-3))-1)/(exp(4.75*u_wer(k-3))+1);
    x1_wer(k) = -alfa1*x1_wer(k-1) + x2_wer(k-1) + beta1*g1_wer(k-3);
    x2_wer(k) = -alfa2*x1_wer(k-1) + beta2*g1_wer(k-3);
    y_wer(k) = 1-exp(-1.5*x1_wer(k));
end


t = 1:kk;
figure
plot(y_ucz)
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
title('Dane uczące');
plot_data = [t' y_ucz];
save('wyniki/zad1/zad1_dane_uczace_y.txt','plot_data', '-ascii')
plot_data = [t' u_ucz];
save('wyniki/zad1/zad1_dane_uczace_u.txt','plot_data', '-ascii')
plot_data = [u_ucz y_ucz];
save('wyniki/zad1/zad1_dane_uczace_sieci.txt','plot_data', '-ascii')

figure
plot(y_wer)
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
title('Dane weryfikujące');
plot_data = [t' y_wer];
save('wyniki/zad1/zad1_dane_weryfikujace_y.txt','plot_data', '-ascii')
plot_data = [t' u_wer];
save('wyniki/zad1/zad1_dane_weryfikujace_u.txt','plot_data', '-ascii')
plot_data = [u_wer y_wer];
save('wyniki/zad1/zad1_dane_weryfikujace_sieci.txt','plot_data', '-ascii')