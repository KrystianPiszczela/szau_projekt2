clear
dane_wer = load('wyniki/zad1/zad1_dane_weryfikujace_sieci.txt');
dane_ucz = load('wyniki/zad1/zad1_dane_uczace_sieci.txt');
u_wer = dane_wer(:,1);
y_wer = dane_wer(:,2);
u_ucz = dane_ucz(:,1);
y_ucz = dane_ucz(:,2);

kp = 5;
P = length(u_ucz);

y_mod_ucz = zeros(P,1);
y_mod_ucz(1:kp-1) = y_ucz(1:kp-1);
y_mod_wer = zeros(P,1);
y_mod_wer(1:kp-1) = y_wer(1:kp-1);
E_ucz = 0;
E_wer = 0;

Y_ucz = y_ucz(kp:end);
Y_wer = y_wer(kp:end);

M_ucz = [u_ucz(2:P-3) u_ucz(1:P-4) y_ucz(4:P-1) y_ucz(3:P-2)];
M_wer = [u_wer(2:P-3) u_wer(1:P-4) y_wer(4:P-1) y_wer(3:P-2)];

w = M_ucz\Y_ucz;

for k=kp:P
    y_mod_ucz(k)= w(1)*u_ucz(k-3) + w(2)*u_ucz(k-4) + w(3)*y_mod_ucz(k-1) + w(4)*y_mod_ucz(k-2);
    E_ucz = E_ucz + (y_mod_ucz(k)-y_ucz(k))^2; 
    y_mod_wer(k)= w(1)*u_wer(k-3) + w(2)*u_wer(k-4) + w(3)*y_mod_wer(k-1) + w(4)*y_mod_wer(k-2);
    E_wer = E_wer + (y_mod_wer(k)-y_wer(k))^2;
end
E_wer
E_ucz   

figure
plot(y_mod_wer);
hold on;
plot(y_wer);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='east');
title('Dane weryfikujące')
print('wyniki/zad2/zad28_kwad_wer.pdf','-dpng','-r400')

figure
plot(y_mod_ucz);
hold on;
plot(y_ucz);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='southeast');
title('Dane uczące')
print('wyniki/zad2/zad28_kwad_ucz.pdf','-dpng','-r400')

save('wyniki/zad2/2_8_wsp_kwadraty.txt', 'w', '-ascii')