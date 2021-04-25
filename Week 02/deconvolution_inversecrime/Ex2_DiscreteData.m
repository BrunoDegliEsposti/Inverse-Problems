% This code is based on the code provided by Jennifer Mueller and Samuli
% Siltanen, October 2012

% To execute this code please run script Ex1_ContinuousData first
%%
close all;
clear;
clc;

if isOctave()
    pkg load communications
end

load('datasetContinuousData.mat');


%% Construct discretization points
Nxx   = 64;
xx    = linspace(0,1,Nxx);
Dxx   = xx(2)-xx(1);

% Choose two noise levels. We compute three kinds of data: no added noise,
% and noisy data with noise amplitude given by sigma
sigma = 0.01;


%% compute high-resolution data with no inverse crime
% Interpolate values of the convolution at points xx using the precomputed
% values on the fine grid called x
m = interp1(x,Af,xx,'spline');

% Create data with random measurement noise and no inverse crime
noise = sigma*max(abs(m))*randn(size(m));
mn    = m + noise;

% Compute the amount of simulated measurement noise in mn
relerr = max(abs(m-mn))/max(abs(m));
relerr2 = norm(m-mn)/norm(m);
fprintf('Relative sup norm error in mn is %i\n', relerr);
fprintf('Relative square norm error in mn is %i\n', relerr2);


%% construct matrix model and compute data _with_ inverse crime
% Construct normalized discrete point spread function
nPSF = ceil(a/Dxx); 
xPSF = (-nPSF:nPSF).*Dxx;
PSF  = zeros(size(xPSF));
ind   = abs(xPSF)<a;
PSF(ind) = myPSF(xPSF(ind),a);
Ca   = 1/(Dxx*trapz(PSF));
PSF  = Ca*PSF;

% Construct convolution matrix
A   = Dxx*myConvMatrix(PSF,Nxx);

% Compute ideal data WITH INVERSE CRIME
f   = myTarget(xx);
mIC = A*f(:);


%% save data for later use in script Ex3_NaiveRecon
if isOctave()
    save('-mat7-binary', 'datasetDiscreteData.mat', 'A', 'x', 'xx', 'Nxx', 'm', 'mn', 'mIC', 'sigma', 'target');
else  
    save('datasetDiscreteData.mat', 'A', 'x', 'xx', 'Nxx', 'm', 'mn', 'mIC', 'sigma', 'target');
end


%% First plot: sampled no-crime convolution data with and without noise
fid1        = get(figure('Name', 'No Inverse Crime: w\ and w\o noise'));
ax1         = get(gca);
box off;
hold on;

% plot target and its convolution
plot(x,myTarget(x),'k','linewidth',.5);
plot(x,Af,'r','linewidth',.5);

% plot data and noisy data
plot(xx,m,'r.','markersize',8);
plot(xx,mn,'b.','markersize',8)

% plot legend and set axis settings
legend('Ground Truth','Cont. Convolution','No-crime data with no added noise',sprintf('No-crime data with %i%% noise', round(100*sigma)));
ax1.XLim    = [0, 1];
ax1.YLim    = [-.2, 1.6];
ax1.XTick   = [0,.5,1];
ax1.YTick   = [0,.5,1,1.5];
ax1.FontSize    = 12;
ax1.PlotBoxAspectRatio  = [2 1 1];


%% Second plot: convolution matrix
fid2        = get(figure('Name', 'Nonzero elements of convolution matrix A'));

% Show nonzero entries of matrix A
spy(A);
title('Nonzero elements of convolution matrix A')


%% Third plot: sampled data with inverse crime
fid3        = get(figure('Name', 'Data with inverse crime'));
ax3         = get(gca);
box off;
hold on;

% plot target and its convolution
plot(x,myTarget(x),'k','linewidth',.5)
plot(x,Af,'r','linewidth',.5)

% plot data points with inverse crime
plot(xx,mIC,'b.','markersize',8)

% plot legend and set axis settings
legend('Ground Truth','Cont. Convolution','Data with inverse crime');
ax3.XLim    = [0, 1];
ax3.YLim    = [-.2, 1.6];
ax3.XTick   = [0,.5,1];
ax3.YTick   = [0,.5,1,1.5];
ax3.FontSize    = 12;
ax3.PlotBoxAspectRatio  = [2 1 1];

