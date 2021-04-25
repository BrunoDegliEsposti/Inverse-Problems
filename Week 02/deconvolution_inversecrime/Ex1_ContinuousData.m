% This code is based on the code provided by Jennifer Mueller and Samuli
% Siltanen, October 2015
%
%%
close all;
clear;
clc;

if isOctave()
  pkg load communications
end


%%
% Parameter that specifies the width of the PSF, must satisfy 0<a<1/2. 
% The support of the building block of the PSF is [-a,a], and this 
% building block is replicated at each integer to produce a periodic
% function.
a           = 0.04;

% Choose the 'continuum' points at which to compute the convolved function.
% Here 'continuum' is in quotation marks because it is not really continuum
% but rather very finely sampling compared to the samplings used in
% computational inversion.
Nx          = 2000;
x           = linspace(0,1,Nx);

% derive target
target      = myTarget(x);

% Create numerical integration points. We take quite a fine sampling here
% to ensure accurate approximation of the comvolution integral.
NxPSF       = 1000;
xPSF        = linspace(-a,a,NxPSF);
DxPSF       = xPSF(2)-xPSF(1);

% Evaluate normalized PSF at integration points
psf         = zeros(size(xPSF));
ind         = abs(xPSF)<a;
psf(ind)    = myPSF(xPSF(ind),a);
Ca          = DxPSF*trapz(psf);
psf         = psf/Ca; % Normalization constant

% Initialize result
Af          = zeros(size(x));
for i = 1:Nx
   targ     = myTarget(x(i)-xPSF);
   Af(i)    = DxPSF*trapz(psf.*targ);
   
   if mod(i,floor(Nx/20))==0
       fprintf('#');
   end
end
fprintf('\n');


%% save data for later use in script Ex2_DiscreteData
if isOctave()
    save('-mat7-binary', 'datasetContinuousData.mat', 'x', 'Af', 'a', 'Ca', 'psf', 'xPSF', 'target');
else  
    save('datasetContinuousData.mat', 'x', 'Af', 'a', 'Ca', 'psf', 'xPSF', 'target');
end


%% Plot the results
fid         = get(figure('Name', 'Ground Truth and Convoluted Data'));
ax          = get(gca);
box off;
hold on;

% plot target and its convolution
plot(x,target,'k','linewidth',.5)
plot(x,Af,'r','linewidth',.5)

% plot legend and set axis settings
legend('Ground Truth', 'Convoluted Data');
ax.xlim     = [0,1];
ax.xtick    = [0,.5,1];
ax.ylim     = [0,1.6];
ax.ytick    = [0,.5,1,1.3,1.5];
ax.fontsize = 12;
ax.PlotBoxAspectRatio = [2 1 1];

