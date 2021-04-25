%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Copyright (2019) Friedrich-Alexander-Universität Erlangen-Nürnberg
%%% This file is distributed as is under the GNU GPL license.
%%%
%%% naiveMatrixInversion_Deconvolution_1D.m
%%%
%%% This script performs naive deconvolution of a discrete 1D signal with a 
%%% quadratic kernel function and user defined parameters. As described in: 
%%% [1, ch.2.1.2].
%%%
%%% \author: Daniel Tenbrinck
%%% \date: 11.11.2019
%%%
%%% [1] Jennifer L. Müller, Samuli Siltanen: Linear and Nonlinear Inverse 
%%% Problems with Practical Applications. SIAM Computational Science &
%%% Engineering (2012)
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tidy up
close all; clc;

% add subdirectory with needed functions
addpath('./functions');

%%%%%%%%%%%%%%%%%%%% generate ground truth 1D signal using many points

u = generateSignal_1D();

% plot continuous 1D signal
h =figure(1); plot(u,'linewidth',2); legend('Ground truth signal u');
set(h, 'units','normalized','position',[0.5 0.5 1.0 1.0]);
axis image; axis([0 1000 0 300]); 

pause;

%%%%%%%%%%%%%%%%%%%%% Create quadratic kernel function

% set amount of discretization points
n = 1000; % for n=lenght(u(:)) (=1000) this is an inverse crime!

% define kernel width in the normalized interval 0 < kernel_width < 1/2
kernel_width = 0.04;

% create 1D quadratic kernel function with given parameters 
p = createQuadraticKernel_1D(n, kernel_width);

% plot 1D kernel function
figure(1); plot(p,'g','linewidth',2); legend('Quadratic kernel function p');

pause;


%%%%%%%%%%%%%%%%%%%%%% Simulate measurement by convolution
%%% WARNING: INVERSE CRIME!!! Amount of sample points is equal to grid size

% generate circular matrix for 1D convolution based on kernel function p
A = generateConvolutionMatrix_1D(p,n);

% convolve discretize function f using matrix multiplication
m = A * u;

% plot convolved data m and original data u
figure(1); plot(u,'linewidth',2); 
hold on; plot(m,'r','linewidth',2); 
legend('Continuous signal u', 'Convolved data m');
hold off
axis image; axis([0 1000 0 300]); 

pause;


%%%%%%%%%%%%%%%%%%%%%% Perform naive deconvolution of m by inversion of A

% perform naive deconvolution
x = A \ m;

% plot convolved data and the result of naive deconvolution
figure(1); subplot(2,1,1);
plot(u,'linewidth',2); 
hold on; plot(m,'r','linewidth',2); 
legend('Continuous signal u', 'Convolved data m'); 
hold off
axis image; axis([0 1000 0 300]); 
subplot(2,1,2)
plot(x,'b','linewidth',2);
legend('Reconstructed signal x');
axis image; axis([0 1000 0 300]); 

pause


%%%%%%%%%%%%%%%%%%%%% Generate Gaussian noise

% generate normally distributed random noise
eta = random('norm', 0, 1, size(u));

% add noise to convolved data
n = m + eta; 

% visualize noise and noisy signal
figure(1); subplot(2,1,1);
plot(eta,'linewidth',2); 
legend('Additive Gaussian noise eta'); 
hold off
axis([0 1000 -5 5]); 
subplot(2,1,2)
plot(n,'b','linewidth',2);
legend('Noisy signal n');
axis image; axis([0 1000 0 300]); 

pause


%%%%%%%%%%%%%%%%%%%%%% Perform naive deconvolution of n by inversion of A

% perform naive deconvolution
x = A \ n;

% plot convolved data and the result of naive deconvolution
figure(1); subplot(2,1,1);
plot(u,'linewidth',2); 
hold on; plot(n,'r','linewidth',2); 
legend('Continuous signal u', 'Convolved data m'); 
hold off
axis image; axis([0 1000 0 300]); 
subplot(2,1,2)
plot(x,'b','linewidth',2);
legend('Reconstructed signal x');