clear;
clf;
clc;
close all;

Nx = 300;
xs = linspace(0, 1, Nx);
N_fouriermodes = 150;

% set initial condition
a0 = zeros(N_fouriermodes,1);
% random initial condition
% a0 = normrnd(0, 1, N_fouriermodes, 1);
ns = 1:2:N_fouriermodes;
% triangle wave
a0(1:2:N_fouriermodes) = 8./(pi^2.*ns.^2).*(-1).^((ns-1)/2);
% random perturbation
a0 = a0 + normrnd(zeros(N_fouriermodes, 1), 0.05*(1./(1:N_fouriermodes))', N_fouriermodes, 1);
% square wave
% a0(1:2:N_fouriermodes) = 4./(ns*pi);

m1 = min(evalFourier(xs, a0));
m2 = max(evalFourier(xs, a0));

% plot initial condition

% let time progress
figure();
T = 0.001;
dt = 0.00005;
for t=0:dt:T
  subplot(211);
  ks = (1:N_fouriermodes)';
  
  at = a0;
  at = at .* exp(-t*pi^2*ks.^2);
  
  plot(xs, evalFourier(xs, a0), 'k');
  hold on;
  plot(xs, evalFourier(xs, at), 'b');
  hold off;
  ylim([1.1*m1, 1.1*m2])
  subplot(212);
  plot(a0, 'k');
  hold on;
  plot(at, 'b');
  hold off;
  pause(0.05)
end

figure();
  subplot(211);
plot(xs, evalFourier(xs, a0), 'k');
hold on;
plot(xs, evalFourier(xs, at), 'b');
% get data
sigma = 0.00001;
aT = at;

m = aT + sigma*randn(N_fouriermodes,1);

hold on;
plot(xs,  evalFourier(xs, m), 'r');
  subplot(212);
plot(a0, 'k');
plot(aT, 'b');
plot(m, 'r');

%% NOW RUN BACKWARD WITH NOISY DATA

% for t=0:dt/1e2:T
%   subplot(211);
%   ks = (1:N_fouriermodes)';
%   
%   at = m;
%   at = at .* exp(t*pi^2*ks.^2); % no minus this time!
%   
%   plot(xs, evalFourier(xs, a0), 'k');
%   hold on;
%   plot(xs, evalFourier(xs, at), 'b');
%   hold off;
%   ylim([1.1*m1, 1.1*m2])
%   subplot(212);
%   plot(a0, 'k');
%   hold on;
%   plot(at, 'b');
%   hold off;
%   pause(0.05)
% end

%% RUN BACKWARD WITH NOISY DATA m AND TSVD

K = 10;
for t=0:dt/3:T
  subplot(211);
  ks = (1:N_fouriermodes)';
  
  at = m;
  at(K:end) = 0; % after 26, we get artifacts
  at = at .* exp(t*pi^2*ks.^2);
  
  plot(xs, evalFourier(xs, a0), 'k');
  hold on;
  plot(xs, evalFourier(xs, at), 'b');
  hold off;
  ylim([1.1*m1, 1.1*m2])
  subplot(212);
  plot(a0, 'k');
  hold on;
  plot(at, 'b');
  hold off;
  pause(0.05)
end

%% RUN BACKWARD WITH NOISY DATA m AND TIKHONOV

alpha = 0.1;
for t=0:dt:T
  subplot(211);
  ks = (1:N_fouriermodes)';
  
  coeff = exp(-t*pi^2*ks.^2);
  at = m.*coeff./(coeff.^2+alpha);
  
  plot(xs, evalFourier(xs, a0), 'k');
  hold on;
  plot(xs, evalFourier(xs, at), 'b');
  hold off;
  ylim([1.1*m1, 1.1*m2])
  subplot(212);
  plot(a0, 'k');
  hold on;
  plot(at, 'b');
  hold off;
  drawnow;
  pause(0.05)
end







