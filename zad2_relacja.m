figure
scatter(y_mod_wer, y_wer)
xlabel('y_{mod}');
ylabel('y');
title('Relacja danych weryfikujących')
print('wyniki/zad2/zad27_rel_wer.pdf','-dpng','-r400')

figure
scatter(y_mod_ucz, y_ucz)
xlabel('y_{mod}');
ylabel('y');
title('Relacja danych uczących')
print('wyniki/zad2/zad27_rel_ucz.pdf','-dpng','-r400')