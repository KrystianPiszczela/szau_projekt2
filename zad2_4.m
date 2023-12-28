figure
plot(y_mod_wer);
hold on;
plot(y_wer);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='southeast');
title('Dane weryfikujące')
% print('wyniki/zad2/zad27_sym_wer.pdf','-dpng','-r400')
%print('wyniki/zad2/zad2_zmiana_bledow.pdf','-dpng','-r400')

figure
plot(y_mod_ucz);
hold on;
plot(y_ucz);
xlabel('Numer próbki k');
ylabel('Sygnał wyjściowy y');
legend(' y_{mod}','y',Location='southeast');
title('Dane uczące')
% print('wyniki/zad2/zad27_sym_ucz.pdf','-dpng','-r400')