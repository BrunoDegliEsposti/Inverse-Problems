% author: Daniel Tenbrinck
% date: 28.10.2019

%% clean up workspace
clc; clear; close all;

%% setup parameters
N = 21; % number of discretization points
maxIterations = 25; % number of time steps
deltaT = 0.2; % time step size
boundaryConditions = 'Neumann'; % possible values: 'Dirichlet', 'Neumann'

%% initialize starting condition

% we assume a heat source at initial time t=0 in the center of the domain
u0 = zeros(N);
u0(ceil(N/2)-4:ceil(N/2)+4, ceil(N/2)-4:ceil(N/2)+4) = 10;

%% set up Laplacian matrix
switch boundaryConditions
    case 'Dirichlet'
        
        % construct main diagonal
        L = diag(-4*ones(1,N*N),0);
        
        % construct minor diagonals
        L = L + diag(ones(1,N*N-1),1);
        L = L + diag(ones(1,N*N-1),-1);
        L = L + diag(ones(1,N*(N-1)),N);
        L = L + diag(ones(1,N*(N-1)),-N);
        
        figure; imagesc(L);
    case 'Neumann'
        
        % construct main diagonal
        v = -4*ones(N,N);
        v(1,1) = -2;
        v(1,N) = -2;
        v(N,1) = -2;
        v(N,N) = -2;
        v(2:N-1,1) = -3; % left side
        v(2:N-1,N) = -3; % right side
        v(1,2:N-1) = -3; % top side
        v(N,2:N-1) = -3; % bottom side
        v = v(:);
        L = diag(v,0);
        
        % construct minor diagonals
        v2 = ones(1,N*N-1);
        v2(N:N:end) = 0;
        L = L + diag(v2,1);
        L = L + diag(v2,-1);
        L = L + diag(ones(1,N*(N-1)),N);
        L = L + diag(ones(1,N*(N-1)),-N);

    otherwise
        error('Please use either Dirichlet or Neumann as boundary condition!');
end

%% solve heat equation with explicit Euler scheme

% set starting conditions
u = u0(:);

% use explicit Euler scheme
for iteration=1:maxIterations
    
    % give some output on the current energy level in the system
    disp(['The total heat in Omega is currently: ' num2str(sum(u(:)))]);

    % perform explicit Euler step
    u = u + deltaT * L*u;
    
    % plot numerical solution
    figure(1); 
    surf(reshape(u,[N,N])); zlim([0,10]);
    pause(0.1);
end

%% save result for solving the inverse problem
save('data.mat', 'L', 'u', 'N', 'deltaT', 'iteration', 'maxIterations');
