%% Parameters
Ngt = 501;  % N ground truth
Nds = 252;  % N downsample, MCD(500,251) = 1
xgt = linspace(0,1,Ngt);
xds = linspace(0,1,Nds);
T = 0.002;  % or maybe 0.002

f = @(x) x.*(1-x)+sin(8*pi*x)+sin(13*pi*x)+0.5*sin(23*pi*x);
u0 = f(xgt)';

sigma = 0.001;  % or maybe 0.01
noise = randn(Nds,1);

%% Best TSVD Reconstruction

Kbest = 1;
errbest = +Inf;
for K = 15:35
    [err,~,~] = heat_TSVD(u0,Ngt,Nds,T,sigma,noise,K,2);
    if err < errbest
        Kbest = K;
        errbest = err;
    end
end
[~,uT,uR] = heat_TSVD(u0,Ngt,Nds,T,sigma,noise,Kbest,2);
figure(1);
plot(xgt,u0,'r');
hold on;
plot(xgt,uT,'g');
plot(xds,uR,'b');
title('TSVD');
hold off;

%% Best Tikhonov Reconstruction

opt = @(alpha) heat_tikhonov(u0,Ngt,Nds,T,sigma,noise,10^alpha,2);
alphabest = 10^fminsearch(opt,-6);
[errbest2,uT,uR] = heat_tikhonov(u0,Ngt,Nds,T,sigma,noise,5e-6,2);
figure(2);
plot(xgt,u0,'r');
hold on;
plot(xgt,uT,'g');
plot(xds,uR,'b');
title('Tikhonov');
hold off;






