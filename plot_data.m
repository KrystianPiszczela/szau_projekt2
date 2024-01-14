function plot_data(x, y, title_text)
figure;
plot(cell2mat(x), '-', 'LineWidth',1);
hold on;
plot(cell2mat(y), '--', 'LineWidth',1.5); 
legend("Dane","Wyjście sieci", Location="northeast")
title("Wyjście sieci neuronowej " + title_text)
xlabel("Numer próbki - k")
ylabel("Wartość na wyjściu")
figure;
scatter(cell2mat(x), cell2mat(y))
xlabel("Wartość na wyjściu - dane")
ylabel("Wartość na wyjściu sieci")
title("Relacja danych i wyjścia sieci neuronowej " + title_text)