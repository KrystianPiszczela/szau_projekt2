clear;
kk=2000;
dane()
 x1 = zeros(kk,1); x2 = zeros(kk,1); g1 = zeros(kk,1);

q = zeros(kk,4);
q4= zeros(kk,4);
q3= zeros(kk,4);
q2 = zeros(kk,4);
q1 = zeros(kk,4);
y_ob(1:kk) = 0;
teta=3;
delta=1e-5;
N=50;
Nu=40;
lambda=1;
yzad(1:0.2*kk) = 0;
yzad(0.2*kk:0.4*kk) = -1.5;
yzad(0.4*kk:0.6*kk) = 0.5;
yzad(0.6*kk:0.8*kk) = -0.5;
yzad(0.8*kk:kk) = 0.2;
Umax=1;
Umin=-1;
u=zeros(1,kk);

% model 10
% w1 = [  0.837855557720000	0.537623788030000	-0.527480061830000	0.325355085070000;
%        -0.164515237720000	-1.68221184020000	-0.435061362040000	0.287804582400000;
%         0.0318494435000000	0.0971777605730000	0.600810108080000	-0.0598320173550000;
%         0.146562544840000	0.262693775460000	-0.437834660980000	0.100113572720000;
%         0.147535948800000	0.00867886016980000	0.883161422130000	-0.281300269580000;
%         0.753318288730000	0.863501314550000	0.540112525600000	-0.625011671950000;
%         0.0506607099320000	-0.788357174680000	-0.193439145180000	0.610021456910000;
%        -0.479004568230000	0.0187763435870000	-0.00100566860730000	-0.360833900880000;
%         0.609669610890000	0.0283834579020000	-0.660120996400000	0.572849445510000;
%         0.327410703540000	0.364779708890000	0.502562201670000	-0.777979486560000];
% w10 = [0.207914743650000;0.514717052250000;0.770488850280000;0.032513195532000;-0.593041214910000;-0.008541593466500;0.823412053540000;0.267804458440000;-0.094402080445000;-0.425570713760000];
% w2 = [0.207027340480000,-0.056335143491000,1.123231194100000,-0.541637689230000,1.002195694000000,-0.187201762070000,0.315217157660000,-0.112488322810000,-0.533483848400000,0.585752029640000];
% w20 = -0.192428603290000;

% % model 5
% w1 = [0.276134889170000	-0.145910840010000	-0.0466093788780000	0.442971988050000;
% 0.408151593640000	-0.215967238180000	-1.45289059650000	1.26341425060000;
% 0.269954985190000	-0.144204040170000	-0.143429891770000	0.505233169760000;
% -1.52595507460000	0.177224725910000	-0.557914721560000	-0.0350879415370000;
% 0.545674776390000	2.30000930380000	0.842733183760000	-0.640530739630000];
% w10 = [-0.745117574340000;-0.179842978860000;0.589705697560000;-0.977625234720000;0.028113640999000];
% w2 = [1.400801584800000,-1.315475929800000,1.559078509900000,0.033019117462000,-0.013408361599000];
% w20 = -0.149064204170000;

% nie wiem
w1 = [0.539959307120000	0.327703526470000	-0.392463737090000	0.857193999220000;
     -0.986353071190000	0.356048120960000	-1.49596797440000	1.24140425820000;
      2.40101416100000	1.43500916830000	0.683498181190000	-0.529387636720000;
     -0.115456604740000	0.0938220360600000	0.337703768190000	-0.0270994622870000;
      0.107194268110000	-0.0393608587270000	-0.419950692560000	0.120560326270000];
w10 = [0.220366325290000;-0.219135657680000;0.841477614640000;0.719870560680000;0.589079289460000];
w2 = [-0.068711898795000,-0.379895067500000,-0.059407367179000,2.027516709000000,-2.460876481600000];
w20 = 0.025333989958000;


for k=5:kk
    g1(k-3) = (exp(4.75*u(k-3))-1)/(exp(4.75*u(k-3))+1);
    x1(k) = -alfa1*x1(k-1) + x2(k-1) + beta1*g1(k-3);
    x2(k) = -alfa2*x1(k-1) + beta2*g1(k-3);
    y_ob(k) = 1-exp(-1.5*x1(k));
    q(k,:) = [u(k-teta) u(k-teta-1) y_ob(k-1) y_ob(k-2)];
    q1(k,:) = [u(k-teta)+delta u(k-teta-1) y_ob(k-1) y_ob(k-2)];
    q2(k,:) = [u(k - teta) u(k-teta-1)+delta y_ob(k-1) y_ob(k-2)];
    q3(k,:) = [u(k-teta) u(k-teta-1) y_ob(k-1)+delta y_ob(k-2)];
    q4(k,:) = [u(k-teta) u(k-teta-1) y_ob(k-1) y_ob(k-2)+delta];
    y(k) = w20 + w2*tanh(w10 + w1*q(k,:)');
    b5 =  (w20 + w2*tanh(w10 + w1*q1(k,:)') - y(k))/delta
    b6 =  (w20 + w2*tanh(w10 + w1*q2(k,:)') - y(k))/delta
    b = [0,0,b5,b6];
    a1 =  - (w20 + w2*tanh(w10 + w1*q3(k,:)') - y(k))/delta
    a2 =  - (w20 + w2*tanh(w10 + w1*q4(k,:)') - y(k))/delta
    a = [a1,a2];
    d(k) = y_ob(k) -y(k);
    Y_swobodne(1:N) = 0 ;
    for i=1:N
        if i>=3
            q_pred(i,:) = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) Y_swobodne(i-1) Y_swobodne(i-2)];
        elseif i==2
            q_pred(i,:) = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) Y_swobodne(i-1) y_ob(k)];
        else
            q_pred(i,:) = [u(k+min(-1,-teta+i)) u(k+min(-1,-teta+i-1)) y_ob(k-1+i) y_ob(k-2+i)];
        end
        Y_swobodne(i) = w20 + w2*tanh(w10 + w1*q_pred(i,:)')+ d(k);
    end
    s(1:N) = 0;
    for j=1:N
        b_czlon = 0;
        a_czlon = 0;
        for i=1:min(j,length(b))
            b_czlon = b_czlon + b(i);
        end
        for p = 1:min(j-1,length(a))
             a_czlon = a_czlon + (a(p) * s(j-p));
        end
        s(j) = b_czlon - a_czlon;
    end
    figure(4)
    plot(s)
    M = zeros(N,Nu);
    % Macierz M
        for i = 1:N
            for j = 1:Nu
                if (i-j+1) > 0
                    M(i,j) = s(i-j+1);
                end
            end
        end
        Alpha = eye(Nu, Nu) * lambda;
        Yzadk = yzad(k) * ones(N, 1);
        K = inv(M' * M + Alpha) * M';
        dU = K * (Yzadk - Y_swobodne');
        u(k) = dU(1) + u(k-1);
        u(k) = max(min(u(k), Umax), Umin);
        e = (yzad -y_ob).^2;
end

figure(5)
plot(y)
hold on
plot(yzad)