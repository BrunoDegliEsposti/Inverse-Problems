% author: Daniel Tenbrinck
% date: 28.10.2019

%% clean up workspace
clc; clear; close all;

%% load data
load('data.mat');

%% add noise
alpha = 0.000; % 0.001 already shows artifacts in the reconstruction
u = u + alpha*randn(size(u));

%% solve the inverse heat equation with explicit Euler scheme

% set up operator to invert
K = eye(N*N) + deltaT*0.5*L;

% invert explicit Euler scheme
for iteration=1:8
    u = K \ u;
    figure(1); surf(reshape(u,[N,N])); zlim([0,8]); pause(0.3);
end

%%%%% UNTIL HERE EVERYTHING LOOKS FINE...
%%% LET'S SEE WHAT HAPPENS NOW!
disp("Hit any button to proceed!");
pause();

% invert explicit Euler scheme
for iteration=1:10
    u = K \ u;
    figure(1); surf(reshape(u,[N,N])); zlim([0,8]); pause(0.3);
end
