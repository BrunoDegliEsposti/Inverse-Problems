%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Copyright (2019) Friedrich-Alexander-Universität Erlangen-Nürnberg
%%% This file is distributed as is under the GNU GPL license.
%%%
%%% TSVD_Deconvolution_1D.m
%%%
%%% This script performs regularized deconvolution of a discrete 1D signal 
%%% with a known quadratic kernel function and user defined parameters using
%%% the truncated singular value decomposition. As described in: 
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

%%%%%%%%%%%%%%%%%%%% generate 'continuous' 1D signal using many points

u = generateSignal_1D();


%%%%%%%%%%%%%%%%%%%%% Create quadratic kernel function

% set amount of discretization points
n = 1000; % for n=length(u(:)) (=1000) this is an inverse crime!

% define kernel width in the normalized interval 0 < kernel_width < 1/2
kernel_width = 0.04;

% create 1D quadratic kernel function with given parameters 
p = createQuadraticKernel_1D(n, kernel_width);


%%%%%%%%%%%%%%%%%%%%%% Simulate measurement by convolution

% generate circular matrix for 1D convolution based on kenel function p
A = generateConvolutionMatrix_1D(p,length(u));

% convolve ground truth signal u using matrix multiplication
m = A * u;

% generate normally distributed random noise
eta = random('norm', 0, 1, size(u));

% add noise to convolved data
n = m + eta; 

% plot noisy data n and original data u
h = figure(1); 
set(h, 'units','normalized','position',[0.5 0.5 1.0 1.0]);
plot(u,'linewidth',2); 
hold on; plot(n,'r','linewidth',2); 
legend('Continuous signal u', 'Noisy data n');
hold off
axis image; axis([0 1000 0 300]); 

pause;


%%%%%%%%%%%%%%%%%%%%%%% Analyze singular value decomposition (SVD) of A

% compute SVD of A
[U, S, V] = svd(A);

% plot singular values of A
h = figure(1); plot(diag(S),'linewidth',2); legend('Singular values of A');
set(h, 'units','normalized','position',[0.5 0.5 1.0 1.0]);

% give some user output
disp(['The condition of the diagonal matrix S is: ' num2str(cond(S))]);

pause;


%%%%%%%%%%%%%%%%%%%%%%% Apply truncated singular value decomposition (TSVD)

% define array of thresholds for smallest singular value
thresholds = [0.001, 0.01, 0.1, 0.5, 0.95];

for t = thresholds
    
    % compute TSVD of A according to threshold t
    [U, S_t, V] = TSVD(A,t);
    
    % compute approximated linear operator A^+
    A_dagger = U * S_t * V';
       
    % estimate x by computing x = V * S_t^-1 * U' * n
    x = V * inv(S_t) * U' * n;
    
    % plot convolved data and the result of naive deconvolution
    figure(1);
    plot(u,'b','linewidth',2);
    hold on; plot(n,'--r','linewidth',2);
    plot(x,'--k','linewidth',2);
    legend('Continuous signal u', 'Noisy data n', ['Reconstructed signal x for t = ' num2str(t)]);
    hold off
    axis image; axis([0 1000 0 300]);
    
    % give some user output
    disp(['For t=' num2str(t) ' the condition of the regularized diagonal matrix S_t is: ' num2str(cond(S_t))]);
    
    pause
end
