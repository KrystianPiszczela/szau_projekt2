dane_wer = load('wyniki/zad1/zad1_dane_weryfikujace_sieci.txt');
dane_ucz = load('wyniki/zad1/zad1_dane_uczace_sieci.txt');
rng(4)
input_delay = 3:4;
output_delay = 1:2;
neuron_number = 10;
net = narxnet(3:4, 1:2, neuron_number);
net.trainParam.min_grad=1e-12;
X = dane_ucz(:, 1);
Y = dane_ucz(:, 2);
X = tonndata(X,false,false);
Y = tonndata(Y,false,false);
[Xs,Xi,Ai,Ts] = preparets(net,X,{},Y);
net.trainFcn = 'trainlm';
net.divideFcn = '';
net.trainParam.epochs = 500;
net.layers{1}.transferFcn = 'tansig';
net = train(net, Xs, Ts, Xi, Ai);  
Y_pred = sim(net, Xs, Xi, Ai);
e_train_arx = sum((cell2mat(Y_pred) -cell2mat(Ts)).^2);
e_train_arx
plot_data(Ts, Y_pred, "ARX - zbiór uczący")
X_wer = dane_wal(:, 1);
Y_wer = dane_wal(:, 2);
X_wer = tonndata(X_wer,false,false);
Y_wer = tonndata(Y_wer,false,false);
[Xs_wer, Xi_wer, Ai_wer, Ts_wer] = preparets(net, X_wer,{}, Y_wer);
Y_pred_wer = sim(net, Xs_wer, Xi_wer, Ai_wer);
e_wer_arx = sum((cell2mat(Y_pred_wer) -cell2mat(Ts_wer)).^2);
e_wer_arx
plot_data(Ts_wer, Y_pred_wer, "ARX - zbiór weryfikujący")
net_closed = closeloop(net);
[Xs_oe,Xi_oe,Ai_oe,Ts_oe] = preparets(net_closed,X,{},Y);
Y_pred_oe = sim(net_closed, Xs_oe, Xi_oe, Ai_oe);
e_train_oe = sum((cell2mat(Y_pred_oe) -cell2mat(Ts_oe)).^2);
e_train_oe
plot_data(Ts_oe, Y_pred_oe, "OE - zbiór uczący")
[Xs_oe_wer, Xi_oe_wer, Ai_oe_wer, Ts_oe_wer] = preparets(net_closed, X_wer,{}, Y_wer);
Y_pred_oe_wer = sim(net_closed, Xs_oe_wer, Xi_oe_wer, Ai_oe_wer);
e_wer_oe = sum((cell2mat(Y_pred_oe_wer) -cell2mat(Ts_oe_wer)).^2);
e_wer_oe
plot_data(Ts_oe_wer, Y_pred_oe_wer, "OE - zbiór weryfikujący")