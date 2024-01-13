figure
plot(y_wer);
hold on;
plot(y_mod_wer, '--', LineWidth=1.8);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='east');
title('Dane weryfikujące')
print('wyniki/zad2/zad27_sym_wer.pdf','-dpng','-r400')

%print('wyniki/zad2/zad26_zmiana_bledow.pdf','-dpng','-r400')

figure
plot(y_ucz);
hold on;
plot(y_mod_ucz, '--', LineWidth=1.8);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='southeast');
title('Dane uczące')
print('wyniki/zad2/zad27_sym_ucz.pdf','-dpng','-r400')