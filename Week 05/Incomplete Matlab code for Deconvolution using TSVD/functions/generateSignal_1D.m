%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Copyright (2019) Friedrich-Alexander-Universität Erlangen-Nürnberg
%%% This file is distributed as is under the GNU GPL license.
%%%
%%% generateSignal_1D.m
%%%
%%% This script generates a disrete 1D signal consisting of many points as
%%% ground truth signal for convolution/deconvolution tasks.
%%% This is inspired by the signal as described in: 
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
function u = generateSignal_1D()

% initialize u as zero vector
u = zeros(1000,1);

% generate linearly increasing slope
for i=50:200
    u(i) = 1.5 * (i - 50);
end

% generate small plateau
for i=201:250
    u(i) = 225;
end

% generate linearly decreasing slope
for i=251:400
    u(i) = -1.5 * (i - 250) + 225;
end

%generate low-level plateau 1
for i=450:499
    u(i) = 32;
end

%generate mid-level plateau 2
for i=500:549
    u(i) = 64;
end

%generate low-level plateau 1
for i=550:599
    u(i) = 32;
end

%generate mid-level plateau 3
for i=600:649
    u(i) = 128;
end

%generate mid-level plateau 2
for i=650:699
    u(i) = 64;
end

%generate high-level plateau 4
for i=700:749
    u(i) = 196;
end

%generate mid-level plateau 3
for i=750:799
    u(i) = 128;
end

%generate high-level plateau 5
for i=800:849
    u(i) = 256;
end

%generate high-level plateau 4
for i=850:900
    u(i) = 196;
end

end

