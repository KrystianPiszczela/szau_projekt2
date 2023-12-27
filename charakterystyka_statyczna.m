clear
dane();
u=u_min:0.05:u_max;
stala = (beta1+beta2)/(1 + alfa1 + alfa2);

for i=1:size(u,2)
    g1 = (exp(4.75*u(i))-1)/(exp(4.75*u(i))+1);
    y(i) = 1-exp(stala*g1);
end

figure
plot(u,y);
xlabel('Sygnał wejściowy u');
ylabel('Sygnał wyjściowy y');
title('Charakterystyka statyczna y(u)');
plot_data = [u' y'];
save('wyniki/zad1/zad1_char_stat.txt','plot_data', '-ascii')

