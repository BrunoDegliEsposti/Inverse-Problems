% This code is based on the code provided by Jennifer Mueller and Samuli
% Siltanen, October 2012
%
% To execute this code please run scripts Ex1_ContinuousData and
% Ex2_DiscreteData first
%%

close all;
clear;
clc;

if isOctave()
    pkg load communications
end

load('datasetDiscreteData.mat');


%% compute reconstructions 

% compute reconstruction from data with inverse crime
reconIC = A\mIC(:);

% Compute reconstruction from ideal data without inverse crime
recon   = A\m(:);

% Compute reconstruction from noisy data without inverse crime
reconN  = A\mn(:);


%% plot naive reconstruction from ideal data with inverse crime
fid1        = get(figure('Name', 'Naive reconstruction from ideal data with inverse crime'));
ax1         = get(gca);
box off;
hold on;

% plot target
plot(x,target,'k','linewidth',.5);

% plot naive reconstruction
plot(xx,reconIC,'b.','markersize',6);
plot(xx,reconIC,'b');

% set axis settings
ax1.XLim    = [0, 1];
ax1.YLim    = [-.2, 1.6];
ax1.XTick   = [0,.5,1];
ax1.YTick   = [0,.5,1,1.5];
ax1.FontSize    = 12;
ax1.PlotBoxAspectRatio  = [2 1 1];


%% plot naive reconstruction from ideal data without inverse crime
fid2        = get(figure('Name', 'Naive reconstruction from ideal data with inverse crime'));
ax2         = get(gca);
box off;
hold on;

% plot target
plot(x,target,'k','linewidth',.5);

% plot naive reconstruction
plot(xx,recon,'b.','markersize',6);
plot(xx,recon,'b');

% set axis settings
ax2.XLim    = [0, 1];
ax2.YLim    = [-.2, 1.6];
ax2.XTick   = [0,.5,1];
ax2.YTick   = [0,.5,1,1.5];
ax2.FontSize    = 12;
ax2.PlotBoxAspectRatio  = [2 1 1];


%% plot naive reconstruction from ideal data without inverse crime
fid3        = get(figure('Name', 'Naive reconstruction from ideal data with inverse crime'));
ax3         = get(gca);
box off;
hold on;

% plot target
plot(x,target,'k','linewidth',.5);

% plot naive reconstruction
plot(xx,reconN,'b.','markersize',6);
plot(xx,reconN,'b');

% set axis settings
ax3.XLim    = [0, 1];
ax3.YLim    = [-.2, 1.6];
ax3.XTick   = [0,.5,1];
ax3.YTick   = [0,.5,1,1.5];
ax3.FontSize    = 12;
ax3.PlotBoxAspectRatio  = [2 1 1];

