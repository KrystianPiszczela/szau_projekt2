clear
run('sieci/uczenie.m')
run('sieci/model.m')
dane_wer = load('wyniki/zad1/zad1_dane_weryfikujace_sieci.txt');
dane_ucz = load('wyniki/zad1/zad1_dane_uczace_sieci.txt');
u_wer = dane_wer(:,1);
y_wer = dane_wer(:,2);
u_ucz = dane_ucz(:,1);
y_ucz = dane_ucz(:,2);
kp=5;
kk=2000;
y_mod_wer = zeros(kk,1);
y_mod_ucz = zeros(kk,1);
E_wer = 0;
E_ucz = 0;
rekurencja = true;

if rekurencja
    for k=kp:kk
        q_wer = [u_wer(k-3);u_wer(k-4);y_mod_wer(k-1);y_mod_wer(k-2)];
        y_mod_wer(k) = w20 + w2*tanh(w10+w1*q_wer);
        E_wer = E_wer + (y_mod_wer(k)-y_wer(k))^2;
        q_ucz = [u_ucz(k-3);u_ucz(k-4);y_mod_ucz(k-1);y_mod_ucz(k-2)];
        y_mod_ucz(k) = w20 + w2*tanh(w10+w1*q_ucz);
        E_ucz = E_ucz + (y_mod_ucz(k)-y_ucz(k))^2;
    end
else
    for k=kp:kk
        q_wer = [u_wer(k-3);u_wer(k-4);y_wer(k-1);y_wer(k-2)];
        y_mod_wer(k) = w20 + w2*tanh(w10+w1*q_wer);
        E_wer = E_wer + (y_mod_wer(k)-y_wer(k))^2;
        q_ucz = [u_ucz(k-3);u_ucz(k-4);y_ucz(k-1);y_ucz(k-2)];
        y_mod_ucz(k) = w20 + w2*tanh(w10+w1*q_ucz);
        E_ucz = E_ucz + (y_mod_ucz(k)-y_ucz(k))^2;
    end
end
disp(E_wer);
disp(E_ucz);    

t = 1:kk;
figure
plot(y_mod_wer);
hold on;
plot(y_wer);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y');

nazwa = ['wyniki/zad2/5warstw_v2/zad22_E_',num2str(E_wer),'.mat'];
save(nazwa)