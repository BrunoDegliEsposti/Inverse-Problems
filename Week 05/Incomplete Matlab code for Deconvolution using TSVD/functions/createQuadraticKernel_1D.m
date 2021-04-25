%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Copyright (2019) Friedrich-Alexander-Universität Erlangen-Nürnberg
%%% This file is distributed as is under the GNU GPL license.
%%%
%%% createQuadraticKernel_1D.m
%%%
%%% This function generates a quadratic kernel function for specified
%%% kernel width. As described in [1].
%%%
%%% Input:
%%%     n = Number of discretization points for the interval [0,1]
%%%     kernel_width = A scalar value to specify the kernel width. This
%%%                    should be smaller than 0.5.
%%%
%%% \author: Daniel Tenbrinck
%%% \date: 11.11.2019
%%%
%%% [1] Jennifer L. Müller, Samuli Siltanen: Linear and Nonlinear Inverse 
%%% Problems with Practical Applications. SIAM Computational Science &
%%% Engineering (2012)
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function p = createQuadraticKernel_1D(n, kernel_width)

% compute step width 
h = 1 / n;

% compute half width of kernel function in pixels
half_width = floor(kernel_width / h );

% initialize vector to contain samples of the kernel function
p = zeros(1, 2*half_width+1);

% extract grid points relevant to the kernel function
relevant_grid = linspace(-half_width*h, half_width*h, numel(p));

% compute sample of kernel function for each relevant grid point
for i = 1:numel(p)
    p(i) = (kernel_width - relevant_grid(i))^2 * (kernel_width + relevant_grid(i))^2;
end

% normalize kernel function
p = p / sum(p(:));

end

